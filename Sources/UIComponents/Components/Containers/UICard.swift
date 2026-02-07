//
//  UICard.swift
//  UIComponents
//
//  Created by Ahmed Hamam on 28/01/2026.
//

import SwiftUI

extension UI {
    public struct Card<Content: View, T: UICardThemeProtocol>: View {
        private let contentBuilder: () -> Content
        private let theme: T
        private let accessibilityLabel: String?
        
        public init(
            theme: T,
            accessibilityLabel: String? = nil,
            @ViewBuilder content: @escaping () -> Content
        ) {
            self.theme = theme
            self.accessibilityLabel = accessibilityLabel
            self.contentBuilder = content
        }
        
        public var body: some View {
            contentBuilder()
                .padding(theme.padding)
                .background(theme.backgroundColor)
                .clipShape(.rect(cornerRadius: theme.cornerRadius))
                .shadow(
                    color: theme.shadowColor,
                    radius: theme.shadowRadius,
                    x: theme.shadowOffset.x,
                    y: theme.shadowOffset.y
                )
                .accessibilityElement(children: accessibilityLabel != nil ? .combine : .contain)
                .accessibilityLabel(accessibilityLabel ?? "")
        }
    }
}

extension UI.Card where T == UICardTheme {
    public init(
        theme: UICardTheme = .default,
        accessibilityLabel: String? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.theme = theme
        self.accessibilityLabel = accessibilityLabel
        self.contentBuilder = content
    }
}

#Preview("Default Card") {
    UI.Card {
        VStack(alignment: .leading, spacing: 8) {
            Text("Card Title")
                .font(.headline)
            Text("This is some content inside the card. It looks premium and clean.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }
    .padding()
}
