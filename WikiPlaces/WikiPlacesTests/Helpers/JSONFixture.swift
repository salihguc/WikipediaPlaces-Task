//
//  JSONFixture.swift
//  WikiPlacesTests
//
//  Created by sg on 23.02.2026.
//

import Foundation

enum JSONFixture: String {
    case locations
    case locationsEmpty = "locations_empty"
    case locationsInvalid = "locations_invalid"
    case locationSingle = "location_single"
    case locationNullName = "location_null_name"
    case locationMissingName = "location_missing_name"

    var data: Data {
        let url = Bundle(for: BundleToken.self)
            .url(forResource: rawValue, withExtension: "json", subdirectory: nil)!
        return try! Data(contentsOf: url)
    }
}

private final class BundleToken {}
