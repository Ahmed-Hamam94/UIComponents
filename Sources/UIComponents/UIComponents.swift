//
//  UIComponents.swift
//  UIComponents
//

import SwiftUI

/// The central namespace for the Design System.
/// Use this namespace to access all components and themes.
public enum UI {

    // MARK: - Themes Namespace

    /// A centralized location for architectural discovery of themes.
    /// You can use these typealiases to discover available theme types.
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

    public typealias Country = UIComponents.Country
    public typealias ImagePosition = UIComponents.ImagePosition
    public typealias ValidationTrigger = UIComponents.ValidationTrigger
    public typealias ToastPosition = UIComponents.ToastPosition

    // MARK: - Validation Utilities

    /// Centralized access to validation rules and logic.
    public enum Validation {
        public typealias Rule = ValidationRule
    }
}
