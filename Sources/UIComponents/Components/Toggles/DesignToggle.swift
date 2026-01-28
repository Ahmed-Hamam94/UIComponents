//
//  DesignToggle.swift
//  UIComponents
//
//  Created by Ahmed Hamam on 28/01/2026.
//

import SwiftUI

public struct DesignToggle: View {
    @Binding var isOn: Bool
    private let label: String?
    private let theme: ToggleThemeProtocol
    
    public init(
        isOn: Binding<Bool>,
        label: String? = nil,
        theme: ToggleThemeProtocol = DesignToggleTheme()
    ) {
        self._isOn = isOn
        self.label = label
        self.theme = theme
    }
    
    public var body: some View {        
        HStack {
            if let label = label {
                Text(label)
                    .font(theme.font)
                    .foregroundColor(theme.textColor)
            }
            
            Spacer()
            
            toggleCapsule
        }
        .padding(.vertical, 4)
    }
    
    private var toggleCapsule: some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                isOn.toggle()
            }
        }) {
            Capsule()
                .fill(isOn ? theme.onColor : theme.offColor)
                .frame(width: 50, height: 30)
                .overlay(
                    Circle()
                        .fill(theme.thumbColor)
                        .padding(2)
                        .offset(x: isOn ? 10 : -10)
                )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct DesignToggle_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            DesignToggle(isOn: .constant(true), label: "Notifications")
            DesignToggle(isOn: .constant(false), label: "Dark Mode")
            DesignToggle(
                isOn: .constant(true),
                label: "Custom Theme",
                theme: DesignToggleTheme(onColor: .green)
            )
        }
        .padding()
    }
}
