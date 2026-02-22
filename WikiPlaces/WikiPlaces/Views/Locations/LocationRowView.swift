//
//  LocationRowView.swift
//  WikiPlaces
//
//  Created by sg on 22.02.2026.
//

import SwiftUI

struct LocationRowView: View {
    let location: Location
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.small) {
                Text(location.displayName)
                    .font(.headline)
                Text("Lat: \(location.lat, specifier: "%.4f"), Lon: \(location.long, specifier: "%.4f")")
                    .font(.subheadline)
                    .foregroundStyle(DesignSystem.Colors.secondaryText)
            }
            
            Spacer()
            
            Image(systemName: DesignSystem.Icons.disclosure)
                .font(.caption)
                .foregroundStyle(DesignSystem.Colors.secondaryText)
                .accessibilityHidden(true)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(location.displayName), latitude \(location.lat, specifier: "%.2f"), longitude \(location.long, specifier: "%.2f")")
        .accessibilityHint(String(localized: "Double tap to open in Wikipedia app"))

    }
}
