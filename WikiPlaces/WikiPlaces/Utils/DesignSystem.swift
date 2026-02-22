//
//  DesignSystem.swift
//  WikiPlaces
//
//  Created by sg on 22.02.2026.
//

import SwiftUI

enum DesignSystem {
    enum Spacing {
        static let extraSmall: CGFloat = 2
        static let small: CGFloat = 4
        static let medium: CGFloat = 8
        static let large: CGFloat = 16
        static let extraLarge: CGFloat = 24
    }

    enum Colors {
        static let error: Color = .red
        static let secondaryText: Color = .secondary
    }

    enum Icons {
        static let error = "exclamationmark.circle"
        static let map = "map"
        static let customLocation = "mappin.and.ellipse"
        static let warning = "exclamationmark.triangle"
        static let disclosure = "chevron.right"
    }
}

