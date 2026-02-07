//
//  UIButton.swift
//  UIComponents
//
//  Created by Ahmed Hamam on 16/10/2025.
//

import SwiftUI

extension UI {
    public struct Button<S: UIButtonThemeProtocol>: View {
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
            .buttonStyle(UIInteractionStyle(theme: style))
            .accessibilityLabel(title)
            .accessibilityAddTraits(.isButton)
        }
    }
}

// MARK: - Default theme extension
extension UI.Button where S == UIButtonTheme {
    public init(
        title: String,
        style: UIButtonTheme = .primary,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.style = style
        self.action = action
    }
}

#Preview("Button Styles") {
    VStack(spacing: 20) {
        UI.Button(title: "Primary", style: .primary, action: {})
        UI.Button(title: "Secondary", style: .secondary, action: {})
        UI.Button(title: "Destructive", style: .destructive, action: {})
    }
    .padding()
}
