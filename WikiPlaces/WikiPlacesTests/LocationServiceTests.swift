//
//  LocationServiceTests.swift
//  WikiPlacesTests
//
//  Created by sg on 23.02.2026.
//

import Testing
import Foundation
@testable import WikiPlaces

@Suite(.serialized)
struct LocationServiceTests {

    // MARK: - Helpers

    private func makeSession(data: Data) -> URLSession {
        let handler: @Sendable (URLRequest) -> (HTTPURLResponse, Data) = { request in
            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )!
            return (response, data)
        }
        MockURLProtocol.handler = handler
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        return URLSession(configuration: config)
    }

    // MARK: - Success

    @Test func fetchLocationsReturnsLocations() async throws {
        let session = makeSession(data: JSONFixture.locations.data)
        let service = LocationService(session: session)
        let locations = try await service.fetchLocations()
        #expect(locations.count == 2)
        #expect(locations[0].name == "Amsterdam")
    }

    @Test func fetchLocationsReturnsEmptyArray() async throws {
        let session = makeSession(data: JSONFixture.locationsEmpty.data)
        let service = LocationService(session: session)
        let locations = try await service.fetchLocations()
        #expect(locations.isEmpty)
    }

    // MARK: - Errors

    @Test func fetchLocationsThrowsOnInvalidJSON() async throws {
        let session = makeSession(data: JSONFixture.locationsInvalid.data)
        let service = LocationService(session: session)
        do {
            _ = try await service.fetchLocations()
            Issue.record("Expected error to be thrown")
        } catch let error as ServiceError {
            guard case .decodingError = error else {
                Issue.record("Expected decodingError, got \(error)")
                return
            }
        }
    }
}

// MARK: - Mock URL Protocol

final class MockURLProtocol: URLProtocol, @unchecked Sendable {
    nonisolated(unsafe) static var handler: (@Sendable (URLRequest) -> (HTTPURLResponse, Data))?

    override class func canInit(with request: URLRequest) -> Bool { true }
    override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }

    override func startLoading() {
        guard let handler = MockURLProtocol.handler else {
            client?.urlProtocol(self, didFailWithError: URLError(.badURL))
            return
        }
        let (response, data) = handler(request)
        client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        client?.urlProtocol(self, didLoad: data)
        client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {}
}
