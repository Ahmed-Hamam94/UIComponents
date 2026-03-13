//
//  TextFieldConfiguration.swift
//  UIComponents
//
//  Created by Ahmed Hamam on 28/02/2026.
//

import SwiftUI

// MARK: - ValidatedTextField Configuration

/// Configuration object for `UI.ValidatedTextField`.
///
/// Use this struct to group all validated text field options into a single object,
/// making initialization cleaner for components with many parameters.
///
/// ```swift
/// let config = ValidatedTextFieldConfig(
///     title: "Email",
///     placeholder: "Enter your email",
///     validationRules: [.required(), .email()],
///     isSecure: false,
///     image: "envelope"
/// )
///
/// UI.ValidatedTextField(text: $email, config: config)
/// ```
public struct ValidatedTextFieldConfig: Sendable {
    /// The title label text displayed above the field.
    public var title: String
    /// The placeholder text shown in the input.
    public var placeholder: String
    /// A list of rules to validate against the input text.
    public var validationRules: [ValidationRule]
    /// A list of async rules to validate against the input text.
    public var asyncValidationRules: [AsyncValidationRule]
    /// Debounce duration in milliseconds for async validation.
    public var asyncDebounceMilliseconds: UInt64
    /// When validation should be triggered.
    public var validationTrigger: ValidationTrigger
    /// Optional SF Symbol name for the input icon.
    public var image: String?
    /// Position of the icon relative to the text.
    public var imagePosition: ImagePosition
    /// When true, input is masked (password) and an eye toggle is shown.
    public var isSecure: Bool
    /// Optional custom title font (nil = use theme).
    public var titleFont: Font?
    /// Optional custom title color (nil = use theme).
    public var titleColor: Color?
    /// Optional custom error font (nil = use theme).
    public var errorFont: Font?
    /// Optional custom error color (nil = use theme).
    public var errorColor: Color?
    /// Optional fixed width.
    public var width: CGFloat?
    /// Optional fixed height.
    public var height: CGFloat?
    
    public init(
        title: String,
        placeholder: String = "",
        validationRules: [ValidationRule] = [],
        asyncValidationRules: [AsyncValidationRule] = [],
        asyncDebounceMilliseconds: UInt64 = 300,
        validationTrigger: ValidationTrigger = .onChange,
        image: String? = nil,
        imagePosition: ImagePosition = .leading,
        isSecure: Bool = false,
        titleFont: Font? = nil,
        titleColor: Color? = nil,
        errorFont: Font? = nil,
        errorColor: Color? = nil,
        width: CGFloat? = nil,
        height: CGFloat? = nil
    ) {
        self.title = title
        self.placeholder = placeholder
        self.validationRules = validationRules
        self.asyncValidationRules = asyncValidationRules
        self.asyncDebounceMilliseconds = asyncDebounceMilliseconds
        self.validationTrigger = validationTrigger
        self.image = image
        self.imagePosition = imagePosition
        self.isSecure = isSecure
        self.titleFont = titleFont
        self.titleColor = titleColor
        self.errorFont = errorFont
        self.errorColor = errorColor
        self.width = width
        self.height = height
    }
}

// MARK: - Common Presets

public extension ValidatedTextFieldConfig {
    /// Preset configuration for email fields.
    static func email(
        title: String = "Email",
        placeholder: String = "Enter your email"
    ) -> ValidatedTextFieldConfig {
        ValidatedTextFieldConfig(
            title: title,
            placeholder: placeholder,
            validationRules: [.required(), .email()],
            image: "envelope"
        )
    }
    
    /// Preset configuration for password fields.
    static func password(
        title: String = "Password",
        placeholder: String = "Enter your password",
        minLength: Int = 8
    ) -> ValidatedTextFieldConfig {
        ValidatedTextFieldConfig(
            title: title,
            placeholder: placeholder,
            validationRules: [.required(), .minLength(minLength)],
            image: "lock",
            isSecure: true
        )
    }
    
