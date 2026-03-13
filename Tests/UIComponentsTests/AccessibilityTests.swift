//
//  AccessibilityTests.swift
//  UIComponents
//
//  Created by Ahmed Hamam on 28/02/2026.
//

import Testing
import SwiftUI
@testable import UIComponents

// MARK: - UIAccessibility Initialization Tests

@Suite("UIAccessibility Initialization")
struct AccessibilityInitTests {

    @Test("Default init has all nil properties")
    func defaultInit() {
        let accessibility = UIAccessibility()

        #expect(accessibility.label == nil)
        #expect(accessibility.value == nil)
        #expect(accessibility.hint == nil)
        #expect(accessibility.traits == nil)
    }

    @Test("Init with label only")
    func labelOnly() {
        let accessibility = UIAccessibility(label: "Submit button")

        #expect(accessibility.label == "Submit button")
        #expect(accessibility.value == nil)
        #expect(accessibility.hint == nil)
        #expect(accessibility.traits == nil)
    }

    @Test("Init with all properties")
    func allProperties() {
        let accessibility = UIAccessibility(
            label: "Volume slider",
            value: "50 percent",
            hint: "Swipe up or down to adjust",
            traits: .isHeader
        )

        #expect(accessibility.label == "Volume slider")
        #expect(accessibility.value == "50 percent")
        #expect(accessibility.hint == "Swipe up or down to adjust")
        #expect(accessibility.traits == .isHeader)
    }

    @Test("Init with multiple traits")
    func multipleTraits() {
        let traits: AccessibilityTraits = [.isButton, .isSelected]
        let accessibility = UIAccessibility(traits: traits)

        #expect(accessibility.traits == traits)
    }
}

// MARK: - Default Fallback Tests

@Suite("UIAccessibility Default Fallbacks")
struct AccessibilityFallbackTests {

    @Test("Label overrides default")
    func labelOverride() {
        let accessibility = UIAccessibility(label: "Custom label")
        let effectiveLabel = accessibility.label ?? "Default label"

        #expect(effectiveLabel == "Custom label")
    }

    @Test("Nil label falls back to default")
    func fallbackToDefault() {
        let accessibility = UIAccessibility()
        let effectiveLabel = accessibility.label ?? "Default label"

        #expect(effectiveLabel == "Default label")
    }

    @Test("Partial override: label set, hint nil")
    func partialOverride() {
        let accessibility = UIAccessibility(label: "Custom", hint: nil)

        let effectiveLabel = accessibility.label ?? "Default label"
        let effectiveHint = accessibility.hint ?? "Default hint"

        #expect(effectiveLabel == "Custom")
        #expect(effectiveHint == "Default hint")
    }
}

// MARK: - Sendable Conformance

@Suite("UIAccessibility Sendable")
struct AccessibilitySendableTests {

    @Test("UIAccessibility can be used in async context")
    func sendableConformance() async {
        let accessibility = UIAccessibility(label: "Test")
        _ = accessibility.label
    }
}

// MARK: - Common Accessibility Pattern Tests

@Suite("UIAccessibility Common Patterns")
struct AccessibilityPatternTests {

    @Test("Checkbox accessibility pattern")
    func checkboxPattern() {
        let accessibility = UIAccessibility(
            label: "Accept terms",
            value: "Checked"
        )

        #expect(accessibility.value == "Checked")
    }

    @Test("Progress bar accessibility pattern")
    func progressBarPattern() {
        let progress = 0.75
        let accessibility = UIAccessibility(
            label: "Download progress",
            value: "\(Int(progress * 100)) percent"
        )

        #expect(accessibility.label == "Download progress")
        #expect(accessibility.value == "75 percent")
    }

    @Test("TextField with error accessibility pattern")
    func textFieldErrorPattern() {
        let errorMessage = "Invalid email"

        let accessibility = UIAccessibility(
            label: "Email address",
            value: "test@example",
            hint: errorMessage
        )

        #expect(accessibility.hint == "Invalid email")
    }
}

// MARK: - Edge Case Tests

@Suite("UIAccessibility Edge Cases")
struct AccessibilityEdgeCaseTests {

    @Test("Empty strings are valid (not nil)")
    func emptyStrings() {
        let accessibility = UIAccessibility(
            label: "",
            value: "",
            hint: ""
        )

        #expect(accessibility.label == "")
        #expect(accessibility.value == "")
        #expect(accessibility.hint == "")
    }

    @Test("Long text is preserved")
    func longText() {
        let longLabel = String(repeating: "Very long accessibility label ", count: 10)
        let accessibility = UIAccessibility(label: longLabel)

        #expect(accessibility.label == longLabel)
    }

    @Test("Special characters and emojis are preserved")
    func specialCharacters() {
        let accessibility = UIAccessibility(
            label: "Button with émojis 🎉 and spëcial çharacters"
        )

        #expect(accessibility.label?.contains("🎉") == true)
        #expect(accessibility.label?.contains("ë") == true)
    }
}

// MARK: - Traits Tests

@Suite("UIAccessibility Traits")
struct AccessibilityTraitsTests {

    @Test("Button trait")
    func buttonTrait() {
        let accessibility = UIAccessibility(traits: .isButton)
        #expect(accessibility.traits == .isButton)
    }

    @Test("Selected trait")
    func selectedTrait() {
        let accessibility = UIAccessibility(traits: .isSelected)
        #expect(accessibility.traits == .isSelected)
    }

    @Test("Combined traits contain all specified values")
    func combinedTraits() {
        let combinedTraits: AccessibilityTraits = [.isButton, .isSelected, .updatesFrequently]
        let accessibility = UIAccessibility(traits: combinedTraits)

        #expect(accessibility.traits?.contains(.isButton) == true)
        #expect(accessibility.traits?.contains(.isSelected) == true)
        #expect(accessibility.traits?.contains(.updatesFrequently) == true)
    }
}
