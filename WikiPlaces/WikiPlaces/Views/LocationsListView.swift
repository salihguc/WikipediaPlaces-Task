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
            if viewModel.isLoading {
                ProgressView(String(localized: "Loading locations..."))
            } else if let error = viewModel.errorMessage {
                ContentUnavailableView {
                    Label(String(localized: "Unable to Load"), systemImage: "exclamationmark.triangle")
                } description: {
                    Text(error)
                } actions: {
                    Button(String(localized: "Retry")) {
                        Task { await viewModel.fetchLocations() }
                    }
                }
            } else if viewModel.locations.isEmpty {
                ContentUnavailableView {
                    Label(String(localized: "No Locations"), systemImage: "map")
                } description: {
                    Text(String(localized: "No locations available. You can enter custom coordinates instead."))
                } actions: {
                    Button {
                        router.push(route: .customLocation)
                    } label: {
                        Text(String(localized: "Enter Custom Location"))
                    }
                }
            } else {
                List {
                    ForEach(viewModel.locations) { location in
                        Button {
                            if let url = viewModel.urlFromLocation(location: location) {
                                openURL(url) { accepted in
                                    if !accepted {
                                        viewModel.cannotOpenUrl()
                                    }
                                }
                            }
                        } label: {
                            Text(location.displayName)
                        }
                        .tint(.primary)
                    }
                    
                    Section {
                        Button {
                            router.push(route: .customLocation)
                        } label: {
                            Text(String(localized: "Enter Custom Location"))
                        }
                    }
                }
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
    }
}
