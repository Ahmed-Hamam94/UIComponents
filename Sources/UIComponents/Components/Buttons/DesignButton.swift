//
//  DesignButton.swift
//  UIComponents
//
//  Created by Ahmed Hamam on 16/10/2025.
//

import SwiftUI

public struct DesignButton: View {
    var title: String
    var style: ButtonThemeProtocol
    var action: () -> Void
    
    @Environment(\.isEnabled) private var isEnabled
    
    public init(title: String, style: ButtonThemeProtocol, action: @escaping () -> Void) {
        self.title = title
        self.style = style
        self.action = action
    }
    
    public var body: some View {
        Button(action: action) {
            Text(title)
                .font(style.font)
                .frame(height: style.height)
                .frame(maxWidth: .infinity)
                .background(isEnabled ? style.backgroundColor : style.disabledBackgroundColor)
                .foregroundColor(style.foregroundColor)
                .cornerRadius(style.cornerRadius)
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        DesignButton(title: "Primary", style: PrimaryTheme(), action: {})
        DesignButton(title: "Secondary", style: SecondaryTheme(), action: {})
        DesignButton(title: "Destructive", style: DestructiveTheme(), action: {})
        
        Divider()
        
        DesignButton(title: "Disabled", style: PrimaryTheme(), action: {})
            .disabled(true)
        
        DesignButton(title: "Test", style: ButtonTheme(), action: {})
        
        DesignButton(title: "Test Theme", style: ButtonTheme(backgroundColor: .purple, disabledBackgroundColor: .purple.opacity(0.3), foregroundColor: .white, cornerRadius: 10, height: 48, font: .title), action: {})
            .disabled(true)
    }
    .padding()
}
