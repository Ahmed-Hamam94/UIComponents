//
//  UIComponentsTheme.swift
//  UIComponents
//
//  Created by Ahmed Hamam on 28/02/2026.
//

import SwiftUI

// MARK: - UIComponents Theme Container

/// A container holding all component themes for app-wide theming.
///
/// Use this with the `.uiComponentsTheme()` modifier to inject themes
/// into the environment for all descendant views.
///
/// ```swift
/// @main
/// struct MyApp: App {
///     var body: some Scene {
///         WindowGroup {
///             ContentView()
///                 .uiComponentsTheme(UIComponentsTheme.dark)
///         }
///     }
/// }
/// ```
public struct UIComponentsTheme: Sendable {
    // MARK: - Button Themes
    
    /// Default theme for primary buttons.
    public var buttonPrimary: UIButtonTheme
    /// Default theme for secondary buttons.
    public var buttonSecondary: UIButtonTheme
    /// Default theme for destructive buttons.
    public var buttonDestructive: UIButtonTheme
    /// Default theme for ghost buttons.
    public var buttonGhost: UIButtonTheme
    /// Default theme for link buttons.
    public var buttonLink: UIButtonTheme
    
    // MARK: - TextField Themes
    
    /// Default theme for text fields.
    public var textField: UITextFieldTheme
    
    // MARK: - Toggle Themes
    
    /// Default theme for toggles.
    public var toggle: UIToggleTheme
    
    // MARK: - Checkbox Themes
    
    /// Default theme for checkboxes.
    public var checkbox: UICheckboxTheme
    
    // MARK: - Radio Button Themes
    
    /// Default theme for radio buttons.
    public var radioButton: UIRadioButtonTheme
    
    // MARK: - Progress Themes
    
    /// Default theme for progress bars.
    public var progress: UIProgressTheme
    
    // MARK: - Badge Themes
    
    /// Default theme for info badges.
    public var badgeInfo: UIBadgeTheme
    /// Default theme for success badges.
    public var badgeSuccess: UIBadgeTheme
    /// Default theme for warning badges.
    public var badgeWarning: UIBadgeTheme
    /// Default theme for error badges.
    public var badgeError: UIBadgeTheme
    
    // MARK: - Card Themes
    
    /// Default theme for cards.
    public var card: UICardTheme
    
    // MARK: - Dialog Themes
    
    /// Default theme for dialogs.
    public var dialog: UIDialogTheme
    
    // MARK: - Toast Themes
    
    /// Default theme for toasts.
    public var toast: UIToastTheme
    
    // MARK: - Skeleton Themes
    
    /// Default theme for skeleton loading effects.
    public var skeleton: UISkeletonTheme
    
    // MARK: - Bottom Sheet Themes
    
    /// Default theme for bottom sheets.
    public var bottomSheet: UIBottomSheetTheme
    
    // MARK: - Segmented Control Themes
    
    /// Default theme for segmented controls.
    public var segmentedControl: UISegmentedTheme
    
    // MARK: - Initialization
    
    public init(
        buttonPrimary: UIButtonTheme = .primary,
        buttonSecondary: UIButtonTheme = .secondary,
        buttonDestructive: UIButtonTheme = .destructive,
        buttonGhost: UIButtonTheme = UIButtonTheme(backgroundColor: .clear, foregroundColor: .primary),
        buttonLink: UIButtonTheme = UIButtonTheme(backgroundColor: .clear, foregroundColor: .blue),
        textField: UITextFieldTheme = UITextFieldTheme(),
        toggle: UIToggleTheme = UIToggleTheme(),
        checkbox: UICheckboxTheme = UICheckboxTheme(),
        radioButton: UIRadioButtonTheme = UIRadioButtonTheme(),
        progress: UIProgressTheme = .default,
        badgeInfo: UIBadgeTheme = .default,
        badgeSuccess: UIBadgeTheme = .success,
        badgeWarning: UIBadgeTheme = .warning,
        badgeError: UIBadgeTheme = .error,
        card: UICardTheme = UICardTheme(),
        dialog: UIDialogTheme = UIDialogTheme(),
        toast: UIToastTheme = UIToastTheme(),
        skeleton: UISkeletonTheme = .default,
        bottomSheet: UIBottomSheetTheme = UIBottomSheetTheme(),
        segmentedControl: UISegmentedTheme = UISegmentedTheme()
    ) {
        self.buttonPrimary = buttonPrimary
        self.buttonSecondary = buttonSecondary
        self.buttonDestructive = buttonDestructive
        self.buttonGhost = buttonGhost
        self.buttonLink = buttonLink
        self.textField = textField
        self.toggle = toggle
        self.checkbox = checkbox
        self.radioButton = radioButton
        self.progress = progress
        self.badgeInfo = badgeInfo
        self.badgeSuccess = badgeSuccess
        self.badgeWarning = badgeWarning
        self.badgeError = badgeError
        self.card = card
        self.dialog = dialog
        self.toast = toast
        self.skeleton = skeleton
        self.bottomSheet = bottomSheet
        self.segmentedControl = segmentedControl
    }
}

