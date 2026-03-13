//
//  ValidationRuleTests.swift
//  UIComponents
//
//  Created by Ahmed Hamam on 28/02/2026.
//

import Testing
@testable import UIComponents

// MARK: - Required Rule Tests

@Suite("Required Validation Rule")
struct RequiredRuleTests {

    @Test("Empty string fails required validation")
    func emptyString() {
        let rule = ValidationRule.required()
        #expect(rule.validate("") != nil)
    }

    @Test("Whitespace-only strings fail required validation")
    func whitespaceOnly() {
        let rule = ValidationRule.required()
        #expect(rule.validate("   ") != nil)
        #expect(rule.validate("\t\n") != nil)
    }

    @Test("Non-empty string passes required validation")
    func validString() {
        let rule = ValidationRule.required()
        #expect(rule.validate("hello") == nil)
        #expect(rule.validate("  hello  ") == nil)
    }

    @Test("Custom error message is returned")
    func customMessage() {
        let customMessage = "Please fill this field"
        let rule = ValidationRule.required(message: customMessage)
        #expect(rule.validate("") == customMessage)
    }
}

// MARK: - Email Rule Tests

@Suite("Email Validation Rule")
struct EmailRuleTests {

    @Test("Valid email formats pass", arguments: [
        "test@example.com",
        "user.name+tag@domain.co.uk",
        "a@b.cd"
    ])
    func validEmails(email: String) {
        let rule = ValidationRule.email()
        #expect(rule.validate(email) == nil)
    }

    @Test("Invalid email formats fail", arguments: [
        "plaintext",
        "@domain.com",
        "user@",
        "user@domain",
        "user@domain.c"
    ])
    func invalidEmails(email: String) {
        let rule = ValidationRule.email()
        #expect(rule.validate(email) != nil)
    }

    @Test("Empty string passes email validation (use .required for emptiness)")
    func emptyString() {
        let rule = ValidationRule.email()
        #expect(rule.validate("") == nil)
    }

    @Test("Custom error message is returned")
    func customMessage() {
        let customMessage = "Invalid email format"
        let rule = ValidationRule.email(message: customMessage)
        #expect(rule.validate("invalid") == customMessage)
    }
}

// MARK: - MinLength Rule Tests

@Suite("MinLength Validation Rule")
struct MinLengthRuleTests {

    @Test("Strings at or above min length pass")
    func validInput() {
        let rule = ValidationRule.minLength(5)
        #expect(rule.validate("hello") == nil)
        #expect(rule.validate("hello world") == nil)
    }

    @Test("Strings below min length fail")
    func invalidInput() {
        let rule = ValidationRule.minLength(5)
        #expect(rule.validate("hi") != nil)
        #expect(rule.validate("") != nil)
    }

    @Test("Edge cases: minLength(0) and minLength(1)")
    func edgeCases() {
        let rule0 = ValidationRule.minLength(0)
        #expect(rule0.validate("") == nil)

        let rule1 = ValidationRule.minLength(1)
        #expect(rule1.validate("a") == nil)
        #expect(rule1.validate("") != nil)
    }

    @Test("Custom error message is returned")
    func customMessage() {
        let customMessage = "Too short!"
        let rule = ValidationRule.minLength(10, message: customMessage)
        #expect(rule.validate("short") == customMessage)
    }
}

// MARK: - MaxLength Rule Tests

@Suite("MaxLength Validation Rule")
struct MaxLengthRuleTests {

    @Test("Strings at or below max length pass")
    func validInput() {
        let rule = ValidationRule.maxLength(10)
        #expect(rule.validate("hello") == nil)
        #expect(rule.validate("hellohello") == nil)
        #expect(rule.validate("") == nil)
    }

    @Test("Strings above max length fail")
    func invalidInput() {
        let rule = ValidationRule.maxLength(5)
        #expect(rule.validate("hello world") != nil)
        #expect(rule.validate("123456") != nil)
    }

    @Test("Custom error message is returned")
    func customMessage() {
        let customMessage = "Too long!"
        let rule = ValidationRule.maxLength(5, message: customMessage)
        #expect(rule.validate("toolongtext") == customMessage)
    }
}

// MARK: - PhoneNumber Rule Tests

@Suite("PhoneNumber Validation Rule")
struct PhoneNumberRuleTests {

