//
//  UIButtonTheme.swift
//  UIComponents
//
//  Created by Ahmed Hamam on 16/10/2025.
//

import SwiftUI

public protocol UIButtonThemeProtocol: Sendable {
    var backgroundColor: Color { get }
    var disabledBackgroundColor: Color { get }
    var foregroundColor: Color { get }
    var cornerRadius: CGFloat { get }
    var height: CGFloat { get }
    var font: Font { get }
    var pressedOpacity: Double { get }
}

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
