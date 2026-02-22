//
//  FormValidator.swift
//  WikiPlaces
//
//  Created by sg on 22.02.2026.
//

import Foundation
import SwiftUI

@MainActor
@Observable
final class FormValidator {
    private(set) var showErrors = false
    private(set) var isFormValid = true
    
    func submit() -> Bool {
        showErrors = true
        return isFormValid
    }
    
    func reset() {
        showErrors = false
    }
    
    func updateValidity(results: [ValidationResult]) {
        isFormValid = results.allSatisfy(\.isValid)
    }
}

private struct FormValidatorKey: EnvironmentKey {
    static let defaultValue: FormValidator? = nil
}

extension EnvironmentValues {
    var formValidator: FormValidator? {
        get {
            self[FormValidatorKey.self]
        } set {
            self[FormValidatorKey.self] = newValue
        }
    }
}

struct ValidationPreferenceKey: PreferenceKey {
    static let defaultValue: [ValidationResult] = []
    
    static func reduce(value: inout [ValidationResult], nextValue: () -> [ValidationResult]) {
        value.append(contentsOf: nextValue())
    }
}
