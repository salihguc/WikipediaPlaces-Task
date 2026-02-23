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
    @StateObject private var router = AppRouter()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $router.path) {
                LocationsListView(viewModel: viewModel)
                    .navigationDestination(for: Route.self) { route in
                        switch route {
                        case .customLocation:
                            CustomLocationView()
                        }
                    }
                    .environmentObject(router)
            }
            .wikipediaOpener()
        }
    }
}
