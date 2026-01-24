//
//  DesignTextField.swift
//  UIComponents
//
//  Created by Ahmed Hamam on 26/01/2026.
//

import SwiftUI

public struct DesignTextField: View {
    @Binding var text: String
    var placeholder: String
    var image: String?
    var imagePosition: ImagePosition
    var theme: TextFieldThemeProtocol
    
    public init(text: Binding<String>, placeholder: String, image: String? = nil, imagePosition: ImagePosition = .leading, theme: TextFieldThemeProtocol = DesignTextFieldTheme()) {
        self._text = text
        self.placeholder = placeholder
        self.image = image
        self.imagePosition = imagePosition
        self.theme = theme
    }
    
    public var body: some View {
        HStack(spacing: 8) {
            if let image = image, imagePosition == .leading {
                imageView(image)
            }
            
            ZStack(alignment: .leading) {
                if text.isEmpty {
                    Text(placeholder)
                        .font(theme.placeholderFont)
                        .foregroundColor(theme.placeholderColor)
                }
                
                TextField("", text: $text)
                    .font(theme.font)
                    .foregroundColor(theme.textColor)
            }
            
            if let image = image, imagePosition == .trailing {
                imageView(image)
            }
        }
        .padding(.horizontal, 12)
        .frame(height: theme.height)
        .background(theme.backgroundColor)
        .cornerRadius(theme.cornerRadius)
        .overlay(
            RoundedRectangle(cornerRadius: theme.cornerRadius)
                .stroke(theme.borderColor, lineWidth: theme.borderWidth)
        )
    }
    
    private func imageView(_ name: String) -> some View {
        Image(systemName: name)
            .foregroundColor(theme.placeholderColor) // Match placeholder color for icon? Or maybe add iconColor to theme later.
    }
}

#Preview {
    VStack(spacing: 20) {
        // Default Theme
        DesignTextField(text: .constant(""), placeholder: "Default")
        
        // Custom Theme (Bordered)
        DesignTextField(
            text: .constant(""),
            placeholder: "Bordered",
            theme: DesignTextFieldTheme(
                backgroundColor: .white,
                borderColor: .blue,
                borderWidth: 1
            )
        )
        
        // Custom Font & Color
        DesignTextField(
            text: .constant(""),
            placeholder: "Custom Font",
            theme: DesignTextFieldTheme(
                placeholderFont: .caption,
                placeholderColor: .red
            )
        )
        
        // Image + Border
        DesignTextField(
            text: .constant(""),
            placeholder: "Search...",
            image: "magnifyingglass",
            theme: DesignTextFieldTheme(
                backgroundColor: .white,
                borderColor: .gray.opacity(0.5),
                borderWidth: 1,
                cornerRadius: 20
            )
        )
    }
    .padding()
}
