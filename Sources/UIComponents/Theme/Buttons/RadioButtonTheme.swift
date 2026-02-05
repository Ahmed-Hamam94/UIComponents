//
//  RadioButtonTheme.swift
//  UIComponents
//
//  Created by Ahmed Hamam on 28/01/2026.
//

import SwiftUI

public protocol RadioButtonThemeProtocol: Sendable {
    var selectedColor: Color { get }
    var unselectedBorderColor: Color { get }
    var size: CGFloat { get }
    var innerCircleScale: CGFloat { get }
    var borderWidth: CGFloat { get }
    var font: Font { get }
    var textColor: Color { get }
}

public struct DesignRadioButtonTheme: RadioButtonThemeProtocol, Sendable {
    public var selectedColor: Color
    public var unselectedBorderColor: Color
    public var size: CGFloat
    public var innerCircleScale: CGFloat
    public var borderWidth: CGFloat
    public var font: Font
    public var textColor: Color
    
    public init(
        selectedColor: Color = .blue,
        unselectedBorderColor: Color = .gray,
        size: CGFloat = 24,
        innerCircleScale: CGFloat = 0.5,
        borderWidth: CGFloat = 2,
        font: Font = .body,
        textColor: Color = .primary
    ) {
        self.selectedColor = selectedColor
        self.unselectedBorderColor = unselectedBorderColor
        self.size = size
        self.innerCircleScale = innerCircleScale
        self.borderWidth = borderWidth
        self.font = font
        self.textColor = textColor
    }
}

public extension RadioButtonThemeProtocol where Self == DesignRadioButtonTheme {
    static var primary: DesignRadioButtonTheme {
        DesignRadioButtonTheme()
    }
    
    static var secondary: DesignRadioButtonTheme {
        DesignRadioButtonTheme(
            selectedColor: .secondary,
            unselectedBorderColor: .secondary
        )
    }
    
    static var success: DesignRadioButtonTheme {
        DesignRadioButtonTheme(
            selectedColor: .green,
            unselectedBorderColor: .green.opacity(0.5)
        )
    }
}
