//
//  DesignBadge.swift
//  UIComponents
//
//  Created by Ahmed Hamam on 28/01/2026.
//

import SwiftUI

public struct DesignBadge<T: BadgeThemeProtocol>: View {
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

extension DesignBadge where T == DesignBadgeTheme {
    public init(
        _ text: String,
        theme: DesignBadgeTheme = .default
    ) {
        self.text = text
        self.theme = theme
    }
}

#Preview("Badge Variants") {
    HStack(spacing: 10) {
        DesignBadge("New")
        DesignBadge("Success", theme: .success)
        DesignBadge("Warning", theme: .warning)
        DesignBadge("Error", theme: .error)
    }
    .padding()
}
