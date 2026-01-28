//
//  BadgeThemeProtocol.swift
//  UIComponents
//
//  Created by Ahmed Hamam on 28/01/2026.

import SwiftUI

public protocol BadgeThemeProtocol {
    var backgroundColor: Color { get }
    var textColor: Color { get }
    var font: Font { get }
    var cornerRadius: CGFloat { get }
    var horizontalPadding: CGFloat { get }
    var verticalPadding: CGFloat { get }
}

public struct DesignBadgeTheme: BadgeThemeProtocol {
    public var backgroundColor: Color
    public var textColor: Color
    public var font: Font
    public var cornerRadius: CGFloat
    public var horizontalPadding: CGFloat
    public var verticalPadding: CGFloat
    
    public init(
        backgroundColor: Color = .blue,
        textColor: Color = .white,
        font: Font = .caption.bold(),
        cornerRadius: CGFloat = 8,
        horizontalPadding: CGFloat = 8,
        verticalPadding: CGFloat = 4
    ) {
        self.backgroundColor = backgroundColor
        self.textColor = textColor
        self.font = font
        self.cornerRadius = cornerRadius
        self.horizontalPadding = horizontalPadding
        self.verticalPadding = verticalPadding
    }
}

public extension DesignBadgeTheme {
    static var success: DesignBadgeTheme {
        DesignBadgeTheme(backgroundColor: .green, textColor: .white)
    }
    
    static var warning: DesignBadgeTheme {
        DesignBadgeTheme(backgroundColor: .orange, textColor: .white)
    }
    
    static var error: DesignBadgeTheme {
        DesignBadgeTheme(backgroundColor: .red, textColor: .white)
    }
}
