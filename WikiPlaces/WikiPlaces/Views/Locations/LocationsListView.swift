//
//  LocationsListView.swift
//  WikiPlaces
//
//  Created by sg on 22.02.2026.
//

import SwiftUI

struct LocationsListView: View {
    @Environment(\.openURL) private var openURL
    @ObservedObject var viewModel: LocationsViewModel
    @EnvironmentObject var router: AppRouter
    
    var body: some View {
        Group {
            switch viewModel.state {
            case .loading:
                loadingView
            case .error(let message):
                errorView(message)
            case .empty:
                emptyView
            case .loaded(let locations):
                locationsList(locations)
            }
        }
        .navigationTitle(String(localized: "Places"))
        .task {
            await viewModel.fetchLocations()
        }
        .alert(String(localized: "Wikipedia Not Installed"), isPresented: $viewModel.showWikipediaNotInstalledAlert) {
            Button(String(localized: "OK"), role: .cancel) {}
        } message: {
            Text(String(localized: "Install the Wikipedia app to view locations on the map."))
        }
        .alert(String(localized: "Invalid Coordinates"), isPresented: $viewModel.showInvalidCoordinatesAlert) {
            Button(String(localized: "OK"), role: .cancel) {}
        } message: {
            Text(String(localized: "The coordinates could not be processed."))
        }
    }
}

// MARK: - States
extension LocationsListView {
    private func locationsList(_ locations: [Location]) -> some View {
        List {
            ForEach(locations) { location in
                Button {
                    if let url = viewModel.urlFromLocation(location: location) {
                        openURL(url) { accepted in
                            if !accepted {
                                viewModel.cannotOpenUrl()
                            }
                        }
                    }
                } label: {
                    LocationRowView(location: location)
                }
                .tint(.primary)
            }
            
            Section {
                Button {
                    router.push(route: .customLocation)
                } label: {
                    Label(String(localized: "Custom Location"), systemImage: DesignSystem.Icons.customLocation)
                }
            }
        }
    }
    
    private func errorView(_ message: String) -> some View {
        ContentUnavailableView {
            Label(String(localized: "Unable to Load"), systemImage: DesignSystem.Icons.warning)
        } description: {
            Text(message)
        } actions: {
            Button(String(localized: "Retry")) {
                Task { await viewModel.fetchLocations() }
            }
        }
    }
    
    private var emptyView: some View {
        ContentUnavailableView {
            Label(String(localized: "No Locations"), systemImage: DesignSystem.Icons.map)
        } description: {
            Text(String(localized: "No locations available. You can enter custom coordinates instead."))
        } actions: {
            Button {
                router.push(route: .customLocation)
            } label: {
                Text(String(localized: "Enter Custom Location"))
            }
        }
    }
    
    private var loadingView: some View {
        ProgressView(String(localized: "Loading locations..."))
            .accessibilityLabel(String(localized: "Loading locations"))
            .accessibilityAddTraits(.updatesFrequently)
    }
}
