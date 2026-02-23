//
//  LocationsListScreen.swift
//  WikiPlacesUITests
//
//  Created by sg on 23.02.2026.
//

import XCTest

struct LocationsListScreen {
    private let app: XCUIApplication

    init(app: XCUIApplication) {
        self.app = app
    }

    // MARK: - Elements

    var navigationBar: XCUIElement {
        app.navigationBars["Places"]
    }

    var locationsList: XCUIElement {
        app.collectionViews.firstMatch
    }

    var customLocationButton: XCUIElement {
        app.buttons["Custom Location"]
    }

    // MARK: - Assertions
    @discardableResult
    func assertNavigationBarExists(timeout: TimeInterval = 5) -> Self {
        XCTAssertTrue(navigationBar.waitForExistence(timeout: timeout), "Places navigation bar should exist")
        return self
    }

    func assertLocationsLoaded(timeout: TimeInterval = 10) -> Self {
        XCTAssertTrue(locationsList.waitForExistence(timeout: timeout), "Locations list should be visible")
        return self
    }

    func assertCustomLocationButtonExists() -> Self {
        XCTAssertTrue(customLocationButton.exists, "Custom Location button should exist")
        return self
    }

    func assertLocationCellExists(_ name: String) -> Self {
        XCTAssertTrue(app.staticTexts[name].exists, "Location cell '\(name)' should exist")
        return self
    }

    // MARK: - Actions

    @discardableResult
    func tapCustomLocationButton() -> CustomLocationScreen {
        customLocationButton.tap()
        return CustomLocationScreen(app: app)
    }

    func waitForLocationsToLoad(timeout: TimeInterval = 10) -> Self {
        _ = locationsList.waitForExistence(timeout: timeout)
        return self
    }
}
