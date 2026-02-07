//
//  UIComponents.swift
//  UIComponents
//
//  A Swift Package providing reusable, themeable UI components.
//

import SwiftUI

// MARK: - Components

// Buttons
public typealias Button = DesignButton
public typealias ImageButton = DesignImageButton
public typealias Checkbox = DesignCheckboxButton
public typealias RadioButton = DesignRadioButton

// Text Fields (use DesignTextField; typealias TextField would shadow SwiftUI.TextField)

// Toggles (use DesignToggle; typealias Toggle would shadow SwiftUI.Toggle)

// Containers
public typealias Card = DesignCard

// Badges
public typealias Badge = DesignBadge

// Pickers
public typealias SegmentedControl = DesignSegmentedControl

// Modals
public typealias Dialog = DesignDialog

// Sheets
public typealias BottomSheet = DesignBottomSheet

// Toasts
public typealias Toast = DesignToast

// Skeletons
public typealias Skeleton = DesignSkeleton

// MARK: - Themes Namespace

/// Namespace for all theme protocols and default implementations.
public enum Themes {
    // Button Themes
    public typealias Button = ButtonTheme
    public typealias Checkbox = DesignCheckboxTheme
    public typealias RadioButton = DesignRadioButtonTheme
    
    // TextField Theme
    public typealias TextField = DesignTextFieldTheme
    
    // Toggle Theme
    public typealias Toggle = DesignToggleTheme
    
    // Container Themes
    public typealias Card = DesignCardTheme
    
    // Badge Theme
    public typealias Badge = DesignBadgeTheme
    
    // Picker Themes
    public typealias Segmented = DesignSegmentedTheme
    
    // Modal Themes
    public typealias Dialog = DesignDialogTheme
    
    // Sheet Themes
    public typealias BottomSheet = DesignBottomSheetTheme
    
    // Toast Theme
    public typealias Toast = DesignToastTheme
    
    // Skeleton Theme
    public typealias Skeleton = DesignSkeletonTheme
}

// MARK: - Validation

/// Namespace for validation utilities.
public enum Validation {
    public typealias Rule = ValidationRule
}
