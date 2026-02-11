//
//  UIAccessibility.swift
//  UIComponents
//
//  Optional accessibility overrides for components. When a property is nil,
//  the component uses its built-in default. When non-nil, the provided value is used.
//

import SwiftUI

/// Optional accessibility configuration for UI components.
///
/// Use this to override the default accessibility label, value, hint, or traits
/// of any component. Omitted properties (nil) keep the component's built-in defaults.
///
/// ```swift
/// UI.Button(
///     title: "Submit",
///     style: .primary,
///     accessibility: UIAccessibility(label: "Submit form", hint: "Double tap to send")
/// ) { submit() }
/// ```
public struct UIAccessibility: Sendable {
    /// VoiceOver label describing the element. Nil = use component default.
    public var label: String?
    /// Current value (e.g. "Checked", "50 percent"). Nil = use component default.
    public var value: String?
    /// Hint describing the action. Nil = use component default.
    public var hint: String?
    /// Accessibility traits (e.g. .isButton, .isSelected). Nil = use component default.
    public var traits: AccessibilityTraits?

    public init(
        label: String? = nil,
        value: String? = nil,
        hint: String? = nil,
        traits: AccessibilityTraits? = nil
    ) {
        self.label = label
        self.value = value
        self.hint = hint
        self.traits = traits
    }
}

// MARK: - View extension

extension View {
    /// Applies optional accessibility overrides with fallback defaults.
    /// Use when building a component: pass the consumer's `UIAccessibility?` and the component's defaults.
    /// Only applies modifiers for the effective (non-empty) label, value, hint, and traits.
    @ViewBuilder
    func uiAccessibility(
        _ accessibility: UIAccessibility?,
        defaultLabel: String? = nil,
        defaultValue: String? = nil,
        defaultHint: String? = nil,
        defaultTraits: AccessibilityTraits? = nil
    ) -> some View {
        let label = accessibility?.label ?? defaultLabel
        let value = accessibility?.value ?? defaultValue
        let hint = accessibility?.hint ?? defaultHint
        let traits = accessibility?.traits ?? defaultTraits

        self
            .modifier(UIAccessibilityModifier(
                label: label,
                value: value,
                hint: hint,
                traits: traits
            ))
    }
}

// MARK: - Modifier

private struct UIAccessibilityModifier: ViewModifier {
    let label: String?
    let value: String?
    let hint: String?
    let traits: AccessibilityTraits?

    func body(content: Content) -> some View {
        content
            .modifier(OptionalLabelModifier(label: label))
            .modifier(OptionalValueModifier(value: value))
            .modifier(OptionalHintModifier(hint: hint))
            .modifier(OptionalTraitsModifier(traits: traits))
    }
}

private struct OptionalLabelModifier: ViewModifier {
    let label: String?
    func body(content: Content) -> some View {
        if let label, !label.isEmpty {
            content.accessibilityLabel(label)
        } else {
            content
        }
    }
}

private struct OptionalValueModifier: ViewModifier {
    let value: String?
    func body(content: Content) -> some View {
        if let value, !value.isEmpty {
            content.accessibilityValue(value)
        } else {
            content
        }
    }
}

private struct OptionalHintModifier: ViewModifier {
    let hint: String?
    func body(content: Content) -> some View {
        if let hint, !hint.isEmpty {
            content.accessibilityHint(hint)
        } else {
            content
        }
    }
}

private struct OptionalTraitsModifier: ViewModifier {
    let traits: AccessibilityTraits?
    func body(content: Content) -> some View {
        if let traits {
            content.accessibilityAddTraits(traits)
        } else {
            content
        }
    }
}
