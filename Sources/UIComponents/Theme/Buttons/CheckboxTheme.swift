//
//  CheckboxTheme.swift
//  UIComponents
//
//  Created by Ahmed Hamam on 28/01/2026.
//

import SwiftUI

public protocol UICheckboxThemeProtocol: Sendable {
    var checkedColor: Color { get }
    var uncheckedBorderColor: Color { get }
    var checkmarkColor: Color { get }
    var size: CGFloat { get }
    var cornerRadius: CGFloat { get }
    var borderWidth: CGFloat { get }
    var font: Font { get }
    var textColor: Color { get }
}

public struct UICheckboxTheme: UICheckboxThemeProtocol, Sendable {
    public var checkedColor: Color
    public var uncheckedBorderColor: Color
    public var checkmarkColor: Color
    public var size: CGFloat
    public var cornerRadius: CGFloat
    public var borderWidth: CGFloat
    public var font: Font
    public var textColor: Color
    
    public init(
        checkedColor: Color = .blue,
        uncheckedBorderColor: Color = .gray,
        checkmarkColor: Color = .white,
        size: CGFloat = 24,
        cornerRadius: CGFloat = 4,
        borderWidth: CGFloat = 2,
        font: Font = .body,
        textColor: Color = .primary
    ) {
        self.checkedColor = checkedColor
        self.uncheckedBorderColor = uncheckedBorderColor
        self.checkmarkColor = checkmarkColor
        self.size = size
        self.cornerRadius = cornerRadius
        self.borderWidth = borderWidth
        self.font = font
        self.textColor = textColor
    }
}

public extension UICheckboxThemeProtocol where Self == UICheckboxTheme {
    static var primary: UICheckboxTheme {
        UICheckboxTheme()
    }
    
    static var secondary: UICheckboxTheme {
        UICheckboxTheme(
            checkedColor: .secondary,
            uncheckedBorderColor: .secondary
        )
    }
    
    static var success: UICheckboxTheme {
        UICheckboxTheme(
            checkedColor: .green,
            uncheckedBorderColor: .green.opacity(0.5)
        )
    }
}
