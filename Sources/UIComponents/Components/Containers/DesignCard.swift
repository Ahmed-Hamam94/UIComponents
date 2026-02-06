//
//  DesignCard.swift
//  UIComponents
//
//  Created by Ahmed Hamam on 28/01/2026.
//

import SwiftUI

public struct DesignCard<Content: View, T: CardThemeProtocol>: View {
    private let content: Content
    private let theme: T
    private let accessibilityLabel: String?
    
    public init(
        theme: T,
        accessibilityLabel: String? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.theme = theme
        self.accessibilityLabel = accessibilityLabel
        self.content = content()
    }
    
    public var body: some View {
        content
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

extension DesignCard where T == DesignCardTheme {
    public init(
        theme: DesignCardTheme = .default,
        accessibilityLabel: String? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.theme = theme
        self.accessibilityLabel = accessibilityLabel
        self.content = content()
    }
}

#Preview("Default Card") {
    DesignCard {
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
