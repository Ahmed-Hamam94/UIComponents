//
//  DesignTextField.swift
//  UIComponents
//
//  Created by Ahmed Hamam on 26/01/2026.
//

import SwiftUI

public struct DesignTextField: View {
    @Binding var text: String
    @FocusState private var isFocused: Bool
    @Environment(\.isEnabled) private var isEnabled
    
    private let placeholder: String
    private let image: String?
    private let imagePosition: ImagePosition
    private let theme: TextFieldThemeProtocol
    private let errorMessage: String?
    
    public init(
        text: Binding<String>,
        placeholder: String,
        image: String? = nil,
        imagePosition: ImagePosition = .leading,
        theme: TextFieldThemeProtocol = DesignTextFieldTheme(),
        errorMessage: String? = nil
    ) {
        self._text = text
        self.placeholder = placeholder
        self.image = image
        self.imagePosition = imagePosition
        self.theme = theme
        self.errorMessage = errorMessage
    }
    
    // MARK: - Computed State Properties
    
    private var hasError: Bool {
        errorMessage != nil
    }
    
    private var currentBackgroundColor: Color {
        if !isEnabled {
            return theme.disabledBackgroundColor
        } else if hasError {
            return theme.errorBackgroundColor
        } else if isFocused {
            return theme.focusBackgroundColor
        }
        return theme.backgroundColor
    }
    
    private var currentBorderColor: Color {
        if !isEnabled {
            return theme.disabledBorderColor
        } else if hasError {
            return theme.errorBorderColor
        } else if isFocused {
            return theme.focusBorderColor
        }
        return theme.borderColor
    }
    
    private var currentTextColor: Color {
        if !isEnabled {
            return theme.disabledTextColor
        }
        return theme.textColor
    }
    
    // MARK: - Body
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            TextFieldContainerView(
                text: $text,
                isFocused: $isFocused, placeholder: placeholder,
                image: image,
                imagePosition: imagePosition,
                theme: theme,
                hasError: hasError,
                isEnabled: isEnabled
            )
            
            if let errorMessage {
                ErrorLabel(message: errorMessage, theme: theme)
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(placeholder)
        .accessibilityValue(text.isEmpty ? "Empty" : text)
        .accessibilityHint(errorMessage ?? "")
    }
}

// MARK: - Text Field Container View
private struct TextFieldContainerView: View {
    @Binding var text: String
    @FocusState.Binding var isFocused: Bool
    let placeholder: String
    let image: String?
    let imagePosition: ImagePosition
    let theme: TextFieldThemeProtocol
    let hasError: Bool
    let isEnabled: Bool
    
    private var currentBackgroundColor: Color {
        if !isEnabled {
            return theme.disabledBackgroundColor
        } else if hasError {
            return theme.errorBackgroundColor
        } else if isFocused {
            return theme.focusBackgroundColor
        }
        return theme.backgroundColor
    }
    
    private var currentBorderColor: Color {
        if !isEnabled {
            return theme.disabledBorderColor
        } else if hasError {
            return theme.errorBorderColor
        } else if isFocused {
            return theme.focusBorderColor
        }
        return theme.borderColor
    }
    
    private var currentTextColor: Color {
        if !isEnabled {
            return theme.disabledTextColor
        }
        return theme.textColor
    }
    
    var body: some View {
        HStack(spacing: 8) {
            if let image, imagePosition == .leading {
                IconView(systemName: image, color: theme.iconColor)
            }
            
            ZStack(alignment: .leading) {
                if text.isEmpty {
                    Text(placeholder)
                        .font(theme.placeholderFont)
                        .foregroundStyle(theme.placeholderColor)
                }
                
                SwiftUI.TextField("", text: $text)
                    .font(theme.font)
                    .foregroundStyle(currentTextColor)
                    .focused($isFocused)
            }
            
            if let image, imagePosition == .trailing {
                IconView(systemName: image, color: theme.iconColor)
            }
        }
        .padding(.horizontal, 12)
        .frame(height: theme.height)
        .background(currentBackgroundColor)
        .clipShape(.rect(cornerRadius: theme.cornerRadius))
        .overlay(
            RoundedRectangle(cornerRadius: theme.cornerRadius)
                .stroke(currentBorderColor, lineWidth: theme.borderWidth)
        )
        .animation(.easeInOut(duration: 0.2), value: isFocused)
        .animation(.easeInOut(duration: 0.2), value: hasError)
    }
}

// MARK: - Icon View
private struct IconView: View {
    let systemName: String
    let color: Color
    
    var body: some View {
        Image(systemName: systemName)
            .foregroundStyle(color)
    }
}

// MARK: - Error Label
private struct ErrorLabel: View {
    let message: String
    let theme: TextFieldThemeProtocol
    
    var body: some View {
        Text(message)
            .font(.caption)
            .foregroundStyle(theme.errorTextColor)
    }
}

// MARK: - Previews

#Preview("Theme States") {
    VStack(spacing: 20) {
        DesignTextField(text: .constant(""), placeholder: "Default")
        DesignTextField(text: .constant("With text"), placeholder: "Default")
        DesignTextField(text: .constant(""), placeholder: "Disabled")
            .disabled(true)
        DesignTextField(
            text: .constant(""),
            placeholder: "Default theme"
        )
        
        DesignTextField(
            text: .constant(""),
            placeholder: "Bordered theme"
        )
        
        DesignTextField(
            text: .constant(""),
            placeholder: "Rounded theme"
        )
        DesignTextField(
            text: .constant(""),
            placeholder: "Search...",
            image: "magnifyingglass",
            imagePosition: .leading
        )
        
        DesignTextField(
            text: .constant(""),
            placeholder: "Email",
            image: "envelope",
            imagePosition: .trailing
        )
        DesignTextField(
            text: .constant("invalid@"),
            placeholder: "Email",
            errorMessage: "Please enter a valid email"
        )
        
        DesignTextField(
            text: .constant(""),
            placeholder: "Required field",
            errorMessage: "This field is required"
        )
    }
    .padding()
}
