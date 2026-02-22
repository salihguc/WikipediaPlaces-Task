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
            VStack(alignment: .leading, spacing: 4) {
                Text(location.displayName)
                    .font(.headline)
                Text("Lat: \(location.lat, specifier: "%.4f"), Lon: \(location.long, specifier: "%.4f")")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        
    }
}

//#Preview {
//    LocationRowView()
//}
