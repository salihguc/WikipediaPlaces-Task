# WikiPlaces

A SwiftUI iOS app that fetches a list of notable locations and opens them in the [Wikipedia iOS](https://github.com/wikimedia/wikipedia-ios) app's **Places** tab via deep linking. Built as a companion to a modified version of Wikipedia iOS that supports coordinate-based deep links.

## Features

- Fetches locations from a [remote JSON endpoint](https://raw.githubusercontent.com/abnamrocoesd/assignment-ios/main/locations.json)
- Displays locations in a scrollable list with name and coordinates
- Tapping a location opens the Wikipedia app's Places tab at that coordinate
- Custom location entry with real-time coordinate validation
- Full VoiceOver accessibility support with labels, hints, and announcements
- Swift Concurrency throughout (`async/await`, `@MainActor`)
- Zero third-party dependencies

## Requirements

- iOS 17.6+
- Xcode 16+
- The modified Wikipedia iOS app installed on the same device/simulator

## Getting Started

1. Clone the repository:
   ```bash
   git clone <repository-url>
   ```

2. Open the **modified Wikipedia iOS** project and run it on a simulator to install it:
   ```
   wikipedia-ios-main/Wikipedia.xcodeproj
   ```

3. Open the WikiPlaces project:
   ```
   WikiPlaces/WikiPlaces.xcodeproj
   ```

4. Select an iOS simulator (same one where Wikipedia is installed) and press **Cmd+R** to build and run.

5. Tap any location in the list — the Wikipedia app will launch and navigate to that location on the Places map.

> **Note:** If Wikipedia is not installed, the app displays an alert prompting the user to install it.

## How It Works

```
WikiPlaces                                    Wikipedia iOS
─────────────────────────────────────────     ─────────────────────────────────────
1. App launches
2. Fetches locations.json via async/await
3. Displays locations in a List
4. User taps a location
5. Builds deep link URL:
   wikipedia://places/?WMFLatitude=52.37
                      &WMFLongitude=4.90
6. Calls UIApplication.open(url)
                                          →   7. URL scheme handler receives URL
                                              8. Parses WMFLatitude & WMFLongitude
                                              9. Creates NSUserActivity (Places type)
                                              10. Switches to Places tab
                                              11. Calls showLocation(_:) on PlacesVC
                                              12. Map zooms to the coordinate
```

## Wikipedia iOS Modifications

The Wikipedia iOS app already supports the `wikipedia://` URL scheme. A single commit introduces coordinate-based deep linking by modifying **4 files** and adding **1 test file**:

| File | Change |
|------|--------|
| `NSUserActivity+WMFExtensions.h` | Added `wmf_hasCoordinate` and `wmf_coordinate` method declarations |
| `NSUserActivity+WMFExtensions.m` | Extended `wmf_placesActivityWithURL:` to parse `WMFLatitude`/`WMFLongitude` query params, validate bounds, and store in `userInfo`. Added accessor methods |
| `WMFAppViewController.m` | Extended the `WMFUserActivityTypePlaces` handler to check `wmf_hasCoordinate` and call `showLocation:` |
| `PlacesViewController.swift` | Added `showLocation(_:)` method — switches to map view, clears search, zooms to coordinate |
| `NSUserActivity_WMFExtensionsCoordinateDeepLinkTest.m` | Unit tests covering valid/negative/boundary/zero coordinates, missing params, and invalid ranges |

The deep link URL format:
```
wikipedia://places/?WMFLatitude=52.378686&WMFLongitude=4.899697
```

## Project Structure

```
WikiPlaces/
├── WikiPlacesApp.swift                     # Entry point, dependency setup
├── Models/
│   └── Location.swift                      # Location model (Codable, Identifiable)
├── Router/
│   └── AppRouter.swift                     # NavigationStack path management
├── Services/
│   ├── APIConfiguration.swift              # Base URL configuration
│   ├── Endpoint.swift                      # API endpoint definitions
│   ├── LocationService.swift               # Network service (async/await)
│   ├── ServiceError.swift                  # Typed error definitions
│   └── StubLocationService.swift           # Deterministic stub for UI tests
├── Utils/
│   ├── DesignSystem.swift                  # Shared design constants
│   ├── WikipediaDeepLink.swift             # Deep link URL builder
│   └── WikipediaOpener.swift               # Environment-based URL opener
├── Validation/
│   ├── CoordinateValidator.swift           # Lat/lon validation logic
│   ├── FormValidator.swift                 # Form-level validation coordinator
│   └── ValidationResult.swift              # Valid/invalid result type
├── ViewModels/
│   ├── CustomLocationViewModel.swift       # Custom location form state
│   └── LocationsViewModel.swift            # Locations list state machine
├── Views/
│   ├── CustomLocation/
│   │   ├── CustomLocationView.swift        # Custom coordinate entry form
│   │   └── ValidationModifier.swift        # Reusable validation UI modifier
│   └── Locations/
│       ├── LocationRowView.swift           # Single location row
│       └── LocationsListView.swift         # Main locations list
│
├── WikiPlacesTests/                        # Unit tests (Swift Testing)
│   ├── Helpers/
│   │   └── JSONFixture.swift               # Test JSON file loader
│   ├── TestResources/                      # JSON fixtures (valid, empty, invalid…)
│   ├── APIConfigurationTests.swift
│   ├── AppRouterTests.swift
│   ├── CoordinateValidatorTests.swift
│   ├── CustomLocationViewModelTests.swift
│   ├── LocationServiceTests.swift
│   ├── LocationTests.swift
│   ├── LocationsViewModelTests.swift
│   └── ValidationResultTests.swift
│
└── WikiPlacesUITests/                      # UI tests (XCTest, Page Object pattern)
    ├── Screens/
    │   ├── CustomLocationScreen.swift      # Page object for custom location screen
    │   └── LocationsListScreen.swift       # Page object for locations list screen
    ├── WikiPlacesUITests.swift             # End-to-end UI test flows
    └── WikiPlacesUITestsLaunchTests.swift  # Launch screenshot tests
```

## Architecture

### MVVM

The app follows the **Model–View–ViewModel** pattern:

- **Models** — Pure data types (`Location`, `LocationsResponse`) conforming to `Codable`, `Equatable`, and `Identifiable`.
- **ViewModels** — `@MainActor` classes marked `ObservableObject` that expose `@Published` state for views to observe. `LocationsViewModel` uses an enum-based state machine (`ViewState`) with cases `.loading`, `.loaded`, `.empty`, and `.error` to represent the full lifecycle of a fetch operation.
- **Views** — Declarative SwiftUI views that react to ViewModel state changes, with no business logic.

### Service Layer

`LocationServiceProtocol` defines the network contract. `LocationService` provides the real implementation using `async/await`, while `StubLocationService` (compiled only in `DEBUG`) returns deterministic data for UI testing. The service is injected via initializer, making it trivial to swap implementations.

### Navigation

`AppRouter` owns a `NavigationPath` and is shared via `@EnvironmentObject`. Routes are defined as a typed enum (`Route.customLocation`), enabling compile-time safe navigation.

### Wikipedia Integration

`WikipediaOpener` is injected into the SwiftUI environment as a custom `EnvironmentKey`. Views call `openWikipedia(url)` without knowing the implementation details. The modifier handles the "app not installed" case by intercepting the `openURL` result and presenting an alert.

### Validation System

The validation layer uses **SwiftUI ViewModifiers** and **PreferenceKeys**:

- `ValidationModifier` wraps a `TextField`, displays inline error messages, and posts VoiceOver announcements on validation failure.
- `ValidatedFormModifier` collects validation results from all children via `ValidationPreferenceKey` and exposes a `FormValidator` that coordinates submit logic.
- `CoordinateValidator` contains the pure validation rules for latitude and longitude values.

## Testing

### Unit Tests

Built with **Swift Testing** (`@Test`, `#expect`). Coverage includes:

- **Model tests** — `Location` identity, display name, `Codable` decoding with JSON fixtures (valid, empty, null name, missing name, invalid JSON)
- **Service tests** — Network success/failure via `MockURLProtocol` that intercepts `URLSession` requests; serialized suite to avoid global state races
- **ViewModel tests** — State transitions for all `ViewState` cases, re-fetch behavior, alert state
- **Validation tests** — Boundary values, out-of-range, empty input, non-numeric input, comma-to-dot normalization
- **Router tests** — Push, pop, pop-on-empty safety, pop-to-root
- **Deep link tests** — URL scheme, host, query parameter construction

Run unit tests:
```bash
xcodebuild test -project WikiPlaces.xcodeproj -scheme WikiPlacesTests -destination 'platform=iOS Simulator,name=iPhone 16'
```

### UI Tests

Built with **XCTest** using the **Page Object** pattern (`LocationsListScreen`, `CustomLocationScreen`) for readable, maintainable test flows. The app launches with `--uitesting` flag to use `StubLocationService` for deterministic data.

Tests cover:
- Locations list displays all expected items
- Navigation to custom location screen
- Validation errors appear for empty fields on submit
- Back navigation preserves list state

Run UI tests:
```bash
xcodebuild test -project WikiPlaces.xcodeproj -scheme WikiPlacesUITests -destination 'platform=iOS Simulator,name=iPhone 16'
```

## What's Next

### WikiPlaces

- **Offline caching with SwiftData** — Cache fetched locations for offline access and faster subsequent launches
- **Accessibility audit tests** — Use `performAccessibilityAudit()` (iOS 17+) to automate accessibility validation in UI tests
- **Snapshot testing** — Add snapshot tests for visual regression detection across device sizes and themes
- **Localization** — The app uses `String(localized:)` throughout, making it ready for additional languages
- **Search and filter** — Allow users to search or filter the locations list by name or region

### Wikipedia iOS

- **Consolidate `updateViewModeToMap`** — Move `updateViewModeToMap()` inside `showArticleURL:` for consistency with `showLocation:`, which already calls it internally
- **Deep link UI tests** — End-to-end tests that open a deep link URL and verify the Places tab shows the correct location
- **Invalid coordinate feedback** — Show user-facing feedback when deep link coordinates fall outside valid ranges
- **Analytics tracking** — Track deep link usage to understand feature adoption

## Considerations

### WikiPlaces

#### Mono-Repo vs. Git Submodule

The Wikipedia iOS app could be included as a git submodule, keeping the two projects in separate repositories while still allowing a single clone. I chose a **mono-repo** structure because it simplifies the setup for reviewers (one clone, no `git submodule update --init`), keeps all related changes in a single commit history, and avoids submodule pitfalls like detached HEAD states and version pinning complexity. For a production scenario with multiple teams, a submodule or separate repo with a documented dependency would be more appropriate.

#### MVVM over TCA or VIPER

The Composable Architecture (TCA) provides excellent testability and unidirectional data flow but introduces a heavy framework dependency and a steep learning curve for reviewers unfamiliar with it. VIPER adds unnecessary ceremony (Interactor, Presenter, Entity, Router layers) for an app of this size. **MVVM** strikes the right balance: it's the de facto standard for SwiftUI apps, requires no external dependencies, and is immediately understandable.

#### No Third-Party Dependencies

The app has zero external dependencies. `URLSession` handles networking, SwiftUI handles UI, and Swift Testing handles test assertions. This keeps the project simple, avoids supply chain concerns, and ensures the codebase is fully auditable. For a larger app, libraries like Alamofire (networking) or swift-snapshot-testing (UI regression) could add value.

#### Environment-Based Wikipedia Opener vs. Direct `UIApplication.open`

Instead of calling `UIApplication.shared.open(url)` directly from views, `WikipediaOpener` is injected into the SwiftUI environment as a custom action. This provides **testability** (views can be tested without triggering real URL opens), **separation of concerns** (the "app not installed" alert lives in a single modifier at the root level), and **consistency** with SwiftUI's own `openURL` environment pattern.

#### Protocol-Oriented Service Layer

`LocationServiceProtocol` allows swapping the real `LocationService` with `StubLocationService` for UI tests without any runtime conditional logic in production code. The stub is behind `#if DEBUG` to ensure it never ships in release builds.

#### Swift Testing over XCTest for Unit Tests

Swift Testing (`@Test`, `#expect`) provides more expressive assertions, better failure messages, and native integration with Swift concurrency. XCTest is still used for UI tests where `XCUIApplication` requires it.

#### NavigationStack + Router over NavigationView

`NavigationView` is deprecated since iOS 16. `NavigationStack` with a typed `NavigationPath` owned by `AppRouter` enables programmatic navigation, deep linking support, and centralized route management — all important for testability.

#### ViewModifier-Based Validation vs. ViewModel-Only Validation

An alternative approach is to handle all validation logic purely in the ViewModel, with views simply reading error strings from `@Published` properties. While simpler, this couples validation **presentation** (inline errors, VoiceOver announcements, styling) to each individual view. The ViewModifier approach (`ValidationModifier` + `ValidatedFormModifier`) creates a **reusable validation system**: any `TextField` can gain validation by adding `.validate { ... }`, and the `Form` automatically coordinates submit behavior via `PreferenceKey` aggregation. This scales better if the app grows to have multiple forms and ensures consistent validation UX across the app.

#### Enum-Based ViewState vs. Boolean Flags

Instead of tracking state with multiple booleans (`isLoading`, `hasError`, `isEmpty`), `LocationsViewModel` uses a single `ViewState` enum with cases `.loading`, `.loaded([Location])`, `.empty`, and `.error(String)`. This makes **impossible states unrepresentable** — you cannot be simultaneously loading and in an error state. It simplifies the view layer (a single `switch` statement renders the correct UI) and makes state transitions explicit and testable.

### Wikipedia iOS

#### Custom URL Scheme vs. Universal Links (AASA)

Universal Links use HTTPS URLs (e.g., `https://en.wikipedia.org/places?WMFPlaceLatitude=52.35&WMFPlaceLongitude=4.83`) verified via an `apple-app-site-association` (AASA) file hosted on the target domain. This is Apple's recommended approach because it provides a seamless Safari fallback if the app isn't installed, prevents URL scheme hijacking by malicious apps, and ties links to a verified domain. However, Universal Links require server-side control — specifically, hosting an AASA file at `https://wikipedia.org/.well-known/apple-app-site-association`. Since I cannot modify Wikipedia's server infrastructure, this approach is not viable for this assignment. In a real-world scenario where you control the backend, Universal Links would be the preferred choice.

#### Extending Existing Activity Type vs. Separate `WMFUserActivityTypePlacesCoordinate`

Instead of extending the existing `WMFUserActivityTypePlaces` activity type, I could introduce a new enum value (e.g., `WMFUserActivityTypePlacesCoordinate`) with its own routing path through the deep link chain. This would create a distinct handler in `WMFAppViewController`'s activity processing. The advantage is clear separation — coordinate-based navigation would have its own code path entirely independent from article-based navigation. However, the two paths share the same destination (Places tab) and differ only in the data they carry. The existing `userInfo` dictionary already provides a clean way to distinguish between them via `wmf_hasCoordinate`. Adding a new enum value would require touching more files (header enum definition, multiple switch statements) and increases the maintenance surface for what is fundamentally a data variation of the same feature.

#### x-callback-url Protocol

The [x-callback-url specification](https://x-callback-url.com/specification/) enables structured bi-directional inter-app communication with `x-success`, `x-error`, and `x-cancel` callback URLs. A URL would look like `wikipedia://x-callback-url/places?WMFPlaceLatitude=52.35&WMFPlaceLongitude=4.83&x-source=WikiPlaces&x-success=wikiplaces://`. Implementing this would require adding a URL handler for the `x-callback-url` host, a callback manager, threading callbacks through the routing chain (`SceneDelegate` → `NSUserActivity+WMFExtensions` → `WMFAppViewController`), and registering a return URL scheme in WikiPlaces. This is a substantial refactoring effort — the existing URL handling code has zero x-callback-url support. Since only one-way communication is needed (WikiPlaces → Wikipedia), the callback infrastructure is unnecessary for this use case.
