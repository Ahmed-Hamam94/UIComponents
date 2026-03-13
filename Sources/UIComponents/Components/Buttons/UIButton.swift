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
        private let width: CGFloat?
        private let height: CGFloat?

        @Environment(\.isEnabled) private var isEnabled

        public init(
            title: String,
            style: S,
            accessibility: UIAccessibility? = nil,
            width: CGFloat? = nil,
            height: CGFloat? = nil,
            action: @escaping () -> Void
        ) {
            self.title = title
            self.style = style
            self.accessibility = accessibility
            self.width = width
            self.height = height
            self.action = action
        }

        public var body: some View {
            SwiftUI.Button(action: action) {
                Text(title)
                    .font(style.font)
                    .frame(width: width, height: height ?? style.height)
                    .if(width == nil) { $0.frame(maxWidth: .infinity) }
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
        width: CGFloat? = nil,
        height: CGFloat? = nil,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.style = style
        self.accessibility = accessibility
        self.width = width
        self.height = height
        self.action = action
    }
}

// MARK: - Environment-Aware Button

extension UI {
    /// A button that reads its theme from the environment.
    ///
    /// Use this variant when you want the button to automatically pick up
    /// themes from the `.uiComponentsTheme()` modifier without explicit styling.
    ///
    /// ```swift
    /// ContentView()
    ///     .uiComponentsTheme(.dark)
    ///
    /// // Inside ContentView:
    /// UI.EnvironmentButton(title: "Log In", variant: .primary) {
    ///     print("Tapped")
    /// }
    /// ```
    public struct EnvironmentButton: View {
        /// The button style variant to use from the environment theme.
        public enum Variant: Sendable {
            case primary
            case secondary
            case destructive
            case ghost
            case link
        }
        
        private let title: String
        private let variant: Variant
        private let accessibility: UIAccessibility?
        private let width: CGFloat?
        private let height: CGFloat?
        private let action: () -> Void
        
        @Environment(\.uiComponentsTheme) private var theme
        @Environment(\.isEnabled) private var isEnabled
        
        public init(
            title: String,
            variant: Variant = .primary,
            accessibility: UIAccessibility? = nil,
            width: CGFloat? = nil,
            height: CGFloat? = nil,
            action: @escaping () -> Void
        ) {
            self.title = title
            self.variant = variant
            self.accessibility = accessibility
            self.width = width
            self.height = height
            self.action = action
        }
        
        private var resolvedStyle: UIButtonTheme {
            switch variant {
            case .primary: theme.buttonPrimary
            case .secondary: theme.buttonSecondary
            case .destructive: theme.buttonDestructive
            case .ghost: theme.buttonGhost
            case .link: theme.buttonLink
            }
        }
        
        public var body: some View {
            UI.Button(
                title: title,
                style: resolvedStyle,
                accessibility: accessibility,
                width: width,
                height: height,
                action: action
            )
        }
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