    /// Preset configuration for required text fields.
    static func required(
        title: String,
        placeholder: String = "",
        image: String? = nil
    ) -> ValidatedTextFieldConfig {
        ValidatedTextFieldConfig(
            title: title,
            placeholder: placeholder,
            validationRules: [.required()],
            image: image
        )
    }
    
    /// Preset configuration for username fields with async availability check.
    /// - Parameters:
    ///   - title: The field title label.
    ///   - placeholder: The placeholder text.
    ///   - minLength: Minimum username length for sync validation.
    ///   - availabilityCheck: An async closure that returns true if the username is available.
    ///   - debounceMs: Debounce duration (default: 500ms to reduce API calls).
    static func username(
        title: String = "Username",
        placeholder: String = "Enter your username",
        minLength: Int = 3,
        availabilityCheck: @escaping @Sendable (String) async throws -> Bool,
        debounceMs: UInt64 = 500
    ) -> ValidatedTextFieldConfig {
        ValidatedTextFieldConfig(
            title: title,
            placeholder: placeholder,
            validationRules: [.required(), .minLength(minLength)],
            asyncValidationRules: [.usernameAvailable(check: availabilityCheck)],
            asyncDebounceMilliseconds: debounceMs,
            image: "person"
        )
    }
    
    /// Preset configuration for email with async availability check.
    /// - Parameters:
    ///   - title: The field title label.
    ///   - placeholder: The placeholder text.
    ///   - availabilityCheck: An async closure that returns true if the email is available.
    ///   - debounceMs: Debounce duration (default: 500ms).
    static func emailWithAvailability(
        title: String = "Email",
        placeholder: String = "Enter your email",
        availabilityCheck: @escaping @Sendable (String) async throws -> Bool,
        debounceMs: UInt64 = 500
    ) -> ValidatedTextFieldConfig {
        ValidatedTextFieldConfig(
            title: title,
            placeholder: placeholder,
            validationRules: [.required(), .email()],
            asyncValidationRules: [.emailAvailable(check: availabilityCheck)],
            asyncDebounceMilliseconds: debounceMs,
            image: "envelope"
        )
    }
}

// MARK: - PhoneNumberTextField Configuration

/// Configuration object for `UI.PhoneNumberTextField`.
///
/// ```swift
/// let config = PhoneNumberTextFieldConfig(
///     countries: Country.commonCountries,
///     placeholder: "Enter phone number",
///     showCode: true
/// )
///
/// UI.PhoneNumberTextField(
///     phoneNumber: $phone,
///     selectedCountry: $country,
///     config: config
/// )
/// ```
public struct PhoneNumberTextFieldConfig: Sendable {
    /// The list of available countries in the picker.
    public var countries: [Country]
    /// The placeholder text shown in the phone number input.
    public var placeholder: String
    /// Whether to show the country's dial code in the selector.
    public var showCode: Bool
    /// Whether the text field is disabled.
    public var disabled: Bool
    /// Optional fixed width.
    public var width: CGFloat?
    /// Optional fixed height.
    public var height: CGFloat?
    
    public init(
        countries: [Country] = Country.commonCountries,
        placeholder: String = "xxxxxxxx",
        showCode: Bool = true,
        disabled: Bool = false,
        width: CGFloat? = nil,
        height: CGFloat? = nil
    ) {
        self.countries = countries
        self.placeholder = placeholder
        self.showCode = showCode
        self.disabled = disabled
        self.width = width
        self.height = height
    }
}

// MARK: - Common Presets

public extension PhoneNumberTextFieldConfig {
    /// Default configuration with common countries.
    static let `default` = PhoneNumberTextFieldConfig()
    
    /// Configuration for a single country (no picker).
    static func singleCountry(_ country: Country) -> PhoneNumberTextFieldConfig {
        PhoneNumberTextFieldConfig(countries: [country])
    }
    
    /// Configuration for US-only phone numbers.
    static var usOnly: PhoneNumberTextFieldConfig {
        PhoneNumberTextFieldConfig(countries: [Country(code: "US", flag: "🇺🇸", dialCode: "+1", name: "United States")])
    }
}
