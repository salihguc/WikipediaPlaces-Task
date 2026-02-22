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
    
    @Published var isLoading = false
    @Published var locations: [Location] = []
    @Published var errorMessage: String?
    
    private let service: LocationServiceProtocol
    
    init(service: LocationServiceProtocol) {
        self.service = service
    }
    
    func fetchLocations() async {
        isLoading = true
        errorMessage = nil
        do {
            locations = try await service.fetchLocations()
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
}
