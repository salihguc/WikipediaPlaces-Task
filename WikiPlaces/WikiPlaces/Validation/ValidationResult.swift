//
//  ValidationResult.swift
//  WikiPlaces
//
//  Created by sg on 22.02.2026.
//

import Foundation

struct ValidationResult: Equatable {
    let isValid: Bool
    let message: String
    
    static let valid = ValidationResult(isValid: true, message: "")
    
    static func invalid(message: String) -> ValidationResult {
        ValidationResult(isValid: false, message: message)
    }
}
