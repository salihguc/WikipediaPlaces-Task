//
//  CoordinateValidatorTests.swift
//  WikiPlacesTests
//
//  Created by sg on 23.02.2026.
//

import Testing
@testable import WikiPlaces

struct CoordinateValidatorTests {

    private let latitudeRange: ClosedRange<Double> = -90...90
    private let longitudeRange: ClosedRange<Double> = -180...180

    // MARK: - Valid inputs

    @Test func validLatitude() {
        let result = CoordinateValidator.validate(text: "52.3676", range: latitudeRange)
        #expect(result == nil)
    }

    @Test func validLongitude() {
        let result = CoordinateValidator.validate(text: "4.9041", range: longitudeRange)
        #expect(result == nil)
    }

    @Test func validBoundaryValues() {
        #expect(CoordinateValidator.validate(text: "90", range: latitudeRange) == nil)
        #expect(CoordinateValidator.validate(text: "-90", range: latitudeRange) == nil)
        #expect(CoordinateValidator.validate(text: "180", range: longitudeRange) == nil)
        #expect(CoordinateValidator.validate(text: "-180", range: longitudeRange) == nil)
    }

    @Test func validZero() {
        #expect(CoordinateValidator.validate(text: "0", range: latitudeRange) == nil)
    }

    // MARK: - Empty input

    @Test func emptyStringReturnsError() {
        let result = CoordinateValidator.validate(text: "", range: latitudeRange)
        #expect(result != nil)
    }

    @Test func whitespaceOnlyReturnsError() {
        let result = CoordinateValidator.validate(text: "   ", range: latitudeRange)
        #expect(result != nil)
    }

    // MARK: - Invalid number

    @Test func nonNumericReturnsError() {
        let result = CoordinateValidator.validate(text: "abc", range: latitudeRange)
        #expect(result != nil)
    }

    @Test func specialCharactersReturnError() {
        let result = CoordinateValidator.validate(text: "!@#", range: latitudeRange)
        #expect(result != nil)
    }

    // MARK: - Out of range

    @Test func latitudeAboveMaxReturnsError() {
        let result = CoordinateValidator.validate(text: "91", range: latitudeRange)
        #expect(result != nil)
    }

    @Test func latitudeBelowMinReturnsError() {
        let result = CoordinateValidator.validate(text: "-91", range: latitudeRange)
        #expect(result != nil)
    }

    @Test func longitudeAboveMaxReturnsError() {
        let result = CoordinateValidator.validate(text: "181", range: longitudeRange)
        #expect(result != nil)
    }

    @Test func longitudeBelowMinReturnsError() {
        let result = CoordinateValidator.validate(text: "-181", range: longitudeRange)
        #expect(result != nil)
    }

    // MARK: - Comma normalization

    @Test func commaIsReplacedWithDot() {
        let result = CoordinateValidator.normalized("52,3676")
        #expect(result == "52.3676")
    }

    @Test func dotRemainsUnchanged() {
        let result = CoordinateValidator.normalized("52.3676")
        #expect(result == "52.3676")
    }

    @Test func multipleCommasAreReplaced() {
        let result = CoordinateValidator.normalized("1,2,3")
        #expect(result == "1.2.3")
    }

    @Test func commaInputValidatesSuccessfully() {
        let result = CoordinateValidator.validate(text: "52,3676", range: latitudeRange)
        #expect(result == nil)
    }

    // MARK: - Result convenience

    @Test func resultReturnsValidForGoodInput() {
        let result = CoordinateValidator.result(for: "45.0", range: latitudeRange)
        #expect(result.isValid)
        #expect(result == .valid)
    }

    @Test func resultReturnsInvalidForBadInput() {
        let result = CoordinateValidator.result(for: "", range: latitudeRange)
        #expect(!result.isValid)
    }

    @Test func resultReturnsInvalidForOutOfRange() {
        let result = CoordinateValidator.result(for: "100", range: latitudeRange)
        #expect(!result.isValid)
    }
}
