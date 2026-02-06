//
//  DesignRadioButton.swift
//  UIComponents
//
//  Created by Ahmed Hamam on 27/01/2026.
//

import SwiftUI

public struct DesignRadioButton<T: RadioButtonThemeProtocol>: View {
    @Binding private var isSelected: Bool
    private let label: String?
    private let theme: T
    
    public init(
        isSelected: Binding<Bool>,
        label: String? = nil,
        theme: T
    ) {
        self._isSelected = isSelected
        self.label = label
        self.theme = theme
    }
    
    public var body: some View {
        SwiftUI.Button(action: {
            isSelected.toggle()
        }) {
            HStack(spacing: 12) {
                RadioIcon(isSelected: isSelected, theme: theme)
                
                if let label {
                    Text(label)
                        .font(theme.font)
                        .foregroundStyle(theme.textColor)
                }
            }
        }
        .buttonStyle(.plain)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(label ?? "Radio button")
        .accessibilityValue(isSelected ? "Selected" : "Not selected")
        .accessibilityAddTraits(.isButton)
        .accessibilityHint("Double tap to select")
    }
}

extension DesignRadioButton where T == DesignRadioButtonTheme {
    public init(
        isSelected: Binding<Bool>,
        label: String? = nil,
        theme: DesignRadioButtonTheme = .primary
    ) {
        self._isSelected = isSelected
        self.label = label
        self.theme = theme
    }
}

// MARK: - Radio Icon View
private struct RadioIcon<T: RadioButtonThemeProtocol>: View {
    let isSelected: Bool
    let theme: T
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(
                    isSelected ? theme.selectedColor : theme.unselectedBorderColor,
                    lineWidth: theme.borderWidth
                )
                .frame(width: theme.size, height: theme.size)
            
            Circle()
                .fill(isSelected ? theme.selectedColor : Color.clear)
                .frame(
                    width: theme.size * theme.innerCircleScale,
                    height: theme.size * theme.innerCircleScale
                )
                .scaleEffect(isSelected ? 1.0 : 0.001)
        }
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isSelected)
    }
}

#Preview("Radio Button Themes") {
    VStack(alignment: .leading, spacing: 20) {
        DesignRadioButton(isSelected: .constant(true))
        DesignRadioButton(isSelected: .constant(false), label: "Unselected State")
        DesignRadioButton(isSelected: .constant(true), label: "Selected State")
        DesignRadioButton(isSelected: .constant(true), label: "Primary", theme: .primary)
        DesignRadioButton(isSelected: .constant(true), label: "Secondary", theme: .secondary)
        DesignRadioButton(isSelected: .constant(true), label: "Success", theme: .success)
    }
    .padding()
}
