//
//  CustomLocationView.swift
//  WikiPlaces
//
//  Created by sg on 22.02.2026.
//

import SwiftUI

struct CustomLocationView: View {
    @Environment(\.openWikipedia) private var openWikipedia
    
    @StateObject private var viewModel = CustomLocationViewModel()
    @State private var formValidator = FormValidator()
    
    var body: some View {
        Form {
            coordinatesSection
            actionSection
        }
        .validatedForm(validator: formValidator)
        .navigationTitle(String(localized: "Custom Location"))
    }
}

//MARK: - Sections
extension CustomLocationView {
    private var coordinatesSection: some View {
        Section(String(localized: "Coordinates")) {
            TextField(String(localized: "Latitude"), text: $viewModel.latitude)
                .keyboardType(.numbersAndPunctuation)
                .accessibilityHint(String(localized: "Enter a value between minus 90 and 90"))
                .validate {
                    viewModel.validateLatitude
                }
            
            TextField(String(localized: "Longitude"), text: $viewModel.longitude)
                .keyboardType(.numbersAndPunctuation)
                .accessibilityHint(String(localized: "Enter a value between minus 180 and 180"))
                .validate {
                    viewModel.validateLongitude
                }
        }
    }
    
    private var actionSection: some View {
        Section {
            Button {
                if formValidator.submit(),
                   let url = viewModel.urlFromLocation {
                    openWikipedia(url)
                }
            } label: {
                Label(String(localized: "Open in Wikipedia"), systemImage: DesignSystem.Icons.map)
            }
            .accessibilityHint(String(localized: "Opens Wikipedia Places at the entered coordinates"))
        }
    }
}
