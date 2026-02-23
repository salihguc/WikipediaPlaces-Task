//
//  CustomLocationViewModelTests.swift
//  WikiPlacesTests
//
//  Created by sg on 23.02.2026.
//

import Testing
import Foundation
@testable import WikiPlaces

@MainActor
struct CustomLocationViewModelTests {

    private func makeViewModel(lat: String = "", lon: String = "") -> CustomLocationViewModel {
        let vm = CustomLocationViewModel()
        vm.latitude = lat
        vm.longitude = lon
        return vm
    }

    // MARK: - Validation

    @Test func emptyFieldsAreInvalid() {
        let vm = makeViewModel()
        #expect(!vm.validateLatitude.isValid)
        #expect(!vm.validateLongitude.isValid)
    }

    @Test func validCoordinatesAreValid() {
        let vm = makeViewModel(lat: "52.3676", lon: "4.9041")
        #expect(vm.validateLatitude.isValid)
        #expect(vm.validateLongitude.isValid)
    }

    @Test func latitudeOutOfRangeIsInvalid() {
        let vm = makeViewModel(lat: "91", lon: "0")
        #expect(!vm.validateLatitude.isValid)
    }

    @Test func negativeBoundaryLatitudeIsValid() {
        let vm = makeViewModel(lat: "-90", lon: "0")
        #expect(vm.validateLatitude.isValid)
    }

    @Test func longitudeOutOfRangeIsInvalid() {
        let vm = makeViewModel(lat: "0", lon: "181")
        #expect(!vm.validateLongitude.isValid)
    }

    @Test func negativeBoundaryLongitudeIsValid() {
        let vm = makeViewModel(lat: "0", lon: "-180")
        #expect(vm.validateLongitude.isValid)
    }

    @Test func nonNumericIsInvalid() {
        let vm = makeViewModel(lat: "abc", lon: "def")
        #expect(!vm.validateLatitude.isValid)
        #expect(!vm.validateLongitude.isValid)
    }

    // MARK: - URL from location

    @Test func urlFromLocationWithValidInput() {
        let vm = makeViewModel(lat: "52.3676", lon: "4.9041")
        let url = vm.urlFromLocation
        #expect(url != nil)
        #expect(url!.scheme == "wikipedia")
    }

    @Test func urlFromLocationWithCommaInput() {
        let vm = makeViewModel(lat: "52,3676", lon: "4,9041")
        let url = vm.urlFromLocation
        #expect(url != nil)
    }

    @Test func urlFromLocationWithInvalidInputReturnsNil() {
        let vm = makeViewModel(lat: "abc", lon: "def")
        #expect(vm.urlFromLocation == nil)
    }

    @Test func urlFromLocationWithEmptyInputReturnsNil() {
        let vm = makeViewModel()
        #expect(vm.urlFromLocation == nil)
    }

    @Test func urlFromLocationWithNegativeCoordinates() {
        let vm = makeViewModel(lat: "-33.8688", lon: "-151.2093")
        let url = vm.urlFromLocation
        #expect(url != nil)
        let urlString = url!.absoluteString
        #expect(urlString.contains("-33.8688"))
        #expect(urlString.contains("-151.2093"))
    }

    @Test func urlFromLocationWithZeroCoordinates() {
        let vm = makeViewModel(lat: "0", lon: "0")
        #expect(vm.urlFromLocation != nil)
    }

    // MARK: - Ranges

    @Test func latitudeRangeIsCorrect() {
        let vm = makeViewModel()
        #expect(vm.latitudeRange == -90...90)
    }

    @Test func longitudeRangeIsCorrect() {
        let vm = makeViewModel()
        #expect(vm.longitudeRange == -180...180)
    }
}
