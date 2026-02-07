//
//  ValidatedTextField.swift
//  UIComponents
//
//  Created by Ahmed Hamam on 26/01/2026.
//

import SwiftUI

public enum ValidationTrigger {
    case onChange      // Validate as user types
    case onSubmit      // Validate when user submits/ends editing
    case manual        // Only validate when explicitly called
}

public struct ValidatedTextField: View {
    @Binding var text: String
    @Binding var isValid: Bool
    /// When using `validationTrigger: .manual`, pass a binding and increment its value to trigger validation (e.g. `triggerValidation += 1`).
    @Binding var triggerValidation: Int
    
    @State private var internalError: String? = nil
    @State private var hasBeenEdited: Bool = false
    
    let title: String
    let placeholder: String
    let validationRules: [ValidationRule]
    let validationTrigger: ValidationTrigger
    let image: String?
    let imagePosition: ImagePosition
    let theme: UITextFieldThemeProtocol
    
    // Title styling
    let titleFont: Font
    let titleColor: Color
    
    // Error styling
    let errorFont: Font
    let errorColor: Color
    
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
                    
                    SwiftUI.TextField("", text: $text)
                        .font(theme.font)
                        .foregroundStyle(theme.textColor)
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
                
                if let image = image, imagePosition == .trailing {
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

// MARK: - Preview
#Preview {
    struct PreviewWrapper: View {
        @State private var email = ""
        @State private var emailValid = true
        
        @State private var password = ""
        @State private var passwordValid = true
        
        @State private var phone = ""
        @State private var phoneValid = true
        
        @State private var username = ""
        @State private var usernameValid = true
        
        @State private var age = ""
        @State private var ageValid = true
        
        var body: some View {
            ScrollView {
                VStack(spacing: 24) {
                    // Email with validation
                    ValidatedTextField(
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
                    
                    // Password with min length
                    ValidatedTextField(
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
                        theme: UITextFieldTheme(
                            backgroundColor: .white,
                            borderColor: .gray.opacity(0.3),
                            borderWidth: 1
                        )
                    )
                    
                    // Phone number validation
                    ValidatedTextField(
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
                    
                    // MARK: - Custom Validation Example
                    // Username: Must start with letter, only alphanumeric, 3-20 chars
                    ValidatedTextField(
                        text: $username,
                        isValid: $usernameValid,
                        title: "Username (Custom Validation)",
                        placeholder: "Enter username",
                        validationRules: [
                            .required(message: "Username is required"),
                            .custom({ value in
                                // Must start with a letter
                                guard let first = value.first, first.isLetter else {
                                    return false
                                }
                                // Only alphanumeric characters
                                return value.allSatisfy { $0.isLetter || $0.isNumber }
                            }, message: "Username must start with a letter and contain only letters and numbers"),
                            .minLength(3, message: "Username must be at least 3 characters"),
                            .maxLength(20, message: "Username must be no more than 20 characters")
                        ],
                        image: "person",
                        imagePosition: .leading,
                        theme: UITextFieldTheme(
                            backgroundColor: .white,
                            borderColor: .gray.opacity(0.3),
                            borderWidth: 1
                        )
                    )
                    
                    // Age: Custom validation - must be a number between 18 and 120
                    ValidatedTextField(
                        text: $age,
                        isValid: $ageValid,
                        title: "Age (Custom Number Validation)",
                        placeholder: "Enter your age",
                        validationRules: [
                            .required(message: "Age is required"),
                            .custom({ value in
                                guard let ageInt = Int(value) else { return false }
                                return ageInt >= 18 && ageInt <= 120
                            }, message: "Age must be a number between 18 and 120")
                        ],
                        theme: UITextFieldTheme(
                            backgroundColor: .white,
                            borderColor: .gray.opacity(0.3),
                            borderWidth: 1
                        )
                    )
                    
                    // Status
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Validation Status:")
                            .font(.headline)
                        Text("Email: \(emailValid ? "✅" : "❌")")
                        Text("Password: \(passwordValid ? "✅" : "❌")")
                        Text("Phone: \(phoneValid ? "✅" : "❌")")
                        Text("Username: \(usernameValid ? "✅" : "❌")")
                        Text("Age: \(ageValid ? "✅" : "❌")")
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Color.white)
                    .clipShape(.rect(cornerRadius: 8))
                }
                .padding()
            }
        }
    }
    
    return PreviewWrapper()
}
