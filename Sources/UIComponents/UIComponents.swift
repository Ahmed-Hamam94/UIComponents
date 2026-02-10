//
//  UIComponents.swift
//  UIComponents
//

import SwiftUI

/// The central namespace for the UIComponents Design System.
///
/// Use this namespace to access all components, themes, and utility types provided by the library.
/// Living under a namespace ensures that your project avoids naming collisions with SwiftUI or other 3rd party libraries.
///
/// ### Components
/// Most components are accessed directly through this namespace:
/// ```swift
/// UI.Button(title: "Log In", style: .primary) { ... }
/// UI.TextField(text: $user, placeholder: "Username")
/// ```
///
/// ### Theming
/// Access architectural theme types via ``Themes``:
/// ```swift
/// let myTheme = UI.Themes.Button(backgroundColor: .red)
/// ```
public enum UI {

    // MARK: - Themes Namespace

    /// A centralized location for architectural discovery of themes.
    ///
    /// Use these typealiases to discover available theme types for each component.
    /// Each theme type corresponds to a protocol-based styling system.
    public enum Themes {
        // Buttons & Selection
        public typealias Button = UIButtonTheme
        public typealias Checkbox = UICheckboxTheme
        public typealias RadioButton = UIRadioButtonTheme
        public typealias Toggle = UIToggleTheme
        public typealias Segmented = UISegmentedTheme
        
        // Form Inputs
        public typealias TextField = UITextFieldTheme
        
        // Display & Feedback
        public typealias Badge = UIBadgeTheme
        public typealias Card = UICardTheme
        public typealias Skeleton = UISkeletonTheme
        public typealias Toast = UIToastTheme
        
        // Modals & Layout
        public typealias Dialog = UIDialogTheme
        public typealias BottomSheet = UIBottomSheetTheme
    }

    // MARK: - Models & General Types

    /// Represents a country for international phone number picking.
    public typealias Country = UIComponents.Country
    
    /// Controls the alignment of an image relative to text content.
    public typealias ImagePosition = UIComponents.ImagePosition
    
    /// Determines when validation should be executed for form fields.
    public typealias ValidationTrigger = UIComponents.ValidationTrigger
    
    /// Specifies the anchor position for toast notifications.
    public typealias ToastPosition = UIComponents.ToastPosition
    
    /// Determines the visual style of segmented controls.
    public typealias SegmentedStyle = UIComponents.UISegmentedControlStyle

    // MARK: - Validation Utilities

    /// Centralized access to validation rules and logic.
    public enum Validation {
        /// A rule used to validate string input in ``ValidatedTextField``.
        public typealias Rule = ValidationRule
    }
}
