//
//  WikiPlacesApp.swift
//  WikiPlaces
//
//  Created by sg on 22.02.2026.
//

import SwiftUI

@main
struct WikiPlacesApp: App {
    @StateObject private var viewModel = LocationsViewModel(service: LocationService())
    
    var body: some Scene {
        WindowGroup {
            LocationsListView(viewModel: viewModel)
        }
    }
}
