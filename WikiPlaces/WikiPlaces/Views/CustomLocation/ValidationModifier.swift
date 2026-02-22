//
//  ValidationModifier.swift
//  WikiPlaces
//
//  Created by sg on 22.02.2026.
//

import Foundation
import SwiftUI

private struct ValidationModifier: ViewModifier {
    @Environment(\.formValidator) private var formValidator
    let validation: () -> ValidationResult
    
    private var result: ValidationResult { validation() }
    private var shouldShowError: Bool {
        formValidator?.showErrors == true && !result.isValid
    }
    
    func body(content: Content) -> some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.small) {
            content
            if shouldShowError {
                HStack(spacing: DesignSystem.Spacing.small) {
                    Image(systemName: DesignSystem.Icons.error)
                    Text(result.message)
                        .font(.caption)
                        .foregroundStyle(DesignSystem.Colors.error)
                }
            }
        }
        .preference(key: ValidationPreferenceKey.self, value: [result])
    }
}

private struct ValidatedFormModifier: ViewModifier {
    let validator: FormValidator
    
    func body(content: Content) -> some View {
        content
            .environment(\.formValidator, validator)
            .onPreferenceChange(ValidationPreferenceKey.self) { results in
                validator.updateValidity(results: results)
            }
    }
}

extension View {
    func validate(validation: @escaping () -> ValidationResult) -> some View {
        modifier(ValidationModifier(validation: validation))
    }
    
    func validatedForm(validator: FormValidator) -> some View {
        modifier(ValidatedFormModifier(validator: validator))
    }
}
