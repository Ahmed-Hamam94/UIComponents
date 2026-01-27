//
//  DesignRadioButton.swift
//  UIComponents
//
//  Created by Ahmed Hamam on 27/01/2026.
//

import SwiftUI

public struct DesignRadioButton: View {
    @Binding private var isSelected: Bool
    private let label: String?
    private let theme: ButtonThemeProtocol
    
    public init(
        isSelected: Binding<Bool>,
        label: String? = nil,
        theme: ButtonThemeProtocol = PrimaryTheme()
    ) {
        self._isSelected = isSelected
        self.label = label
        self.theme = theme
    }
    
    public var body: some View {
        Button(action: {
            isSelected.toggle()
        }) {
            HStack(spacing: 12) {
                radioIcon
                
                if let label = label {
                    Text(label)
                        .font(theme.font)
                        .foregroundColor(.primary)
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var radioIcon: some View {
        ZStack {
            Circle()
                .stroke(isSelected ? theme.backgroundColor : Color.gray, lineWidth: 2)
                .frame(width: 24, height: 24)
            
            Circle()
                .fill(isSelected ? theme.backgroundColor : Color.clear)
                .frame(width: 12, height: 12)
                .scaleEffect(isSelected ? 1.0 : 0.001)
        }
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isSelected)
    }
}

struct DesignRadioButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack(alignment: .leading, spacing: 20) {
            DesignRadioButton(isSelected: .constant(true))
            DesignRadioButton(isSelected: .constant(false), label: "Unselected State")
            DesignRadioButton(isSelected: .constant(true), label: "Secondary Theme", theme: SecondaryTheme())
        }
        .padding()
    }
}
