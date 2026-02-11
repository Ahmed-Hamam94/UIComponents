//
//  UIButton.swift
//  UIComponents
//
//  Created by Ahmed Hamam on 16/10/2025.
//

import SwiftUI

extension UI {
    /// A highly customizable, accessible button component.
    ///
    /// The button supports custom theming via the `UIButtonThemeProtocol`.
    /// Built-in press animations and accessibility traits are provided automatically.
    ///
    /// ```swift
    /// UI.Button(title: "Log In", style: .primary) {
    ///     print("Clicked")
    /// }
    /// ```
    public struct Button<S: UIButtonThemeProtocol>: View {
        /// The text display on the button.
        private let title: String
        /// The visual style of the button.
        private let style: S
        /// The closure called when the button is tapped.
        private let action: () -> Void
        /// Optional accessibility overrides. Nil = use defaults (label: title, traits: .isButton).
        private let accessibility: UIAccessibility?

        @Environment(\.isEnabled) private var isEnabled

        public init(
            title: String,
            style: S,
            accessibility: UIAccessibility? = nil,
            action: @escaping () -> Void
        ) {
            self.title = title
            self.style = style
            self.accessibility = accessibility
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
            .uiAccessibility(accessibility, defaultLabel: title, defaultTraits: .isButton)
        }
    }
}

// MARK: - Default theme extension
extension UI.Button where S == UIButtonTheme {
    public init(
        title: String,
        style: UIButtonTheme = .primary,
        accessibility: UIAccessibility? = nil,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.style = style
        self.accessibility = accessibility
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
