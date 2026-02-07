//
//  BadgeTheme.swift
//  UIComponents
//
//  Created by Ahmed Hamam on 28/01/2026.
//

import SwiftUI

public protocol UIBadgeThemeProtocol: Sendable {
    var backgroundColor: Color { get }
    var textColor: Color { get }
    var font: Font { get }
    var cornerRadius: CGFloat { get }
    var horizontalPadding: CGFloat { get }
    var verticalPadding: CGFloat { get }
    var height: CGFloat { get }
    var width: CGFloat { get }
}

public struct UIBadgeTheme: UIBadgeThemeProtocol, Sendable {
    public var backgroundColor: Color
    public var textColor: Color
    public var font: Font
    public var cornerRadius: CGFloat
    public var horizontalPadding: CGFloat
    public var verticalPadding: CGFloat
    public var height: CGFloat
    public var width: CGFloat
    
    public init(
        backgroundColor: Color = .blue,
        textColor: Color = .white,
        font: Font = .caption.bold(),
        cornerRadius: CGFloat = 8,
        horizontalPadding: CGFloat = 8,
        verticalPadding: CGFloat = 4,
        height: CGFloat = 24,
        width: CGFloat = 48
    ) {
        self.backgroundColor = backgroundColor
        self.textColor = textColor
        self.font = font
        self.cornerRadius = cornerRadius
        self.horizontalPadding = horizontalPadding
        self.verticalPadding = verticalPadding
        self.height = height
        self.width = width
    }
}

public extension UIBadgeThemeProtocol where Self == UIBadgeTheme {
    static var `default`: UIBadgeTheme {
        UIBadgeTheme()
    }
    
    static var success: UIBadgeTheme {
        UIBadgeTheme(backgroundColor: .green, textColor: .white)
    }
    
    static var warning: UIBadgeTheme {
        UIBadgeTheme(backgroundColor: .orange, textColor: .white)
    }
    
    static var error: UIBadgeTheme {
        UIBadgeTheme(backgroundColor: .red, textColor: .white)
    }
}