    @Test("Valid phone numbers pass")
    func validInput() {
        let rule = ValidationRule.phoneNumber()
        #expect(rule.validate("123456789") == nil)
        #expect(rule.validate("1234567890") == nil)
        #expect(rule.validate("+1-234-567-8901") == nil)
    }

    @Test("Phone numbers outside digit range fail")
    func invalidInput() {
        let rule = ValidationRule.phoneNumber(minDigits: 9, maxDigits: 10)
        #expect(rule.validate("12345678") != nil)
        #expect(rule.validate("12345678901") != nil)
    }

    @Test("Empty string passes (use .required for emptiness)")
    func emptyString() {
        let rule = ValidationRule.phoneNumber()
        #expect(rule.validate("") == nil)
    }

    @Test("Custom digit range works correctly")
    func customRange() {
        let rule = ValidationRule.phoneNumber(minDigits: 10, maxDigits: 10)
        #expect(rule.validate("1234567890") == nil)
        #expect(rule.validate("123456789") != nil)
        #expect(rule.validate("12345678901") != nil)
    }
}

// MARK: - Regex Rule Tests

@Suite("Regex Validation Rule")
struct RegexRuleTests {

    @Test("Matching patterns pass")
    func matchingPattern() {
        let rule = ValidationRule.regex(pattern: "^[A-Z]{3}$", message: "Must be 3 uppercase letters")
        #expect(rule.validate("ABC") == nil)
        #expect(rule.validate("XYZ") == nil)
    }

    @Test("Non-matching patterns fail")
    func nonMatchingPattern() {
        let rule = ValidationRule.regex(pattern: "^[A-Z]{3}$", message: "Must be 3 uppercase letters")
        #expect(rule.validate("abc") != nil)
        #expect(rule.validate("AB") != nil)
        #expect(rule.validate("ABCD") != nil)
    }

    @Test("Empty string passes regex (use .required for emptiness)")
    func emptyString() {
        let rule = ValidationRule.regex(pattern: ".*", message: "Error")
        #expect(rule.validate("") == nil)
    }
}

// MARK: - Custom Rule Tests

@Suite("Custom Validation Rule")
struct CustomRuleTests {

    @Test("Passing condition returns nil")
    func passingCondition() {
        let rule = ValidationRule.custom({ $0.contains("@") }, message: "Must contain @")
        #expect(rule.validate("test@example") == nil)
    }

    @Test("Failing condition returns error message")
    func failingCondition() {
        let rule = ValidationRule.custom({ $0.contains("@") }, message: "Must contain @")
        #expect(rule.validate("test") != nil)
    }

    @Test("Complex logic: password strength check")
    func complexLogic() {
        let rule = ValidationRule.custom({ value in
            let hasUppercase = value.contains(where: { $0.isUppercase })
            let hasLowercase = value.contains(where: { $0.isLowercase })
            let hasDigit = value.contains(where: { $0.isNumber })
            return hasUppercase && hasLowercase && hasDigit
        }, message: "Must contain uppercase, lowercase, and digit")

        #expect(rule.validate("Password1") == nil)
        #expect(rule.validate("password") != nil)
        #expect(rule.validate("PASSWORD1") != nil)
    }
}

// MARK: - Matches Rule Tests

@Suite("Matches Validation Rule")
struct MatchesRuleTests {

    @Test("Matching values pass")
    func matchingValues() {
        let password1 = "secret123"
        let rule1 = ValidationRule.matches({ password1 }, message: "Passwords don't match")
        #expect(rule1.validate("secret123") == nil)

        let password2 = "newpassword"
        let rule2 = ValidationRule.matches({ password2 }, message: "Passwords don't match")
        #expect(rule2.validate("newpassword") == nil)
    }

    @Test("Non-matching values fail")
    func nonMatchingValues() {
        let password = "secret123"
        let rule = ValidationRule.matches({ password }, message: "Passwords don't match")
        #expect(rule.validate("different") != nil)
    }
}

// MARK: - Sendable Conformance

@Suite("ValidationRule Sendable")
struct ValidationRuleSendableTests {

    @Test("ValidationRule can be used in async context")
    func sendableConformance() async {
        let rule = ValidationRule.required()
        let result = rule.validate("test")
        #expect(result == nil)
    }
}
