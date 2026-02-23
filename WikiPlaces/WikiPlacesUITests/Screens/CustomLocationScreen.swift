//
//  CustomLocationScreen.swift
//  WikiPlacesUITests
//
//  Created by sg on 23.02.2026.
//

import XCTest

struct CustomLocationScreen {
    private let app: XCUIApplication

    init(app: XCUIApplication) {
        self.app = app
    }

    // MARK: - Elements

    var navigationBar: XCUIElement {
        app.navigationBars["Custom Location"]
    }

    var latitudeField: XCUIElement {
        app.textFields["Latitude"]
    }

    var longitudeField: XCUIElement {
        app.textFields["Longitude"]
    }

    var openButton: XCUIElement {
        app.buttons["Open in Wikipedia"]
    }

    var backButton: XCUIElement {
        app.navigationBars.buttons.firstMatch
    }

    var requiredFieldError: XCUIElement {
        app.staticTexts["This field is required."]
    }

    // MARK: - Assertions

    func assertNavigationBarExists(timeout: TimeInterval = 3) -> Self {
        XCTAssertTrue(navigationBar.waitForExistence(timeout: timeout), "Custom Location navigation bar should exist")
        return self
    }

    func assertCoordinateFieldsExist() -> Self {
        XCTAssertTrue(latitudeField.exists, "Latitude field should exist")
        XCTAssertTrue(longitudeField.exists, "Longitude field should exist")
        return self
    }

    func assertOpenButtonExists() -> Self {
        XCTAssertTrue(openButton.exists, "Open in Wikipedia button should exist")
        return self
    }

    func assertValidationErrorVisible(timeout: TimeInterval = 2) -> Self {
        XCTAssertTrue(requiredFieldError.waitForExistence(timeout: timeout), "Validation error should be visible")
        return self
    }

    // MARK: - Actions

    func tapOpenButton() -> Self {
        openButton.tap()
        return self
    }

    func enterCoordinates(latitude: String, longitude: String) -> Self {
        latitudeField.tap()
        latitudeField.typeText(latitude)
        longitudeField.tap()
        longitudeField.typeText(longitude)
        return self
    }

    @discardableResult
    func tapBack() -> LocationsListScreen {
        backButton.tap()
        return LocationsListScreen(app: app)
    }
}
