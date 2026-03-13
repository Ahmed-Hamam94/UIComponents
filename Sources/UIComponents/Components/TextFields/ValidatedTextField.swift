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
        @State private var isValidating: Bool = false
        @State private var validationTask: Task<Void, Never>? = nil
        
        /// The title label text displayed above the field.
        private let title: String
        /// The placeholder text shown in the input.
        private let placeholder: String
        /// A list of rules to validate against the input text.
        private let validationRules: [ValidationRule]
        /// A list of async rules to validate against the input text.
        private let asyncValidationRules: [AsyncValidationRule]
        /// Debounce duration in milliseconds for async validation.
        private let asyncDebounceMilliseconds: UInt64
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
        
        // Styling Overrides (nil = use theme values)
        private let titleFontOverride: Font?
        private let titleColorOverride: Color?
        private let errorFontOverride: Font?
        private let errorColorOverride: Color?
        
        // Computed properties to resolve overrides
        private var titleFont: Font { titleFontOverride ?? theme.titleFont }
        private var titleColor: Color { titleColorOverride ?? theme.titleColor }
        private var errorFont: Font { errorFontOverride ?? theme.errorMessageFont }
        private var errorColor: Color { errorColorOverride ?? theme.errorMessageColor }
        
        /// Optional accessibility overrides for the field. Nil = use defaults.
        private let accessibility: UIAccessibility?
        /// Optional accessibility overrides for the password visibility button (when isSecure). Nil = use defaults.
        private let passwordVisibilityAccessibility: UIAccessibility?
        private let width: CGFloat?
        private let height: CGFloat?

        @State private var isPasswordRevealed: Bool = false

        public init(
            text: Binding<String>,
            isValid: Binding<Bool> = .constant(true),
            triggerValidation: Binding<Int> = .constant(0),
            title: String,
            placeholder: String = "",
            validationRules: [ValidationRule] = [],
            asyncValidationRules: [AsyncValidationRule] = [],
            asyncDebounceMilliseconds: UInt64 = 300,
            validationTrigger: ValidationTrigger = .onChange,
            image: String? = nil,
            imagePosition: ImagePosition = .leading,
            isSecure: Bool = false,
            theme: UITextFieldThemeProtocol = UITextFieldTheme(),
            titleFont: Font? = nil,
            titleColor: Color? = nil,
            errorFont: Font? = nil,
            errorColor: Color? = nil,
            accessibility: UIAccessibility? = nil,
            passwordVisibilityAccessibility: UIAccessibility? = nil,
            width: CGFloat? = nil,
            height: CGFloat? = nil
        ) {
            self._text = text
            self._isValid = isValid
            self._triggerValidation = triggerValidation
            self.title = title
            self.placeholder = placeholder
            self.validationRules = validationRules
            self.asyncValidationRules = asyncValidationRules
            self.asyncDebounceMilliseconds = asyncDebounceMilliseconds
            self.validationTrigger = validationTrigger
            self.image = image
            self.imagePosition = imagePosition
            self.isSecure = isSecure
            self.theme = theme
            self.titleFontOverride = titleFont
            self.titleColorOverride = titleColor
            self.errorFontOverride = errorFont
            self.errorColorOverride = errorColor
            self.accessibility = accessibility
            self.passwordVisibilityAccessibility = passwordVisibilityAccessibility
            self.width = width
            self.height = height
        }
        
        // MARK: - Configuration-Based Initializer
        
        /// Creates a validated text field using a configuration object.
        ///
        /// This initializer provides a cleaner API for components with many options.
        ///
        /// ```swift
        /// let config = ValidatedTextFieldConfig.email()
        /// UI.ValidatedTextField(text: $email, config: config)
        /// ```
        public init(
            text: Binding<String>,
            isValid: Binding<Bool> = .constant(true),
            triggerValidation: Binding<Int> = .constant(0),
            config: ValidatedTextFieldConfig,
            theme: UITextFieldThemeProtocol = UITextFieldTheme(),
            accessibility: UIAccessibility? = nil,
            passwordVisibilityAccessibility: UIAccessibility? = nil
        ) {
            self._text = text
            self._isValid = isValid
            self._triggerValidation = triggerValidation
            self.title = config.title
            self.placeholder = config.placeholder
            self.validationRules = config.validationRules
            self.asyncValidationRules = config.asyncValidationRules
            self.asyncDebounceMilliseconds = config.asyncDebounceMilliseconds
            self.validationTrigger = config.validationTrigger
            self.image = config.image
            self.imagePosition = config.imagePosition
            self.isSecure = config.isSecure
            self.theme = theme
            self.titleFontOverride = config.titleFont
            self.titleColorOverride = config.titleColor
            self.errorFontOverride = config.errorFont
            self.errorColorOverride = config.errorColor
            self.accessibility = accessibility
            self.passwordVisibilityAccessibility = passwordVisibilityAccessibility
            self.width = config.width
            self.height = config.height
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
                    
                    // Async validation loading indicator
                    validationLoadingIndicator
                    
                    if isSecure {
                        passwordVisibilityButton
                    } else if let image = image, imagePosition == .trailing {
                        imageView(image)
                    }
                }
                .padding(.horizontal, 12)
                .frame(width: width, height: height ?? theme.height)
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
            .accessibilityElement(children: .combine)
            .uiAccessibility(
                accessibility,
                defaultLabel: title,
                defaultValue: text.isEmpty ? "Empty" : text,
                defaultHint: internalError ?? ""
            )
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
            .uiAccessibility(
                passwordVisibilityAccessibility,
                defaultLabel: isPasswordRevealed ? "Hide password" : "Show password",
                defaultHint: "Double tap to toggle password visibility"
            )
        }
        
        private func runValidation(_ value: String) {
            // Run synchronous validation first
            for rule in validationRules {
                if let errorMessage = rule.validate(value) {
                    internalError = errorMessage
                    isValid = false
                    return
                }
            }
            
            // If no async rules, we're done
            guard !asyncValidationRules.isEmpty else {
                internalError = nil
                isValid = true
                return
            }
            
            // Cancel any existing async validation task
            validationTask?.cancel()
            
            // Start async validation with debounce
            validationTask = Task { @MainActor in
                // Debounce
                try? await Task.sleep(nanoseconds: asyncDebounceMilliseconds * 1_000_000)
                
                guard !Task.isCancelled else { return }
                
                isValidating = true
                
                do {
                    for rule in asyncValidationRules {
                        guard !Task.isCancelled else { return }
                        
                        if let errorMessage = try await rule.validate(value) {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                internalError = errorMessage
                                isValid = false
                            }
                            isValidating = false
                            return
                        }
                    }
                    
                    guard !Task.isCancelled else { return }
                    
                    withAnimation(.easeInOut(duration: 0.2)) {
                        internalError = nil
                        isValid = true
                    }
                } catch {
                    // Handle validation errors (e.g., network failure)
                    guard !Task.isCancelled else { return }
                    withAnimation(.easeInOut(duration: 0.2)) {
                        internalError = "Validation failed. Please try again."
                        isValid = false
                    }
                }
                
                isValidating = false
            }
        }
        
        /// A loading indicator shown during async validation.
        @ViewBuilder
        private var validationLoadingIndicator: some View {
            if isValidating {
                ProgressView()
                    .controlSize(.small)
            }
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
                        ),
                        width: 290,
                        height: 50
                    )
                }
                .padding()
            }
        }
    }
    
    return PreviewWrapper()
}
