//
//  TextFieldTheme.swift
//  UIComponents
//
//  Created by Ahmed Hamam on 26/01/2026.
//

import SwiftUI

public protocol TextFieldThemeProtocol {
    var font: Font { get }
    var placeholderFont: Font { get }
    var placeholderColor: Color { get }
    var textColor: Color { get }
    var backgroundColor: Color { get }
    var borderColor: Color { get }
    var borderWidth: CGFloat { get }
    var cornerRadius: CGFloat { get }
    var height: CGFloat { get }
}

public struct DesignTextFieldTheme: TextFieldThemeProtocol {
    public var font: Font
    public var placeholderFont: Font
    public var placeholderColor: Color
    public var textColor: Color
    public var backgroundColor: Color
    public var borderColor: Color
    public var borderWidth: CGFloat
    public var cornerRadius: CGFloat
    public var height: CGFloat
    
    public init(
        font: Font = .body,
        placeholderFont: Font = .body,
        placeholderColor: Color = .gray,
        textColor: Color = .black,
        backgroundColor: Color = .init(white: 0.95),
        borderColor: Color = .clear,
        borderWidth: CGFloat = 0,
        cornerRadius: CGFloat = 8,
        height: CGFloat = 44
    ) {
        self.font = font
        self.placeholderFont = placeholderFont
        self.placeholderColor = placeholderColor
        self.textColor = textColor
        self.backgroundColor = backgroundColor
        self.borderColor = borderColor
        self.borderWidth = borderWidth
        self.cornerRadius = cornerRadius
        self.height = height
    }
}
