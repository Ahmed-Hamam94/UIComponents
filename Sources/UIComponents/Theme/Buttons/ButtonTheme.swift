//
//  UIButtonTheme.swift
//  UIComponents
//
//  Created by Ahmed Hamam on 16/10/2025.
//

import SwiftUI

/// A protocol defining the visual properties of a button.
///
/// Implement this protocol to create custom button styles, or use `UIButtonTheme`.
public protocol UIButtonThemeProtocol: Sendable {
    /// The background color of the button in its normal state.
    var backgroundColor: Color { get }
    /// The background color when the button is disabled.
    var disabledBackgroundColor: Color { get }
    /// The color of the text or image inside the button.
    var foregroundColor: Color { get }
    /// The radius used to round the button's corners.
    var cornerRadius: CGFloat { get }
    /// The fixed vertical height of the button.
    var height: CGFloat { get }
    /// The font used for the button's title.
    var font: Font { get }
    /// The opacity of the button when it is being pressed.
    var pressedOpacity: Double { get }
}

/// A standard implementation of `UIButtonThemeProtocol`.
///
/// Use this struct to instantiate predefined themes or create ad-hoc button styles.
public struct UIButtonTheme: UIButtonThemeProtocol, Sendable {
    public var backgroundColor: Color
    public var disabledBackgroundColor: Color
    public var foregroundColor: Color
    public var cornerRadius: CGFloat
    public var height: CGFloat
    public var font: Font
    public var pressedOpacity: Double
    
    public init(
        backgroundColor: Color = .blue,
        disabledBackgroundColor: Color? = nil,
        foregroundColor: Color = .white,
        cornerRadius: CGFloat = 6.0,
        height: CGFloat = 48,
        font: Font = .body,
        pressedOpacity: Double = 0.7
    ) {
        self.backgroundColor = backgroundColor
        self.disabledBackgroundColor = disabledBackgroundColor ?? backgroundColor.opacity(0.5)
        self.foregroundColor = foregroundColor
        self.cornerRadius = cornerRadius
        self.height = height
        self.font = font
        self.pressedOpacity = pressedOpacity
    }
}

// MARK: - Standard Themes
public extension UIButtonThemeProtocol where Self == UIButtonTheme {
    static var primary: UIButtonTheme {
        UIButtonTheme(
            backgroundColor: .blue,
            foregroundColor: .white,
            font: .title2
        )
    }
    
    static var secondary: UIButtonTheme {
        UIButtonTheme(
            backgroundColor: Color.gray.opacity(0.2),
            foregroundColor: .primary,
            font: .title2
        )
    }
    
    static var destructive: UIButtonTheme {
        UIButtonTheme(
            backgroundColor: .red,
            foregroundColor: .white,
            font: .title2
        )
    }
}
