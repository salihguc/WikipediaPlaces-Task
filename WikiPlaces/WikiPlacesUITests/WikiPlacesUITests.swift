//
//  WikiPlacesUITests.swift
//  WikiPlacesUITests
//
//  Created by sg on 22.02.2026.
//

import XCTest

final class WikiPlacesUITests: XCTestCase {

    private var app: XCUIApplication!
    private var locationsScreen: LocationsListScreen!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments = ["--uitesting"]
        app.launch()
        locationsScreen = LocationsListScreen(app: app)
    }

    // MARK: - Locations List
    
    @MainActor
    func testLocationsListDisplaysLocations() {
        locationsScreen
            .assertNavigationBarExists()
            .assertLocationsLoaded()
            .assertLocationCellExists("Amsterdam")
            .assertLocationCellExists("Mumbai")
            .assertLocationCellExists("Copenhagen")
            .assertCustomLocationButtonExists()
            .tapCustomLocationButton()
            .assertNavigationBarExists()
            .assertCoordinateFieldsExist()
            .assertOpenButtonExists()
            .tapOpenButton()
            .assertValidationErrorVisible()
            .tapBack()
            .assertNavigationBarExists()
    }
}
