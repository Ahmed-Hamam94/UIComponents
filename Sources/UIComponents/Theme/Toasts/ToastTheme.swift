//
//  ToastTheme.swift
//  UIComponents
//
//  Created by Ahmed Hamam on 28/01/2026.
//

import SwiftUI

public protocol ToastThemeProtocol: Sendable {
    var backgroundColor: Color { get }
    var textColor: Color { get }
    var font: Font { get }
    var cornerRadius: CGFloat { get }
    var shadowColor: Color { get }
    var padding: CGFloat { get }
    var iconColor: Color { get }
}

public struct DesignToastTheme: ToastThemeProtocol, Sendable {
    public var backgroundColor: Color
    public var textColor: Color
    public var font: Font
    public var cornerRadius: CGFloat
    public var shadowColor: Color
    public var padding: CGFloat
    public var iconColor: Color
    
    public init(
        backgroundColor: Color = .white,
        textColor: Color = .primary,
        font: Font = .subheadline,
        cornerRadius: CGFloat = 12,
        shadowColor: Color = Color.black.opacity(0.15),
        padding: CGFloat = 16,
        iconColor: Color = .blue
    ) {
        self.backgroundColor = backgroundColor
        self.textColor = textColor
        self.font = font
        self.cornerRadius = cornerRadius
        self.shadowColor = shadowColor
        self.padding = padding
        self.iconColor = iconColor
    }
}

public extension ToastThemeProtocol where Self == DesignToastTheme {
    static var `default`: DesignToastTheme {
        DesignToastTheme()
    }
    
    static var error: DesignToastTheme {
        DesignToastTheme(iconColor: .red)
    }
    
    static var success: DesignToastTheme {
        DesignToastTheme(iconColor: .green)
    }
    
    static var warning: DesignToastTheme {
        DesignToastTheme(iconColor: .orange)
    }
}
