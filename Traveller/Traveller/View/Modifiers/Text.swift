//
//  Text.swift
//  Traveller
//
//  Created by Jesse Williams on 23/07/2024.
//

import SwiftUI

// MARK: - Bold subheadline
struct BoldSubheadlineModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .fontWeight(.bold)
            .font(.subheadline)
    }
}

extension Text {
    func boldSubheadline() -> some View {
        self.modifier(BoldSubheadlineModifier())
    }
}

// MARK: - Secondary caption
struct SecondaryCaptionModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(.secondary)
            .font(.caption)
    }
}

extension Text {
    func secondaryCaption() -> some View {
        self.modifier(SecondaryCaptionModifier())
    }
}
