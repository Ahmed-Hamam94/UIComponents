//
//  DesignCheckboxButton.swift
//  UIComponents
//
//  Created by Ahmed Hamam on 27/01/2026.
//

import SwiftUI

public struct DesignCheckboxButton: View {
    @Binding var isOn: Bool
    private let label: String?
    private let theme: ButtonThemeProtocol
    
    public init(
        isOn: Binding<Bool>,
        label: String? = nil,
        theme: ButtonThemeProtocol = PrimaryTheme()
    ) {
        self._isOn = isOn
        self.label = label
        self.theme = theme
    }
    
    public var body: some View {
        Button(action: {
            isOn.toggle()
        }) {
            HStack(spacing: 12) {
                checkboxIcon
                
                if let label = label {
                    Text(label)
                        .font(theme.font)
                        .foregroundColor(.primary)
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var checkboxIcon: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 4)
                .stroke(isOn ? theme.backgroundColor : Color.gray, lineWidth: 2)
                .frame(width: 24, height: 24)
            
            if isOn {
                RoundedRectangle(cornerRadius: 4)
                    .fill(theme.backgroundColor)
                    .frame(width: 24, height: 24)
                
                Image(systemName: "checkmark")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(theme.foregroundColor)
            }
        }
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isOn)
    }
}

struct DesignCheckboxButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack(alignment: .leading, spacing: 20) {
            DesignCheckboxButton(isOn: .constant(true))
            DesignCheckboxButton(isOn: .constant(false), label: "Unchecked State")
            DesignCheckboxButton(isOn: .constant(true), label: "Secondary Theme", theme: SecondaryTheme())
        }
        .padding()
    }
}
