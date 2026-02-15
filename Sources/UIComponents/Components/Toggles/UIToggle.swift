//
//  UIToggle.swift
//  UIComponents
//
//  Created by Ahmed Hamam on 28/01/2026.
//

import SwiftUI

extension UI {
    /// A custom toggle switch component with a premium look and feel.
    ///
    /// The toggle features smooth animated transitions and supports custom themes via `UIToggleThemeProtocol`.
    ///
    /// ```swift
    /// UI.Toggle(isOn: $notificationsEnabled, label: "Enable Notifications")
    /// ```
    public struct Toggle<T: UIToggleThemeProtocol>: View {
        /// A binding to the boolean state of the toggle.
        @Binding private var isOn: Bool
        /// Optional label displayed next to the toggle switch.
        private let label: String?
        /// The visual style and animation settings of the toggle.
        private let theme: T
        /// Optional accessibility overrides. Nil = use defaults.
        private let accessibility: UIAccessibility?
        private let size: CGFloat?

        public init(
            isOn: Binding<Bool>,
            label: String? = nil,
            theme: T,
            accessibility: UIAccessibility? = nil,
            size: CGFloat? = nil
        ) {
            self._isOn = isOn
            self.label = label
            self.theme = theme
            self.accessibility = accessibility
            self.size = size
        }

        public var body: some View {
            HStack {
                if let label {
                    Text(label)
                        .font(theme.font)
                        .foregroundStyle(theme.textColor)
                }

                Spacer()

                ToggleCapsule(isOn: $isOn, theme: theme, size: size ?? theme.trackHeight)
            }
            .padding(.vertical, 4)
            .accessibilityElement(children: .combine)
            .uiAccessibility(
                accessibility,
                defaultLabel: label ?? "Toggle",
                defaultValue: isOn ? "On" : "Off",
                defaultHint: "Double tap to toggle",
                defaultTraits: .isButton
            )
        }
    }
}

extension UI.Toggle where T == UIToggleTheme {
    public init(
        isOn: Binding<Bool>,
        label: String? = nil,
        theme: UIToggleTheme = .default,
        accessibility: UIAccessibility? = nil,
        size: CGFloat? = nil
    ) {
        self._isOn = isOn
        self.label = label
        self.theme = theme
        self.accessibility = accessibility
        self.size = size
    }
}

// MARK: - Toggle Capsule View
private struct ToggleCapsule<T: UIToggleThemeProtocol>: View {
    @Binding var isOn: Bool
    let theme: T
    let size: CGFloat
    
    private var trackWidth: CGFloat {
        (size / theme.trackHeight) * theme.trackWidth
    }
    
    var body: some View {
        SwiftUI.Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                isOn.toggle()
            }
        }) {
            Capsule()
                .fill(isOn ? theme.onColor : theme.offColor)
                .frame(width: trackWidth, height: size)
                .overlay(
                    Circle()
                        .fill(theme.thumbColor)
                        .padding(2)
                        .offset(x: isOn ? (trackWidth - size) / 2 - 2 : -(trackWidth - size) / 2 + 2)
                        .frame(width: size, height: size)
                )
        }
        .buttonStyle(.plain)
    }
}

#Preview("Toggle Themes") {
    VStack(spacing: 20) {
        UI.Toggle(isOn: .constant(true), label: "Notifications On")
        UI.Toggle(isOn: .constant(false), label: "Notifications Off")
        UI.Toggle(isOn: .constant(true), label: "Default", theme: .default)
        UI.Toggle(
            isOn: .constant(true),
            label: "Green",
            theme: UIToggleTheme(onColor: .green, offColor: .cyan, thumbColor: .blue, font: .body, textColor: .brown, trackWidth: 80, trackHeight: 30)
        )
    }
    .padding()
}
