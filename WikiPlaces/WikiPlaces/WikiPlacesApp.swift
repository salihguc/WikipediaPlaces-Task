//
//  WikiPlacesApp.swift
//  WikiPlaces
//
//  Created by sg on 22.02.2026.
//

import SwiftUI

@main
struct WikiPlacesApp: App {
    @StateObject private var viewModel: LocationsViewModel
    @StateObject private var router = AppRouter()

    init() {
        let service: LocationServiceProtocol
        #if DEBUG
        if CommandLine.arguments.contains("--uitesting") {
            service = StubLocationService()
        } else {
            service = LocationService()
        }
        #else
        service = LocationService()
        #endif
        _viewModel = StateObject(wrappedValue: LocationsViewModel(service: service))
    }

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
