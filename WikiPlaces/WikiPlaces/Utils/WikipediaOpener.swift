//
//  WikipediaOpener.swift
//  WikiPlaces
//
//  Created by sg on 23.02.2026.
//

import SwiftUI

struct WikipediaOpenAction {
    private let handler: (URL) -> Void

    init(handler: @escaping (URL) -> Void) {
        self.handler = handler
    }

    func callAsFunction(_ url: URL) {
        handler(url)
    }
}

private struct WikipediaOpenActionKey: EnvironmentKey {
    static let defaultValue = WikipediaOpenAction { _ in }
}

extension EnvironmentValues {
    var openWikipedia: WikipediaOpenAction {
        get { self[WikipediaOpenActionKey.self] }
        set { self[WikipediaOpenActionKey.self] = newValue }
    }
}

private struct WikipediaOpenerModifier: ViewModifier {
    @Environment(\.openURL) private var openURL
    @State private var showNotInstalledAlert = false

    func body(content: Content) -> some View {
        content
            .environment(\.openWikipedia, WikipediaOpenAction { url in
                openURL(url) { accepted in
                    if !accepted {
                        showNotInstalledAlert = true
                    }
                }
            })
            .alert(String(localized: "Wikipedia Not Installed"),
                   isPresented: $showNotInstalledAlert) {
                Button(String(localized: "OK"), role: .cancel) {}
            } message: {
                Text(String(localized: "Install the Wikipedia app to view locations on the map."))
            }
    }
}

extension View {
    func wikipediaOpener() -> some View {
        modifier(WikipediaOpenerModifier())
    }
}
