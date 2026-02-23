//
//  StubLocationService.swift
//  WikiPlaces
//
//  Created by sg on 23.02.2026.
//

import Foundation

#if DEBUG
struct StubLocationService: LocationServiceProtocol {
    private let locations: [Location]

    init(locations: [Location] = StubLocationService.defaultLocations) {
        self.locations = locations
    }

    func fetchLocations() async throws -> [Location] {
        locations
    }

    static let defaultLocations: [Location] = [
        Location(name: "Amsterdam", lat: 52.3676, long: 4.9041),
        Location(name: "Mumbai", lat: 19.0760, long: 72.8777),
        Location(name: "Copenhagen", lat: 55.6761, long: 12.5683)
    ]
}
#endif
