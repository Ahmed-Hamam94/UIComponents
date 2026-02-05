//
//  CheckboxTheme.swift
//  UIComponents
//
//  Created by Ahmed Hamam on 28/01/2026.
//

import SwiftUI

public protocol CheckboxThemeProtocol: Sendable {
    var checkedColor: Color { get }
    var uncheckedBorderColor: Color { get }
    var checkmarkColor: Color { get }
    var size: CGFloat { get }
    var cornerRadius: CGFloat { get }
    var borderWidth: CGFloat { get }
    var font: Font { get }
    var textColor: Color { get }
}

public struct DesignCheckboxTheme: CheckboxThemeProtocol, Sendable {
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

public extension CheckboxThemeProtocol where Self == DesignCheckboxTheme {
    static var primary: DesignCheckboxTheme {
        DesignCheckboxTheme()
    }
    
    static var secondary: DesignCheckboxTheme {
        DesignCheckboxTheme(
            checkedColor: .secondary,
            uncheckedBorderColor: .secondary
        )
    }
    
    static var success: DesignCheckboxTheme {
        DesignCheckboxTheme(
            checkedColor: .green,
            uncheckedBorderColor: .green.opacity(0.5)
        )
    }
}
