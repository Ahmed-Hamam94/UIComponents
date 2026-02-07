//
//  TextFieldTheme.swift
//  UIComponents
//
//  Created by Ahmed Hamam on 26/01/2026.
//

import SwiftUI

public protocol UITextFieldThemeProtocol: Sendable {
    // Typography
    var font: Font { get }
    var placeholderFont: Font { get }
    
    // Colors - Default State
    var placeholderColor: Color { get }
    var textColor: Color { get }
    var backgroundColor: Color { get }
    var borderColor: Color { get }
    var iconColor: Color { get }
    
    // Colors - Focus State
    var focusBorderColor: Color { get }
    var focusBackgroundColor: Color { get }
    
    // Colors - Error State
    var errorBorderColor: Color { get }
    var errorTextColor: Color { get }
    var errorBackgroundColor: Color { get }
    
    // Colors - Disabled State
    var disabledBackgroundColor: Color { get }
    var disabledTextColor: Color { get }
    var disabledBorderColor: Color { get }
    
    // Dimensions
    var borderWidth: CGFloat { get }
    var cornerRadius: CGFloat { get }
    var height: CGFloat { get }
}

public struct UITextFieldTheme: UITextFieldThemeProtocol, Sendable {
    // Typography
    public var font: Font
    public var placeholderFont: Font
    
    // Colors - Default State
    public var placeholderColor: Color
    public var textColor: Color
    public var backgroundColor: Color
    public var borderColor: Color
    public var iconColor: Color
    
    // Colors - Focus State
    public var focusBorderColor: Color
    public var focusBackgroundColor: Color
    
    // Colors - Error State
    public var errorBorderColor: Color
    public var errorTextColor: Color
    public var errorBackgroundColor: Color
    
    // Colors - Disabled State
    public var disabledBackgroundColor: Color
    public var disabledTextColor: Color
    public var disabledBorderColor: Color
    
    // Dimensions
    public var borderWidth: CGFloat
    public var cornerRadius: CGFloat
    public var height: CGFloat
    
    public init(
        font: Font = .body,
        placeholderFont: Font = .body,
        placeholderColor: Color = .gray,
        textColor: Color = .primary,
        backgroundColor: Color = .gray.opacity(0.15),
        borderColor: Color = .clear,
        iconColor: Color = .gray,
        focusBorderColor: Color = .blue,
        focusBackgroundColor: Color = .gray.opacity(0.15),
        errorBorderColor: Color = .red,
        errorTextColor: Color = .red,
        errorBackgroundColor: Color = .red.opacity(0.05),
        disabledBackgroundColor: Color = .gray.opacity(0.2),
        disabledTextColor: Color = .gray,
        disabledBorderColor: Color = .clear,
        borderWidth: CGFloat = 1,
        cornerRadius: CGFloat = 8,
        height: CGFloat = 44
    ) {
        self.font = font
        self.placeholderFont = placeholderFont
        self.placeholderColor = placeholderColor
        self.textColor = textColor
        self.backgroundColor = backgroundColor
        self.borderColor = borderColor
        self.iconColor = iconColor
        self.focusBorderColor = focusBorderColor
        self.focusBackgroundColor = focusBackgroundColor
        self.errorBorderColor = errorBorderColor
        self.errorTextColor = errorTextColor
        self.errorBackgroundColor = errorBackgroundColor
        self.disabledBackgroundColor = disabledBackgroundColor
        self.disabledTextColor = disabledTextColor
        self.disabledBorderColor = disabledBorderColor
        self.borderWidth = borderWidth
        self.cornerRadius = cornerRadius
        self.height = height
    }
}
