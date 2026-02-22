//
//  AppRouter.swift
//  WikiPlaces
//
//  Created by sg on 22.02.2026.
//

import SwiftUI
import Combine

enum Route: Hashable {
    case customLocation
}

@MainActor
final class AppRouter: ObservableObject {
    @Published var path = NavigationPath()
    
    func push(route: Route) {
        path.append(route)
    }
    
    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }
    
    func popToRoot() {
        path = NavigationPath()
    }
}
