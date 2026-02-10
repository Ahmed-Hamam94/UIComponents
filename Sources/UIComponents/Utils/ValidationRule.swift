//
//  ValidationRule.swift
//  UIComponents
//
//  Created by Ahmed Hamam on 26/01/2026.
//

import Foundation

/// A validation rule that checks a string value and returns an error message if invalid.
///
/// Use validation rules with `UI.ValidatedTextField` to provide real-time feedback to users.
///
/// ```swift
/// let rule = UI.Validation.Rule.email()
/// ```
public struct ValidationRule: Sendable {
    /// A closure that validates a string and returns an optional error message if validation fails.
    public let validate: @Sendable (String) -> String?
    
    /// Creates a new validation rule with a custom validation closure.
    /// - Parameter validate: A thread-safe closure that returns an error message if the input is invalid.
    public init(validate: @escaping @Sendable (String) -> String?) {
        self.validate = validate
    }
}

// MARK: - Common Validation Rules
public extension ValidationRule {
    
    /// Validates that the field is not empty.
    /// - Parameter message: The error message to display if validation fails.
    static func required(message: String = "This field is required") -> ValidationRule {
        ValidationRule { @Sendable value in
            value.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? message : nil
        }
    }
    
    /// Validates that the input matches a standard email format.
    /// - Parameter message: The error message to display if validation fails.
    static func email(message: String = "Please enter a valid email address") -> ValidationRule {
        ValidationRule { @Sendable value in
            guard !value.isEmpty else { return nil } // Don't validate empty (use .required for that)
            let emailRegex = #"^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
            let predicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
            return predicate.evaluate(with: value) ? nil : message
        }
    }
    
    /// Validates that the input has a minimum number of characters.
    /// - Parameters:
    ///   - length: The required minimum number of characters.
    ///   - message: Optional custom error message.
    static func minLength(_ length: Int, message: String? = nil) -> ValidationRule {
        ValidationRule { @Sendable value in
            let errorMessage = message ?? "Must be at least \(length) characters"
            return value.count >= length ? nil : errorMessage
        }
    }
    
    /// Validates that the input does not exceed a maximum number of characters.
    /// - Parameters:
    ///   - length: The allowed maximum number of characters.
    ///   - message: Optional custom error message.
    static func maxLength(_ length: Int, message: String? = nil) -> ValidationRule {
        ValidationRule { @Sendable value in
            let errorMessage = message ?? "Must be no more than \(length) characters"
            return value.count <= length ? nil : errorMessage
        }
    }
    
    /// Validates the input against a custom Regular Expression pattern.
    /// - Parameters:
    ///   - pattern: The regex pattern to match.
    ///   - message: The error message to display if validation fails.
    static func regex(pattern: String, message: String = "Invalid format") -> ValidationRule {
        ValidationRule { @Sendable value in
            guard !value.isEmpty else { return nil }
            let predicate = NSPredicate(format: "SELF MATCHES %@", pattern)
            return predicate.evaluate(with: value) ? nil : message
        }
    }
    
    /// Validates that the input is a valid phone number (digits only).
    /// - Parameters:
    ///   - minDigits: Minimum number of digits allowed.
    ///   - maxDigits: Maximum number of digits allowed.
    ///   - message: The error message to display if validation fails.
    static func phoneNumber(minDigits: Int = 9, maxDigits: Int = 15, message: String = "Please enter a valid phone number") -> ValidationRule {
        ValidationRule { @Sendable value in
            guard !value.isEmpty else { return nil }
            let digitsOnly = value.filter { $0.isNumber }
            guard digitsOnly.count >= minDigits && digitsOnly.count <= maxDigits else {
                return message
            }
            return nil
        }
    }
    
    /// Validates that the input matches another string value (frequently used for password confirmation).
    /// - Parameters:
    ///   - otherValue: A closure returning the value to compare against.
    ///   - message: The error message to display if validation fails.
    static func matches(_ otherValue: @escaping @Sendable () -> String, message: String = "Values do not match") -> ValidationRule {
        ValidationRule { @Sendable value in
            value == otherValue() ? nil : message
        }
    }
    
    /// A flexible rule that uses a custom closure for validation logic.
    /// - Parameters:
    ///   - validation: A closure returning `true` if the input is valid.
    ///   - message: The error message to display if validation fails.
    static func custom(_ validation: @escaping @Sendable (String) -> Bool, message: String) -> ValidationRule {
        ValidationRule { @Sendable value in
            validation(value) ? nil : message
        }
    }
}
