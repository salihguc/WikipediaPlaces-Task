//
//  Location.swift
//  WikiPlaces
//
//  Created by sg on 22.02.2026.
//

import Foundation

struct Location: Codable, Equatable, Identifiable {
    let name: String?
    let lat: Double
    let long: Double
    
    var id: String {
        "\(lat),\(long)"
    }
    
    var displayName: String {
        name ?? String(localized: "Unknown location")
    }

    var wikipediaURL: URL? {
        WikipediaDeepLink.places(latitude: lat, longitude: long).url
    }
}

struct LocationsResponse: Codable {
    let locations: [Location]
}
