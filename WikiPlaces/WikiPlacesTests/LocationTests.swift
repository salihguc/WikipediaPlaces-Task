//
//  LocationTests.swift
//  WikiPlacesTests
//
//  Created by sg on 23.02.2026.
//

import Testing
import Foundation
@testable import WikiPlaces

struct LocationTests {

    // MARK: - Identifiable

    @Test func idCombinesLatAndLong() {
        let location = Location(name: "Test", lat: 52.3676, long: 4.9041)
        #expect(location.id == "52.3676,4.9041")
    }

    @Test func idWithNegativeCoordinates() {
        let location = Location(name: nil, lat: -33.8688, long: -151.2093)
        #expect(location.id == "-33.8688,-151.2093")
    }

    // MARK: - Display Name

    @Test func displayNameReturnsNameWhenPresent() {
        let location = Location(name: "Amsterdam", lat: 52.3676, long: 4.9041)
        #expect(location.displayName == "Amsterdam")
    }

    @Test func displayNameReturnsFallbackWhenNil() {
        let location = Location(name: nil, lat: 0, long: 0)
        #expect(location.displayName == String(localized: "Unknown location"))
    }

    // MARK: - Wikipedia URL

    @Test func wikipediaURLIsConstructedCorrectly() {
        let location = Location(name: "Test", lat: 52.3676, long: 4.9041)
        let url = location.wikipediaURL
        #expect(url != nil)
        let urlString = url!.absoluteString
        #expect(urlString.contains("wikipedia"))
        #expect(urlString.contains("52.3676"))
        #expect(urlString.contains("4.9041"))
    }

    // MARK: - Equatable

    @Test func locationsWithSameDataAreEqual() {
        let a = Location(name: "Test", lat: 1.0, long: 2.0)
        let b = Location(name: "Test", lat: 1.0, long: 2.0)
        #expect(a == b)
    }

    @Test func locationsWithDifferentDataAreNotEqual() {
        let a = Location(name: "A", lat: 1.0, long: 2.0)
        let b = Location(name: "B", lat: 1.0, long: 2.0)
        #expect(a != b)
    }

    // MARK: - Codable

    @Test func decodesFromJSON() throws {
        let location = try JSONDecoder().decode(Location.self, from: JSONFixture.locationSingle.data)
        #expect(location.name == "Amsterdam")
        #expect(location.lat == 52.3676)
        #expect(location.long == 4.9041)
    }

    @Test func decodesWithNullName() throws {
        let location = try JSONDecoder().decode(Location.self, from: JSONFixture.locationNullName.data)
        #expect(location.name == nil)
    }

    @Test func decodesWithMissingName() throws {
        let location = try JSONDecoder().decode(Location.self, from: JSONFixture.locationMissingName.data)
        #expect(location.name == nil)
    }

    @Test func decodesLocationsResponse() throws {
        let response = try JSONDecoder().decode(LocationsResponse.self, from: JSONFixture.locations.data)
        #expect(response.locations.count == 2)
        #expect(response.locations[0].name == "Amsterdam")
        #expect(response.locations[1].name == nil)
    }

    @Test func decodesEmptyLocationsResponse() throws {
        let response = try JSONDecoder().decode(LocationsResponse.self, from: JSONFixture.locationsEmpty.data)
        #expect(response.locations.isEmpty)
    }

    @Test func failsToDecodeInvalidJSON() {
        #expect(throws: (any Error).self) {
            try JSONDecoder().decode(LocationsResponse.self, from: JSONFixture.locationsInvalid.data)
        }
    }
}
