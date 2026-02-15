//
//  UIRadioButton.swift
//  UIComponents
//
//  Created by Ahmed Hamam on 27/01/2026.
//

import SwiftUI

extension UI {
    /// A selection control used for picking one option from a set.
    ///
    /// The radio button consists of a circular icon and an optional label.
    /// It supports custom themes via `UIRadioButtonThemeProtocol`.
    ///
    /// ```swift
    /// UI.RadioButton(isSelected: $selected, label: "Option A")
    /// ```
    public struct RadioButton<T: UIRadioButtonThemeProtocol>: View {
        /// A binding to the selection state of the radio button.
        @Binding private var isSelected: Bool
        /// Optional label displayed next to the radio icon.
        private let label: String?
        /// The visual style of the radio button.
        private let theme: T
        /// Optional accessibility overrides. Nil = use defaults.
        private let accessibility: UIAccessibility?
        private let size: CGFloat?

        public init(
            isSelected: Binding<Bool>,
            label: String? = nil,
            theme: T,
            accessibility: UIAccessibility? = nil,
            size: CGFloat? = nil
        ) {
            self._isSelected = isSelected
            self.label = label
            self.theme = theme
            self.accessibility = accessibility
            self.size = size
        }

        public var body: some View {
            SwiftUI.Button(action: {
                isSelected.toggle()
            }) {
                HStack(spacing: 12) {
                    RadioIcon(isSelected: isSelected, theme: theme, size: size ?? theme.size)

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
                defaultLabel: label ?? "Radio button",
                defaultValue: isSelected ? "Selected" : "Not selected",
                defaultHint: "Double tap to select",
                defaultTraits: .isButton
            )
        }
    }
}

extension UI.RadioButton where T == UIRadioButtonTheme {
    public init(
        isSelected: Binding<Bool>,
        label: String? = nil,
        theme: UIRadioButtonTheme = .primary,
        accessibility: UIAccessibility? = nil,
        size: CGFloat? = 24
    ) {
        self._isSelected = isSelected
        self.label = label
        self.theme = theme
        self.accessibility = accessibility
        self.size = size
    }
}

// MARK: - Radio Icon View
private struct RadioIcon<T: UIRadioButtonThemeProtocol>: View {
    let isSelected: Bool
    let theme: T
    let size: CGFloat
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(
                    isSelected ? theme.selectedColor : theme.unselectedBorderColor,
                    lineWidth: theme.borderWidth
                )
                .frame(width: size, height: size)
            
            Circle()
                .fill(isSelected ? theme.selectedColor : Color.clear)
                .frame(
                    width: size * theme.innerCircleScale,
                    height: size * theme.innerCircleScale
                )
                .scaleEffect(isSelected ? 1.0 : 0.001)
        }
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isSelected)
    }
}

#Preview("Radio Button Themes") {
    VStack(alignment: .leading, spacing: 20) {
        UI.RadioButton(isSelected: .constant(true), size: 20)
        UI.RadioButton(isSelected: .constant(false), label: "Unselected State")
        UI.RadioButton(isSelected: .constant(true), label: "Selected State")
        UI.RadioButton(isSelected: .constant(true), label: "Primary", theme: .primary)
        UI.RadioButton(isSelected: .constant(true), label: "Secondary", theme: .secondary)
        UI.RadioButton(isSelected: .constant(true), label: "Success", theme: .success)
    }
    .padding()
}
