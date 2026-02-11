//
//  UICheckboxButton.swift
//  UIComponents
//
//  Created by Ahmed Hamam on 27/01/2026.
//

import SwiftUI

extension UI {
    /// A standard selection control for binary choices.
    ///
    /// The checkbox consists of a square icon with an optional checkmark and a label.
    /// It supports custom themes via `UICheckboxThemeProtocol`.
    ///
    /// ```swift
    /// UI.Checkbox(isOn: $agreed, label: "I accept the terms")
    /// ```
    public struct Checkbox<T: UICheckboxThemeProtocol>: View {
        /// A binding to the boolean state of the checkbox.
        @Binding private var isOn: Bool
        /// Optional label displayed next to the checkbox icon.
        private let label: String?
        /// The visual style of the checkbox.
        private let theme: T
        /// Optional accessibility overrides. Nil = use defaults.
        private let accessibility: UIAccessibility?

        public init(
            isOn: Binding<Bool>,
            label: String? = nil,
            theme: T,
            accessibility: UIAccessibility? = nil
        ) {
            self._isOn = isOn
            self.label = label
            self.theme = theme
            self.accessibility = accessibility
        }

        public var body: some View {
            SwiftUI.Button(action: {
                isOn.toggle()
            }) {
                HStack(spacing: 12) {
                    CheckboxIcon(isOn: isOn, theme: theme)

                    if let label {
                        Text(label)
                            .font(theme.font)
                            .foregroundStyle(theme.textColor)
                    }
                }
            }
            .buttonStyle(.plain)
            .accessibilityElement(children: .combine)
            .uiAccessibility(
                accessibility,
                defaultLabel: label ?? "Checkbox",
                defaultValue: isOn ? "Checked" : "Unchecked",
                defaultHint: "Double tap to toggle",
                defaultTraits: .isButton
            )
        }
    }
}

extension UI.Checkbox where T == UICheckboxTheme {
    public init(
        isOn: Binding<Bool>,
        label: String? = nil,
        theme: UICheckboxTheme = .primary,
        accessibility: UIAccessibility? = nil
    ) {
        self._isOn = isOn
        self.label = label
        self.theme = theme
        self.accessibility = accessibility
    }
}

// MARK: - Checkbox Icon View
private struct CheckboxIcon<T: UICheckboxThemeProtocol>: View {
    let isOn: Bool
    let theme: T
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: theme.cornerRadius)
                .stroke(
                    isOn ? theme.checkedColor : theme.uncheckedBorderColor,
                    lineWidth: theme.borderWidth
                )
                .frame(width: theme.size, height: theme.size)
            
            if isOn {
                RoundedRectangle(cornerRadius: theme.cornerRadius)
                    .fill(theme.checkedColor)
                    .frame(width: theme.size, height: theme.size)
                
                Image(systemName: theme.checkmarkIcon)
                    .font(.system(size: theme.size * 0.5, weight: .bold))
                    .foregroundStyle(theme.checkmarkColor)
            }
        }
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isOn)
    }
}

#Preview("Checkbox Themes") {
    VStack(alignment: .leading, spacing: 20) {
        UI.Checkbox(isOn: .constant(true))
        UI.Checkbox(isOn: .constant(false), label: "Unchecked State")
        UI.Checkbox(isOn: .constant(true), label: "Checked State")
        UI.Checkbox(isOn: .constant(true), label: "Primary", theme: .primary)
        UI.Checkbox(isOn: .constant(true), label: "Secondary", theme: .secondary)
        UI.Checkbox(isOn: .constant(true), label: "Success", theme: .success)
    }
    .padding()
}
