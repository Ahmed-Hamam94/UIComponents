//
//  UIToggle.swift
//  UIComponents
//
//  Created by Ahmed Hamam on 28/01/2026.
//

import SwiftUI

extension UI {
    public struct Toggle<T: UIToggleThemeProtocol>: View {
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
            HStack {
                if let label {
                    Text(label)
                        .font(theme.font)
                        .foregroundStyle(theme.textColor)
                }
                
                Spacer()
                
                ToggleCapsule(isOn: $isOn, theme: theme)
            }
            .padding(.vertical, 4)
            .accessibilityElement(children: .combine)
            .accessibilityLabel(label ?? "Toggle")
            .accessibilityValue(isOn ? "On" : "Off")
            .accessibilityAddTraits(.isButton)
            .accessibilityHint("Double tap to toggle")
        }
    }
}

extension UI.Toggle where T == UIToggleTheme {
    public init(
        isOn: Binding<Bool>,
        label: String? = nil,
        theme: UIToggleTheme = .default
    ) {
        self._isOn = isOn
        self.label = label
        self.theme = theme
    }
}

// MARK: - Toggle Capsule View
private struct ToggleCapsule<T: UIToggleThemeProtocol>: View {
    @Binding var isOn: Bool
    let theme: T
    
    var body: some View {
        SwiftUI.Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                isOn.toggle()
            }
        }) {
            Capsule()
                .fill(isOn ? theme.onColor : theme.offColor)
                .frame(width: theme.trackWidth, height: theme.trackHeight)
                .overlay(
                    Circle()
                        .fill(theme.thumbColor)
                        .padding(2)
                        .offset(x: isOn ? (theme.trackWidth - theme.trackHeight) / 2 - 2 : -(theme.trackWidth - theme.trackHeight) / 2 + 2)
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
            theme: UIToggleTheme(onColor: .green, offColor: .cyan, thumbColor: .blue, font: .body, textColor: .brown, trackWidth: 55, trackHeight: 30)
        )
    }
    .padding()
}
