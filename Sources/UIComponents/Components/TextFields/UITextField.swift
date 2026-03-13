//
//  UITextField.swift
//  UIComponents
//
//  Created by Ahmed Hamam on 26/01/2026.
//

import SwiftUI

extension UI {
    /// A themed text input component with optional icon and error support.
    ///
    /// This component provides a premium alternative to standard SwiftUI TextFields, 
    /// including built-in support for multiple states (Default, Focus, Error, Disabled).
    ///
    /// ```swift
    /// UI.TextField(
    ///     text: $email, 
    ///     placeholder: "Email", 
    ///     image: "envelope", 
    ///     errorMessage: error
    /// )
    /// ```
    public struct TextField<T: UITextFieldThemeProtocol>: View {
        /// The text being edited.
        @Binding var text: String
        @FocusState private var isFocused: Bool
        @Environment(\.isEnabled) private var isEnabled
        
        /// The placeholder text shown when the input is empty.
        private let placeholder: String
        /// Optional SF Symbol name to show as an icon.
        private let image: String?
        /// Position of the icon relative to the text.
        private let imagePosition: ImagePosition
        /// Theme providing the colors and typography.
        private let theme: T
        /// Optional error message to display below the field.
        private let errorMessage: String?
        private let accessibility: UIAccessibility?
        private let width: CGFloat?
        private let height: CGFloat?

        public init(
            text: Binding<String>,
            placeholder: String,
            image: String? = nil,
            imagePosition: ImagePosition = .leading,
            theme: T,
            errorMessage: String? = nil,
            accessibility: UIAccessibility? = nil,
            width: CGFloat? = nil,
            height: CGFloat? = nil
        ) {
            self._text = text
            self.placeholder = placeholder
            self.image = image
            self.imagePosition = imagePosition
            self.theme = theme
            self.errorMessage = errorMessage
            self.accessibility = accessibility
            self.width = width
            self.height = height
        }
        
        // MARK: - Computed State Properties
        
        private var hasError: Bool {
            errorMessage != nil
        }
        
        public var body: some View {
            VStack(alignment: .leading, spacing: 4) {
                TextFieldContainerView(
                    text: $text,
                    isFocused: $isFocused, placeholder: placeholder,
                    image: image,
                    imagePosition: imagePosition,
                    theme: theme,
                    hasError: hasError,
                    isEnabled: isEnabled,
                    width: width,
                    height: height
                )
                
                if let errorMessage {
                    ErrorLabel(message: errorMessage, theme: theme)
                }
            }
            .accessibilityElement(children: .combine)
            .uiAccessibility(
                accessibility,
                defaultLabel: placeholder,
                defaultValue: text.isEmpty ? "Empty" : text,
                defaultHint: errorMessage ?? ""
            )
        }
    }
}

// MARK: - Text Field Container View
private struct TextFieldContainerView: View {
    @Binding var text: String
    @FocusState.Binding var isFocused: Bool
    let placeholder: String
    let image: String?
    let imagePosition: ImagePosition
    let theme: UITextFieldThemeProtocol
    let hasError: Bool
    let isEnabled: Bool
    let width: CGFloat?
    let height: CGFloat?
    
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
        .frame(width: width, height: height ?? theme.height)
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
    let theme: UITextFieldThemeProtocol
    
    var body: some View {
        Text(message)
            .font(.caption)
            .foregroundStyle(theme.errorTextColor)
    }
}

// MARK: - Convenience Initializer with Default Theme
extension UI.TextField where T == UITextFieldTheme {
    /// Convenience initializer using the default `UITextFieldTheme`.
    public init(
        text: Binding<String>,
        placeholder: String,
        image: String? = nil,
        imagePosition: ImagePosition = .leading,
        errorMessage: String? = nil,
        accessibility: UIAccessibility? = nil,
        width: CGFloat? = nil,
        height: CGFloat? = nil
    ) {
        self.init(
            text: text,
            placeholder: placeholder,
            image: image,
            imagePosition: imagePosition,
            theme: UITextFieldTheme(),
            errorMessage: errorMessage,
            accessibility: accessibility,
            width: width,
            height: height
        )
    }
}

#Preview("Theme States") {
    VStack(spacing: 20) {
        UI.TextField(text: .constant(""), placeholder: "Default")
        UI.TextField(text: .constant("With text"), placeholder: "Default")
        UI.TextField(text: .constant(""), placeholder: "Disabled")
            .disabled(true)
        UI.TextField(
            text: .constant(""),
            placeholder: "Search...",
            image: "magnifyingglass",
            imagePosition: .leading
        )
        
        UI.TextField(
            text: .constant("invalid@"),
            placeholder: "Email",
            errorMessage: "Please enter a valid email",
            width: 300,
            height: 40
        )
    }
    .padding()
}
