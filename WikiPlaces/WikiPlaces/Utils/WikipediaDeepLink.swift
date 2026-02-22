//
//  WikipediaDeepLink.swift
//  WikiPlaces
//
//  Created by sg on 22.02.2026.
//

import Foundation

enum WikipediaDeepLink {
    case places(latitude: Double, longitude: Double)
    
    var url: URL? {
        switch self {
        case .places(let latitude, let longitude):
            var components = URLComponents()
            components.scheme = "wikipedia"
            components.host = "places"
            components.path = "/"
            components.queryItems = [
                URLQueryItem(name: "WMFLatitude", value: String(latitude)),
                URLQueryItem(name: "WMFLongitude", value: String(longitude))
            ]
            return components.url
        }
    }
}
