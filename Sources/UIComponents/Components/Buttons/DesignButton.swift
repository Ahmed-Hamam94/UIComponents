//
//  DesignButton.swift
//  UIComponents
//
//  Created by Ahmed Hamam on 16/10/2025.
//

import SwiftUI

public struct DesignButton<S: ButtonThemeProtocol>: View {
    private let title: String
    private let style: S
    private let action: () -> Void
    
    @Environment(\.isEnabled) private var isEnabled
    
    public init(
        title: String,
        style: S,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.style = style
        self.action = action
    }
    
    public var body: some View {
        SwiftUI.Button(action: action) {
            Text(title)
                .font(style.font)
                .frame(height: style.height)
                .frame(maxWidth: .infinity)
                .background(isEnabled ? style.backgroundColor : style.disabledBackgroundColor)
                .foregroundStyle(style.foregroundColor)
                .clipShape(.rect(cornerRadius: style.cornerRadius))
        }
        .buttonStyle(DesignInteractionStyle(theme: style))
        .accessibilityLabel(title)
        .accessibilityAddTraits(.isButton)
    }
}

// MARK: - Default theme extension
extension DesignButton where S == ButtonTheme {
    public init(
        title: String,
        style: ButtonTheme = .primary,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.style = style
        self.action = action
    }
}

#Preview("Button Styles") {
    VStack(spacing: 20) {
        DesignButton(title: "Primary", style: .primary, action: {})
        DesignButton(title: "Secondary", style: .secondary, action: {})
        DesignButton(title: "Destructive", style: .destructive, action: {})
    }
    .padding()
}
