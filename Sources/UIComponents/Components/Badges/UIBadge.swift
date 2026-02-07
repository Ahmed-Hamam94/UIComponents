//
//  UIBadge.swift
//  UIComponents
//
//  Created by Ahmed Hamam on 28/01/2026.
//

import SwiftUI

extension UI {
    public struct Badge<T: UIBadgeThemeProtocol>: View {
        private let text: String
        private let theme: T
        
        public init(
            _ text: String,
            theme: T
        ) {
            self.text = text
            self.theme = theme
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
                .accessibilityLabel("Badge: \(text)")
        }
    }
}

extension UI.Badge where T == UIBadgeTheme {
    public init(
        _ text: String,
        theme: UIBadgeTheme = .default
    ) {
        self.text = text
        self.theme = theme
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