// MARK: - Presets

public extension UIComponentsTheme {
    /// The default light theme.
    static let `default` = UIComponentsTheme()
    
    /// A dark theme preset.
    static var dark: UIComponentsTheme {
        UIComponentsTheme(
            buttonPrimary: UIButtonTheme(
                backgroundColor: .blue,
                disabledBackgroundColor: .gray.opacity(0.3),
                foregroundColor: .white,
                cornerRadius: 12,
                height: 50,
                font: .headline
            ),
            buttonSecondary: UIButtonTheme(
                backgroundColor: .gray.opacity(0.3),
                disabledBackgroundColor: .gray.opacity(0.2),
                foregroundColor: .white,
                cornerRadius: 12,
                height: 50,
                font: .headline
            ),
            textField: UITextFieldTheme(
                placeholderColor: .gray,
                textColor: .white,
                backgroundColor: .gray.opacity(0.2),
                borderColor: .gray.opacity(0.5),
                focusBorderColor: .blue,
                focusBackgroundColor: .gray.opacity(0.25)
            ),
            card: UICardTheme(
                backgroundColor: Color(white: 0.15),
                cornerRadius: 16,
                shadowColor: .black.opacity(0.3),
                shadowRadius: 8
            ),
            skeleton: UISkeletonTheme(
                baseColor: .gray.opacity(0.3),
                highlightColor: .gray.opacity(0.5)
            )
        )
    }
    
    /// An accent-colored theme preset.
    static var accent: UIComponentsTheme {
        UIComponentsTheme(
            buttonPrimary: UIButtonTheme(
                backgroundColor: .purple,
                disabledBackgroundColor: .purple.opacity(0.3),
                foregroundColor: .white,
                cornerRadius: 16,
                height: 52,
                font: .headline
            ),
            progress: UIProgressTheme(
                trackColor: .purple.opacity(0.2),
                fillColor: .purple,
                textColor: .primary
            )
        )
    }
}

// MARK: - Environment Key

private struct UIComponentsThemeKey: EnvironmentKey {
    static let defaultValue: UIComponentsTheme = .default
}

public extension EnvironmentValues {
    /// The current UIComponents theme from the environment.
    var uiComponentsTheme: UIComponentsTheme {
        get { self[UIComponentsThemeKey.self] }
        set { self[UIComponentsThemeKey.self] = newValue }
    }
}

// MARK: - View Modifier

public extension View {
    /// Injects a UIComponents theme into the environment for all descendant views.
    ///
    /// Components can read this theme from the environment and use it as their default
    /// when no explicit theme parameter is provided.
    ///
    /// ```swift
    /// ContentView()
    ///     .uiComponentsTheme(.dark)
    /// ```
    ///
    /// - Parameter theme: The theme to inject into the environment.
    /// - Returns: A view with the theme injected into the environment.
    func uiComponentsTheme(_ theme: UIComponentsTheme) -> some View {
        self.environment(\.uiComponentsTheme, theme)
    }
}

// MARK: - Theme Reader Protocol

/// A protocol for views that can read from the UIComponents theme environment.
///
/// Implement this protocol to enable automatic theme reading from the environment.
public protocol UIComponentsThemeReader {
    /// The environment theme, if available.
    var environmentTheme: UIComponentsTheme { get }
}
