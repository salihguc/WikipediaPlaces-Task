//
//  ValidationResultTests.swift
//  WikiPlacesTests
//
//  Created by sg on 23.02.2026.
//

import Testing
@testable import WikiPlaces

struct ValidationResultTests {

    @Test func validResultIsValid() {
        let result = ValidationResult.valid
        #expect(result.isValid)
        #expect(result.message.isEmpty)
    }

    @Test func invalidResultIsNotValid() {
        let result = ValidationResult.invalid(message: "Error")
        #expect(!result.isValid)
        #expect(result.message == "Error")
    }

    @Test func validResultsAreEqual() {
        #expect(ValidationResult.valid == ValidationResult.valid)
    }

    @Test func invalidResultsWithSameMessageAreEqual() {
        let a = ValidationResult.invalid(message: "Error")
        let b = ValidationResult.invalid(message: "Error")
        #expect(a == b)
    }

    @Test func invalidResultsWithDifferentMessagesAreNotEqual() {
        let a = ValidationResult.invalid(message: "Error 1")
        let b = ValidationResult.invalid(message: "Error 2")
        #expect(a != b)
    }

    @Test func validAndInvalidAreNotEqual() {
        #expect(ValidationResult.valid != ValidationResult.invalid(message: ""))
    }
}
