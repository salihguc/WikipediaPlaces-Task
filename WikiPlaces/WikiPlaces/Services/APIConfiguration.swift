//
//  APIConfiguration.swift
//  WikiPlaces
//
//  Created by sg on 23.02.2026.
//

import Foundation

struct APIConfiguration {
    let scheme: String
    let host: String
    let basePath: String

    static let `default` = APIConfiguration(
        scheme: "https",
        host: "raw.githubusercontent.com",
        basePath: "/abnamrocoesd/assignment-ios/main"
    )

    func url(for endpoint: Endpoint) -> URL? {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = basePath + "/" + endpoint.path
        return components.url
    }
}
