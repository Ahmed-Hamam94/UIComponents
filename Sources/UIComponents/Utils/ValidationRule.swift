//
//  ValidationRule.swift
//  UIComponents
//
//  Created by Ahmed Hamam on 26/01/2026.
//

import Foundation

/// A validation rule that checks a string value and returns an error message if invalid
public struct ValidationRule {
    public let validate: (String) -> String?
    
    public init(validate: @escaping (String) -> String?) {
        self.validate = validate
    }
}

// MARK: - Common Validation Rules
public extension ValidationRule {
    
    /// Validates that the field is not empty
    static func required(message: String = "This field is required") -> ValidationRule {
        ValidationRule { value in
            value.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? message : nil
        }
    }
    
    /// Validates email format using regex
    static func email(message: String = "Please enter a valid email address") -> ValidationRule {
        ValidationRule { value in
            guard !value.isEmpty else { return nil } // Don't validate empty (use .required for that)
            let emailRegex = #"^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
            let predicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
            return predicate.evaluate(with: value) ? nil : message
        }
    }
    
    /// Validates minimum length
    static func minLength(_ length: Int, message: String? = nil) -> ValidationRule {
        ValidationRule { value in
            let errorMessage = message ?? "Must be at least \(length) characters"
            return value.count >= length ? nil : errorMessage
        }
    }
    
    /// Validates maximum length
    static func maxLength(_ length: Int, message: String? = nil) -> ValidationRule {
        ValidationRule { value in
            let errorMessage = message ?? "Must be no more than \(length) characters"
            return value.count <= length ? nil : errorMessage
        }
    }
    
    /// Validates using a custom regex pattern
    static func regex(pattern: String, message: String = "Invalid format") -> ValidationRule {
        ValidationRule { value in
            guard !value.isEmpty else { return nil }
            let predicate = NSPredicate(format: "SELF MATCHES %@", pattern)
            return predicate.evaluate(with: value) ? nil : message
        }
    }
    
    /// Validates phone number format (digits only, with optional length)
    static func phoneNumber(minDigits: Int = 9, maxDigits: Int = 15, message: String = "Please enter a valid phone number") -> ValidationRule {
        ValidationRule { value in
            guard !value.isEmpty else { return nil }
            let digitsOnly = value.filter { $0.isNumber }
            guard digitsOnly.count >= minDigits && digitsOnly.count <= maxDigits else {
                return message
            }
            return nil
        }
    }
    
    /// Validates that value matches another value (e.g., confirm password)
    static func matches(_ otherValue: @escaping () -> String, message: String = "Values do not match") -> ValidationRule {
        ValidationRule { value in
            value == otherValue() ? nil : message
        }
    }
    
    /// Custom validation with a closure
    static func custom(_ validation: @escaping (String) -> Bool, message: String) -> ValidationRule {
        ValidationRule { value in
            validation(value) ? nil : message
        }
    }
}
