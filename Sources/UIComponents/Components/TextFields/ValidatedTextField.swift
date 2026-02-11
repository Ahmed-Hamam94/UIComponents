//
//  ValidatedTextField.swift
//  UIComponents
//
//  Created by Ahmed Hamam on 26/01/2026.
//

import SwiftUI

/// Determines when validation logic is executed for a text field.
public enum ValidationTrigger: Sendable {
    /// Validate immediately as the user types each character.
    case onChange
    /// Validate only when the user submits or finishes editing the field.
    case onSubmit
    /// Only validate when the `triggerValidation` binding is manually incremented.
    case manual
}

extension UI {
    /// A text field component with integrated validation rules and error display.
    ///
    /// The component manages its own validation state based on the provided rules
    /// and displays an animated error message when validation fails.
    ///
    /// ```swift
    /// UI.ValidatedTextField(
    ///     text: $email,
    ///     title: "Email",
    ///     validationRules: [.required(), .email()]
    /// )
    /// ```
    public struct ValidatedTextField: View {
        /// A binding to the text string being edited.
        @Binding private var text: String
        /// A binding that reflects whether the current input is valid.
        @Binding private var isValid: Bool
        /// An incrementable trigger for manual validation.
        @Binding private var triggerValidation: Int
        
        @State private var internalError: String? = nil
        @State private var hasBeenEdited: Bool = false
        
        /// The title label text displayed above the field.
        private let title: String
        /// The placeholder text shown in the input.
        private let placeholder: String
        /// A list of rules to validate against the input text.
        private let validationRules: [ValidationRule]
        /// When validation should be triggered.
        private let validationTrigger: ValidationTrigger
        /// Optional SF Symbol name for the input icon.
        private let image: String?
        /// Position of the icon relative to the text.
        private let imagePosition: ImagePosition
        /// When true, input is masked (password) and an eye toggle is shown to reveal/hide.
        private let isSecure: Bool
        /// The visual style of the text field.
        private let theme: UITextFieldThemeProtocol
        
        // Styling Overrides
        private let titleFont: Font
        private let titleColor: Color
        private let errorFont: Font
        private let errorColor: Color
        
        @State private var isPasswordRevealed: Bool = false
        
        public init(
            text: Binding<String>,
            isValid: Binding<Bool> = .constant(true),
            triggerValidation: Binding<Int> = .constant(0),
            title: String,
            placeholder: String = "",
            validationRules: [ValidationRule] = [],
            validationTrigger: ValidationTrigger = .onChange,
            image: String? = nil,
            imagePosition: ImagePosition = .leading,
            isSecure: Bool = false,
            theme: UITextFieldThemeProtocol = UITextFieldTheme(),
            titleFont: Font = .subheadline,
            titleColor: Color = .primary,
            errorFont: Font = .caption,
            errorColor: Color = .red
        ) {
            self._text = text
            self._isValid = isValid
            self._triggerValidation = triggerValidation
            self.title = title
            self.placeholder = placeholder
            self.validationRules = validationRules
            self.validationTrigger = validationTrigger
            self.image = image
            self.imagePosition = imagePosition
            self.isSecure = isSecure
            self.theme = theme
            self.titleFont = titleFont
            self.titleColor = titleColor
            self.errorFont = errorFont
            self.errorColor = errorColor
        }
        
        private var hasError: Bool {
            internalError.map { !$0.isEmpty } ?? false
        }
        
        private var effectiveBorderColor: Color {
            hasError ? errorColor : theme.borderColor
        }
        
        private var effectiveBorderWidth: CGFloat {
            hasError ? max(theme.borderWidth, 1) : theme.borderWidth
        }
        
        public var body: some View {
            VStack(alignment: .leading, spacing: 6) {
                // Title
                Text(title)
                    .font(titleFont)
                    .foregroundStyle(titleColor)
                
                // Text Field
                HStack(spacing: 8) {
                    if let image = image, imagePosition == .leading {
                        imageView(image)
                    }
                    
                    ZStack(alignment: .leading) {
                        if text.isEmpty {
                            Text(placeholder)
                                .font(theme.placeholderFont)
                                .foregroundStyle(theme.placeholderColor)
                        }
                        
                        Group {
                            if isSecure, !isPasswordRevealed {
                                SecureField("", text: $text)
                                    .font(theme.font)
                                    .foregroundStyle(theme.textColor)
                            } else {
                                SwiftUI.TextField("", text: $text)
                                    .font(theme.font)
                                    .foregroundStyle(theme.textColor)
                            }
                        }
                        .onChange(of: text) { _, newValue in
                            hasBeenEdited = true
                            if validationTrigger == .onChange {
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    runValidation(newValue)
                                }
                            }
                        }
                        .onSubmit {
                            if validationTrigger == .onSubmit {
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    runValidation(text)
                                }
                            }
                        }
                        .onChange(of: triggerValidation) { _, newValue in
                            if validationTrigger == .manual, newValue != 0 {
                                hasBeenEdited = true
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    runValidation(text)
                                }
                            }
                        }
                    }
                    
