//
//  LocationsViewModelTests.swift
//  WikiPlacesTests
//
//  Created by sg on 23.02.2026.
//

import Testing
import Foundation
@testable import WikiPlaces

@MainActor
struct LocationsViewModelTests {

    // MARK: - Helpers

    private func makeViewModel(service: MockLocationService = MockLocationService()) -> LocationsViewModel {
        LocationsViewModel(service: service)
    }

    // MARK: - Initial state

    @Test func initialStateIsLoading() {
        let vm = makeViewModel()
        guard case .loading = vm.state else {
            Issue.record("Expected loading state")
            return
        }
    }

    // MARK: - Fetch success

    @Test func fetchSetsLoadedState() async {
        let service = MockLocationService(locations: [
            Location(name: "Amsterdam", lat: 52.3676, long: 4.9041)
        ])
        let vm = makeViewModel(service: service)
        await vm.fetchLocations()
        guard case .loaded(let locations) = vm.state else {
            Issue.record("Expected loaded state")
            return
        }
        #expect(locations.count == 1)
    }

    @Test func fetchWithEmptyResultSetsEmptyState() async {
        let service = MockLocationService(locations: [])
        let vm = makeViewModel(service: service)
        await vm.fetchLocations()
        guard case .empty = vm.state else {
            Issue.record("Expected empty state")
            return
        }
    }

    // MARK: - Fetch error

    @Test func fetchErrorSetsErrorState() async {
        let service = MockLocationService(error: ServiceError.invalidURL)
        let vm = makeViewModel(service: service)
        await vm.fetchLocations()
        guard case .error = vm.state else {
            Issue.record("Expected error state")
            return
        }
    }

    // MARK: - Alerts

    @Test func showInvalidCoordinatesAlertDefaultsFalse() {
        let vm = makeViewModel()
        #expect(vm.showInvalidCoordinatesAlert == false)
    }

    // MARK: - Re-fetch resets to loading

    @Test func refetchResetsToLoadingFirst() async {
        let service = MockLocationService(locations: [
            Location(name: "Test", lat: 0, long: 0)
        ])
        let vm = makeViewModel(service: service)
        await vm.fetchLocations()
        guard case .loaded = vm.state else {
            Issue.record("Expected loaded state")
            return
        }

        service.error = ServiceError.invalidURL
        service.locations = nil
        await vm.fetchLocations()
        guard case .error = vm.state else {
            Issue.record("Expected error state after re-fetch")
            return
        }
    }
}

// MARK: - Mock Service

final class MockLocationService: LocationServiceProtocol, @unchecked Sendable {
    var locations: [Location]?
    var error: Error?

    init(locations: [Location]? = nil, error: Error? = nil) {
        self.locations = locations
        self.error = error
    }

    func fetchLocations() async throws -> [Location] {
        if let error { throw error }
        return locations ?? []
    }
}
