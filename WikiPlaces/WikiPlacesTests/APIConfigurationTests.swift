//
//  APIConfigurationTests.swift
//  WikiPlacesTests
//
//  Created by sg on 23.02.2026.
//

import Testing
import Foundation
@testable import WikiPlaces

struct APIConfigurationTests {

    // MARK: - Endpoint

    @Test func locationsEndpointPath() {
        #expect(Endpoint.locations.path == "locations.json")
    }

    // MARK: - Default configuration

    @Test func defaultConfigurationHasHTTPS() {
        #expect(APIConfiguration.default.scheme == "https")
    }

    @Test func defaultConfigurationHasCorrectHost() {
        #expect(APIConfiguration.default.host == "raw.githubusercontent.com")
    }

    @Test func defaultConfigurationBuildsValidURL() {
        let url = APIConfiguration.default.url(for: .locations)
        #expect(url != nil)
    }

    @Test func defaultConfigurationURLContainsEndpointPath() {
        let url = APIConfiguration.default.url(for: .locations)!
        #expect(url.absoluteString.contains("locations.json"))
    }

    @Test func defaultConfigurationURLContainsBasePath() {
        let url = APIConfiguration.default.url(for: .locations)!
        #expect(url.absoluteString.contains("abnamrocoesd/assignment-ios/main"))
    }

    @Test func defaultConfigurationURLHasCorrectScheme() {
        let url = APIConfiguration.default.url(for: .locations)!
        #expect(url.scheme == "https")
    }

    // MARK: - Custom configuration

    @Test func customConfigurationBuildsURL() {
        let config = APIConfiguration(
            scheme: "http",
            host: "example.com",
            basePath: "/api/v1"
        )
        let url = config.url(for: .locations)
        #expect(url != nil)
        #expect(url!.scheme == "http")
        #expect(url!.host == "example.com")
        #expect(url!.absoluteString.contains("locations.json"))
    }

    // MARK: - ServiceError

    @Test func invalidURLErrorHasDescription() {
        let error = ServiceError.invalidURL
        #expect(error.errorDescription != nil)
    }

    @Test func decodingErrorHasDescription() {
        let underlyingError = NSError(domain: "test", code: 0)
        let error = ServiceError.decodingError(error: underlyingError)
        #expect(error.errorDescription != nil)
    }
}
