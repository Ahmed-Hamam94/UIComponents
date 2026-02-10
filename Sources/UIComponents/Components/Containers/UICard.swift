//
//  UICard.swift
//  UIComponents
//
//  Created by Ahmed Hamam on 28/01/2026.
//

import SwiftUI

extension UI {
    /// A container view that groups related content with a premium look.
    ///
    /// Cards provide a background, shadow, and corner radius to their content.
    /// They support custom themes via `UICardThemeProtocol`.
    ///
    /// ```swift
    /// UI.Card {
    ///     Text("This is grouped content")
    /// }
    /// ```
    public struct Card<Content: View, T: UICardThemeProtocol>: View {
        /// A closure that returns the content to be displayed within the card.
        private let contentBuilder: () -> Content
        /// The visual style of the card.
        private let theme: T
        /// Optional accessibility label for the card.
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
