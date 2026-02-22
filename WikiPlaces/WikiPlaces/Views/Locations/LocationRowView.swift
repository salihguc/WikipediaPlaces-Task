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
        }
        
    }
}