                    if isSecure {
                        passwordVisibilityButton
                    } else if let image = image, imagePosition == .trailing {
                        imageView(image)
                    }
                }
                .padding(.horizontal, 12)
                .frame(height: theme.height)
                .background(theme.backgroundColor)
                .clipShape(.rect(cornerRadius: theme.cornerRadius))
                .overlay(
                    RoundedRectangle(cornerRadius: theme.cornerRadius)
                        .stroke(effectiveBorderColor, lineWidth: effectiveBorderWidth)
                        .animation(.easeInOut(duration: 0.2), value: hasError)
                )
                
                // Error Message with Animation
                if let error = internalError, hasBeenEdited, !error.isEmpty {
                    Text(error)
                        .font(errorFont)
                        .foregroundStyle(errorColor)
                        .transition(.asymmetric(
                            insertion: .opacity.combined(with: .move(edge: .top)),
                            removal: .opacity
                        ))
                }
            }
            .animation(.easeInOut(duration: 0.25), value: hasError)
        }
        
        private func imageView(_ name: String) -> some View {
            Image(systemName: name)
                .foregroundStyle(hasError ? errorColor : theme.placeholderColor)
        }
        
        @ViewBuilder
        private var passwordVisibilityButton: some View {
            SwiftUI.Button {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                    isPasswordRevealed.toggle()
                }
            } label: {
                Image(systemName: isPasswordRevealed ? "eye.slash" : "eye")
                    .font(.body)
                    .foregroundStyle(hasError ? errorColor : theme.iconColor)
                    .contentTransition(.symbolEffect(.replace))
            }
            .buttonStyle(.plain)
            .accessibilityLabel(isPasswordRevealed ? "Hide password" : "Show password")
            .accessibilityHint("Double tap to toggle password visibility")
        }
        
        private func runValidation(_ value: String) {
            for rule in validationRules {
                if let errorMessage = rule.validate(value) {
                    internalError = errorMessage
                    isValid = false
                    return
                }
            }
            internalError = nil
            isValid = true
        }
    }
}

// MARK: - Preview
#Preview {
    struct PreviewWrapper: View {
        @State private var email = ""
        @State private var emailValid = true
        
        @State private var password = ""
        @State private var passwordValid = true
        
        @State private var phone = ""
        @State private var phoneValid = true
        
        var body: some View {
            ScrollView {
                VStack(spacing: 24) {
                    // Email with validation
                    UI.ValidatedTextField(
                        text: $email,
                        isValid: $emailValid,
                        title: "Email",
                        placeholder: "Enter your email",
                        validationRules: [
                            .required(message: "Email is required"),
                            .email()
                        ],
                        image: "envelope",
                        imagePosition: .leading,
                        theme: UITextFieldTheme(
                            backgroundColor: .white,
                            borderColor: .gray.opacity(0.3),
                            borderWidth: 1
                        )
                    )
                    
                    // Password with min length and animated eye toggle
                    UI.ValidatedTextField(
                        text: $password,
                        isValid: $passwordValid,
                        title: "Password",
                        placeholder: "Enter your password",
                        validationRules: [
                            .required(message: "Password is required"),
                            .minLength(8, message: "Password must be at least 8 characters")
                        ],
                        image: "lock",
                        imagePosition: .leading,
                        isSecure: true,
                        theme: UITextFieldTheme(
                            backgroundColor: .white,
                            borderColor: .gray.opacity(0.3),
                            borderWidth: 1
                        )
                    )
                    
                    // Phone number validation
                    UI.ValidatedTextField(
                        text: $phone,
                        isValid: $phoneValid,
                        title: "Phone Number",
                        placeholder: "5xxxxxxxx",
                        validationRules: [
                            .required(),
                            .phoneNumber(minDigits: 9, maxDigits: 10)
                        ],
                        image: "phone",
                        imagePosition: .leading,
                        theme: UITextFieldTheme(
                            backgroundColor: .white,
                            borderColor: .gray.opacity(0.3),
                            borderWidth: 1
                        )
                    )
                }
                .padding()
            }
        }
    }
    
    return PreviewWrapper()
}
