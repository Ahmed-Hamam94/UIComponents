//
//  DesignCheckboxButton.swift
//  UIComponents
//
//  Created by Ahmed Hamam on 27/01/2026.
//

import SwiftUI

public struct DesignCheckboxButton<T: CheckboxThemeProtocol>: View {
    @Binding var isOn: Bool
    private let label: String?
    private let theme: T
    
    public init(
        isOn: Binding<Bool>,
        label: String? = nil,
        theme: T
    ) {
        self._isOn = isOn
        self.label = label
        self.theme = theme
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
        .accessibilityLabel(label ?? "Checkbox")
        .accessibilityValue(isOn ? "Checked" : "Unchecked")
        .accessibilityAddTraits(.isButton)
        .accessibilityHint("Double tap to toggle")
    }
}

extension DesignCheckboxButton where T == DesignCheckboxTheme {
    public init(
        isOn: Binding<Bool>,
        label: String? = nil,
        theme: DesignCheckboxTheme = .primary
    ) {
        self._isOn = isOn
        self.label = label
        self.theme = theme
    }
}

// MARK: - Checkbox Icon View
private struct CheckboxIcon<T: CheckboxThemeProtocol>: View {
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
                
                Image(systemName: "checkmark")
                    .font(.system(size: theme.size * 0.5, weight: .bold))
                    .foregroundStyle(theme.checkmarkColor)
            }
        }
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isOn)
    }
}

#Preview("Checkbox Themes") {
    VStack(alignment: .leading, spacing: 20) {
        DesignCheckboxButton(isOn: .constant(true))
        DesignCheckboxButton(isOn: .constant(false), label: "Unchecked State")
        DesignCheckboxButton(isOn: .constant(true), label: "Checked State")
        DesignCheckboxButton(isOn: .constant(true), label: "Primary", theme: .primary)
        DesignCheckboxButton(isOn: .constant(true), label: "Secondary", theme: .secondary)
        DesignCheckboxButton(isOn: .constant(true), label: "Success", theme: .success)
    }
    .padding()
}
