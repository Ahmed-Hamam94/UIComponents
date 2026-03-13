//
//  ThemeTests.swift
//  UIComponents
//
//  Created by Ahmed Hamam on 28/02/2026.
//

import Testing
import SwiftUI
@testable import UIComponents

// MARK: - Button Theme Tests

@Suite("Button Theme")
struct ButtonThemeTests {

    @Test("UIButtonTheme conforms to protocol")
    func protocolConformance() {
        let theme: any UIButtonThemeProtocol = UIButtonTheme.primary
        #expect(theme.cornerRadius > 0)
        #expect(theme.height > 0)
    }

    @Test("Preset themes are distinct")
    func presets() {
        let primary = UIButtonTheme.primary
        let secondary = UIButtonTheme.secondary
        let destructive = UIButtonTheme.destructive

        #expect(primary.backgroundColor != secondary.backgroundColor)
        #expect(primary.backgroundColor != destructive.backgroundColor)
    }

    @Test("Custom init sets properties correctly")
    func customInit() {
        let customTheme = UIButtonTheme(
            backgroundColor: .purple,
            disabledBackgroundColor: .gray,
            foregroundColor: .white,
            cornerRadius: 20,
            height: 60,
            font: .title
        )

        #expect(customTheme.cornerRadius == 20)
        #expect(customTheme.height == 60)
    }
}

// MARK: - TextField Theme Tests

@Suite("TextField Theme")
struct TextFieldThemeTests {

    @Test("UITextFieldTheme conforms to protocol")
    func protocolConformance() {
        let theme: any UITextFieldThemeProtocol = UITextFieldTheme()
        #expect(theme.cornerRadius > 0)
        #expect(theme.height > 0)
    }

    @Test("Theme includes title properties from T002")
    func titleProperties() {
        let theme = UITextFieldTheme()
        // These properties were added in T002
        _ = theme.titleFont
        _ = theme.titleColor
        _ = theme.errorMessageFont
        _ = theme.errorMessageColor
    }
}

// MARK: - Checkbox Theme Tests

@Suite("Checkbox Theme")
struct CheckboxThemeTests {

    @Test("UICheckboxTheme conforms to protocol")
    func protocolConformance() {
        let theme: any UICheckboxThemeProtocol = UICheckboxTheme()
        #expect(theme.size > 0)
        #expect(theme.cornerRadius >= 0)
    }
}

// MARK: - Radio Button Theme Tests

@Suite("RadioButton Theme")
struct RadioButtonThemeTests {

    @Test("UIRadioButtonTheme conforms to protocol")
    func protocolConformance() {
        let theme: any UIRadioButtonThemeProtocol = UIRadioButtonTheme()
        #expect(theme.size > 0)
        #expect(theme.innerCircleScale > 0)
        #expect(theme.innerCircleScale <= 1)
    }
}

// MARK: - Toggle Theme Tests

@Suite("Toggle Theme")
struct ToggleThemeTests {

    @Test("UIToggleTheme conforms to protocol")
    func protocolConformance() {
        let theme: any UIToggleThemeProtocol = UIToggleTheme()
        #expect(theme.trackWidth > 0)
        #expect(theme.trackHeight > 0)
    }
}

// MARK: - Progress Theme Tests

@Suite("Progress Theme")
struct ProgressThemeTests {

    @Test("UIProgressTheme conforms to protocol")
    func protocolConformance() {
        let theme: any UIProgressThemeProtocol = UIProgressTheme.default
        #expect(theme.height > 0)
        #expect(theme.cornerRadius >= 0)
    }

    @Test("Preset themes are accessible")
    func presets() {
        let defaultTheme = UIProgressTheme.default
        let successTheme = UIProgressTheme.success
        let warningTheme = UIProgressTheme.warning
        let dangerTheme = UIProgressTheme.danger

        #expect(defaultTheme.fillColor != successTheme.fillColor)
        _ = warningTheme.fillColor
        _ = dangerTheme.fillColor
    }
}

// MARK: - Skeleton Theme Tests

@Suite("Skeleton Theme")
struct SkeletonThemeTests {

    @Test("Default theme has valid values")
    func defaults() {
        let theme = UISkeletonTheme.default
        _ = theme.baseColor
        _ = theme.highlightColor
        #expect(theme.animationDuration > 0)
    }

    @Test("Custom init sets animation duration")
    func customInit() {
        let customTheme = UISkeletonTheme(
            baseColor: .red,
            highlightColor: .orange,
            animationDuration: 2.0
        )
        #expect(customTheme.animationDuration == 2.0)
    }
}

// MARK: - Dialog Theme Tests

@Suite("Dialog Theme")
struct DialogThemeTests {

    @Test("UIDialogTheme conforms to protocol")
    func protocolConformance() {
        let theme: any UIDialogThemeProtocol = UIDialogTheme()
        #expect(theme.cornerRadius >= 0)
    }
}

// MARK: - Badge Theme Tests

@Suite("Badge Theme")
struct BadgeThemeTests {

    @Test("UIBadgeTheme conforms to protocol")
    func protocolConformance() {
        let theme: any UIBadgeThemeProtocol = UIBadgeTheme.default
        #expect(theme.cornerRadius >= 0)
    }

    @Test("Preset themes are accessible")
    func presets() {
        _ = UIBadgeTheme.default
        _ = UIBadgeTheme.success
        _ = UIBadgeTheme.warning
        _ = UIBadgeTheme.error
    }
}

// MARK: - Card Theme Tests

@Suite("Card Theme")
struct CardThemeTests {

    @Test("UICardTheme conforms to protocol")
    func protocolConformance() {
        let theme: any UICardThemeProtocol = UICardTheme()
        #expect(theme.cornerRadius >= 0)
        #expect(theme.shadowRadius >= 0)
    }
}

// MARK: - Sendable Conformance Tests

@Suite("Theme Sendable Conformance")
struct ThemeSendableTests {

    @Test("Themes can be used in async context")
    func sendableConformance() async {
        let buttonTheme = UIButtonTheme.primary
        let textFieldTheme = UITextFieldTheme()
        let progressTheme = UIProgressTheme.default

        _ = buttonTheme.backgroundColor
        _ = textFieldTheme.font
        _ = progressTheme.fillColor
    }
}
