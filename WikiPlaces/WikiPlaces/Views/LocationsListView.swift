//
//  LocationsListView.swift
//  WikiPlaces
//
//  Created by sg on 22.02.2026.
//

import SwiftUI

struct LocationsListView: View {
    @ObservedObject var viewModel: LocationsViewModel
    
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
                        //TODO: Push to Custom Location View
                    } label: {
                        Text(String(localized: "Enter Custom Location"))
                    }
                }
            } else {
                List {
                    ForEach(viewModel.locations) { location in
                        Button {
                            //TODO: Open Wikipedia App
                        } label: {
                            Text(location.displayName)
                        }
                        .tint(.primary)
                    }
                    
                    Section {
                        Button {
                            //TODO: Push to Custom Location View
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
    }
}
