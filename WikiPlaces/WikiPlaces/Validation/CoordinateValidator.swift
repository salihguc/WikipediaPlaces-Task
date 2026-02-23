//
//  CoordinateValidator.swift
//  WikiPlaces
//
//  Created by sg on 22.02.2026.
//

import Foundation

enum CoordinateValidator {
    static func validate(text: String, range: ClosedRange<Double>) -> String? {
        if text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return String(localized: "This field is required.")
        }
        guard let value = Double(normalized(text)) else {
            return String(localized: "Must be a valid number.")
        }
        
        guard range.contains(value) else {
            return String(localized: "Must be between \(Int(range.lowerBound)) and \(Int(range.upperBound)).")
        }
        
        return nil
    }
    
    static func result(for text: String, range: ClosedRange<Double>) -> ValidationResult {
        if let message = validate(text: text, range: range) {
            return .invalid(message: message)
        }
        return .valid
    }
    
    static func normalized(_ text: String) -> String {
        text.replacingOccurrences(of: ",", with: ".")
    }
}
