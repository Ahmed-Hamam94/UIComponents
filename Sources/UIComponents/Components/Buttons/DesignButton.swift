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
        style: S = .primary,
        action: @escaping () -> Void
    ) where S == ButtonTheme {
        self.title = title
        self.style = style
        self.action = action
    }
    
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

// MARK: - Interaction Style
private struct DesignInteractionStyle: ButtonStyle {
    let theme: ButtonThemeProtocol
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .opacity(configuration.isPressed ? theme.pressedOpacity : 1.0)
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
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

#Preview("Button States") {
    VStack(spacing: 20) {
        DesignButton(title: "Enabled", style: .primary, action: {})
        
        DesignButton(title: "Disabled", style: .primary, action: {})
            .disabled(true)
    }
    .padding()
}
