//
//  CustomLocationViewModel.swift
//  WikiPlaces
//
//  Created by sg on 22.02.2026.
//

import Foundation
import Combine

@MainActor
final class CustomLocationViewModel: ObservableObject {
    @Published var latitude = ""
    @Published var longitude = ""
    
    let latitudeRange: ClosedRange<Double> = -90...90
    let longitudeRange: ClosedRange<Double> = -180...180
    
    @Published var showWikipediaNotInstalledAlert = false
    
    var validateLatitude: ValidationResult {
        CoordinateValidator.result(for: latitude,
                                   range: latitudeRange)
    }
    
    var validateLongitude: ValidationResult {
        CoordinateValidator.result(for: longitude,
                                   range: longitudeRange)
    }
    
    var urlFromLocation: URL? {
        let path = "wikipedia://places/?WMFLatitude=\(latitude)&WMFLongitude=\(longitude)"
        return URL(string: path)
    }
    
    func cannotOpenUrl() {
        showWikipediaNotInstalledAlert = true
    }
}
