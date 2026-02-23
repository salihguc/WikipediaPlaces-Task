//
//  AppRouterTests.swift
//  WikiPlacesTests
//
//  Created by sg on 23.02.2026.
//

import Testing
import SwiftUI
@testable import WikiPlaces

@MainActor
struct AppRouterTests {

    @Test func initialPathIsEmpty() {
        let router = AppRouter()
        #expect(router.path.isEmpty)
    }

    @Test func pushAddsRoute() {
        let router = AppRouter()
        router.push(route: .customLocation)
        #expect(!router.path.isEmpty)
        #expect(router.path.count == 1)
    }

    @Test func popRemovesLastRoute() {
        let router = AppRouter()
        router.push(route: .customLocation)
        router.pop()
        #expect(router.path.isEmpty)
    }

    @Test func popOnEmptyPathDoesNothing() {
        let router = AppRouter()
        router.pop()
        #expect(router.path.isEmpty)
    }

    @Test func popToRootClearsAllRoutes() {
        let router = AppRouter()
        router.push(route: .customLocation)
        router.push(route: .customLocation)
        router.popToRoot()
        #expect(router.path.isEmpty)
    }

    @Test func multiplePushesIncrementCount() {
        let router = AppRouter()
        router.push(route: .customLocation)
        router.push(route: .customLocation)
        #expect(router.path.count == 2)
    }
}
