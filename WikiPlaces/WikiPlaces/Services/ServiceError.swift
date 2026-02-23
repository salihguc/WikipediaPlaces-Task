//
//  ServiceError.swift
//  WikiPlaces
//
//  Created by sg on 23.02.2026.
//

import Foundation

enum ServiceError: LocalizedError {
    case invalidURL
    case decodingError(error: Error)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return String(localized: "Invalid URL configuration.")
        case .decodingError:
            return String(localized: "Failed to parse data.")
        }
    }
}
