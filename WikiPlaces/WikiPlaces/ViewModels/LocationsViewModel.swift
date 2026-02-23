//
//  LocationsViewModel.swift
//  WikiPlaces
//
//  Created by sg on 22.02.2026.
//

import Foundation
import Combine

@MainActor
final class LocationsViewModel: ObservableObject {
    @Published var state: ViewState = .loading

    @Published var showInvalidCoordinatesAlert = false
    
    private let service: LocationServiceProtocol
    
    init(service: LocationServiceProtocol) {
        self.service = service
    }
    
    func fetchLocations() async {
        state = .loading
        
        do {
            let locations = try await service.fetchLocations()
            state = locations.isEmpty ? .empty : .loaded(locations)
        } catch {
            state = .error(error.localizedDescription)
        }
    }
}

extension LocationsViewModel {
    enum ViewState {
        case loading
        case error(String)
        case empty
        case loaded([Location])
    }
}
