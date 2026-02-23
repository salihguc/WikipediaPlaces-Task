//
//  WikipediaDeepLinkTests.swift
//  WikiPlacesTests
//
//  Created by sg on 23.02.2026.
//

import Testing
import Foundation
@testable import WikiPlaces

struct WikipediaDeepLinkTests {

    // MARK: - URL construction

    @Test func urlHasWikipediaScheme() {
        let url = WikipediaDeepLink.places(latitude: 0, longitude: 0).url
        #expect(url?.scheme == "wikipedia")
    }

    @Test func urlHasPlacesHost() {
        let url = WikipediaDeepLink.places(latitude: 0, longitude: 0).url
        #expect(url?.host == "places")
    }

    @Test func urlContainsLatitudeQueryItem() {
        let url = WikipediaDeepLink.places(latitude: 52.3676, longitude: 4.9041).url!
        let components = URLComponents(url: url, resolvingAgainstBaseURL: false)!
        let latItem = components.queryItems?.first(where: { $0.name == "WMFLatitude" })
        #expect(latItem?.value == "52.3676")
    }

    @Test func urlContainsLongitudeQueryItem() {
        let url = WikipediaDeepLink.places(latitude: 52.3676, longitude: 4.9041).url!
        let components = URLComponents(url: url, resolvingAgainstBaseURL: false)!
        let lonItem = components.queryItems?.first(where: { $0.name == "WMFLongitude" })
        #expect(lonItem?.value == "4.9041")
    }

    @Test func urlWithNegativeCoordinates() {
        let url = WikipediaDeepLink.places(latitude: -33.8688, longitude: -151.2093).url!
        let components = URLComponents(url: url, resolvingAgainstBaseURL: false)!
        let latItem = components.queryItems?.first(where: { $0.name == "WMFLatitude" })
        let lonItem = components.queryItems?.first(where: { $0.name == "WMFLongitude" })
        #expect(latItem?.value == "-33.8688")
        #expect(lonItem?.value == "-151.2093")
    }

    @Test func urlWithZeroCoordinates() {
        let url = WikipediaDeepLink.places(latitude: 0, longitude: 0).url!
        let components = URLComponents(url: url, resolvingAgainstBaseURL: false)!
        let latItem = components.queryItems?.first(where: { $0.name == "WMFLatitude" })
        let lonItem = components.queryItems?.first(where: { $0.name == "WMFLongitude" })
        #expect(latItem?.value == "0.0")
        #expect(lonItem?.value == "0.0")
    }

    @Test func urlIsNotNil() {
        let url = WikipediaDeepLink.places(latitude: 52.3676, longitude: 4.9041).url
        #expect(url != nil)
    }
}
