//
//  LocationService.swift
//  WikiPlaces
//
//  Created by sg on 22.02.2026.
//

import Foundation

enum LocationServiceError: LocalizedError {
    case decodingError(error: Error)
    
    var errorDescription: String? {
        switch self {
        case .decodingError(let error):
            return String(localized: "Failed to parse locations data")
        }
    }
}

protocol LocationServiceProtocol {
    func fetchLocations() async throws -> [Location]
}

struct LocationService: LocationServiceProtocol {
    private let session: URLSession
    private let url: URL
    
    init(session: URLSession = .shared,
         url: URL = URL(string: "https://raw.githubusercontent.com/abnamrocoesd/assignment-ios/main/locations.json")!) {
        self.session = session
        self.url = url
    }
    
    
    func fetchLocations() async throws -> [Location] {
        let (data, urlResponse) = try await session.data(from: url)
        do {
            let response = try JSONDecoder().decode(LocationsResponse.self, from: data)
            return response.locations
        } catch {
            throw LocationServiceError.decodingError(error: error)
        }
    }
}
