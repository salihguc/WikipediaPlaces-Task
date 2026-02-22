//
//  CustomLocationView.swift
//  WikiPlaces
//
//  Created by sg on 22.02.2026.
//

import SwiftUI

struct CustomLocationView: View {
    @Environment(\.openURL) private var openURL
    
    @StateObject private var viewModel = CustomLocationViewModel()
    @State private var formValidator = FormValidator()
    
    var body: some View {
        Form {
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
            
            Section {
                Button {
                    if formValidator.submit(),
                       let url = viewModel.urlFromLocation {
                        openURL(url) { accepted in
                            if !accepted {
                                viewModel.cannotOpenUrl()
                            }
                        }
                    }
                } label: {
                    Label(String(localized: "Open in Wikipedia"), systemImage: DesignSystem.Icons.map)
                }
                .accessibilityHint(String(localized: "Opens Wikipedia Places at the entered coordinates"))
            }
        }
        .navigationTitle(String(localized: "Custom Location"))
        .validatedForm(validator: formValidator)
        .alert(String(localized: "Wikipedia Not Installed"),
               isPresented: $viewModel.showWikipediaNotInstalledAlert) {
            Button(String(localized: "OK"), role: .cancel) {}
        } message: {
            Text(String(localized: "Install the Wikipedia app to view locations on the map."))
        }
    }
}
