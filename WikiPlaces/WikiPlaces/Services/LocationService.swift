//
//  LocationService.swift
//  WikiPlaces
//
//  Created by sg on 22.02.2026.
//

import Foundation

protocol LocationServiceProtocol {
    func fetchLocations() async throws -> [Location]
}

struct LocationService: LocationServiceProtocol {
    private let session: URLSession
    private let configuration: APIConfiguration

    init(session: URLSession = .shared,
         configuration: APIConfiguration = .default) {
        self.session = session
        self.configuration = configuration
    }

    func fetchLocations() async throws -> [Location] {
        guard let url = configuration.url(for: .locations) else {
            throw ServiceError.invalidURL
        }
        let (data, _) = try await session.data(from: url)
        do {
            let response = try JSONDecoder().decode(LocationsResponse.self, from: data)
            return response.locations
        } catch {
            throw ServiceError.decodingError(error: error)
        }
    }
}
