//
//  UIBadge.swift
//  UIComponents
//
//  Created by Ahmed Hamam on 28/01/2026.
//

import SwiftUI

extension UI {
    /// A compact status indicator used to highlight short, important information.
    ///
    /// Badges are typically used for status (e.g., "New", "Success") or numeric counts.
    /// They support different visual styles via `UIBadgeThemeProtocol`.
    ///
    /// ```swift
    /// UI.Badge("New")
    /// UI.Badge("Success", theme: .success)
    /// ```
    public struct Badge<T: UIBadgeThemeProtocol>: View {
        /// The text content of the badge.
        private let text: String
        /// The visual style of the badge.
        private let theme: T
        /// Optional accessibility overrides. Nil = use default (label: "Badge: \(text)").
        private let accessibility: UIAccessibility?

        public init(
            _ text: String,
            theme: T,
            accessibility: UIAccessibility? = nil
        ) {
            self.text = text
            self.theme = theme
            self.accessibility = accessibility
        }

        public var body: some View {
            Text(text)
                .font(theme.font)
                .foregroundStyle(theme.textColor)
                .padding(.horizontal, theme.horizontalPadding)
                .padding(.vertical, theme.verticalPadding)
                .frame(minWidth: theme.width, minHeight: theme.height)
                .background(theme.backgroundColor)
                .clipShape(.rect(cornerRadius: theme.cornerRadius))
                .uiAccessibility(accessibility, defaultLabel: "Badge: \(text)")
        }
    }
}

extension UI.Badge where T == UIBadgeTheme {
    public init(
        _ text: String,
        theme: UIBadgeTheme = .default,
        accessibility: UIAccessibility? = nil
    ) {
        self.text = text
        self.theme = theme
        self.accessibility = accessibility
    }
}

#Preview("Badge Variants") {
    HStack(spacing: 10) {
        UI.Badge("New")
        UI.Badge("Success", theme: .success)
        UI.Badge("Warning", theme: .warning)
        UI.Badge("Error", theme: .error)
    }
    .padding()
}
