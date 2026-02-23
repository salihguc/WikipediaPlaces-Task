//
//  Endpoint.swift
//  WikiPlaces
//
//  Created by sg on 23.02.2026.
//

import Foundation

enum Endpoint {
    case locations

    var path: String {
        switch self {
        case .locations:
            return "locations.json"
        }
    }
}
