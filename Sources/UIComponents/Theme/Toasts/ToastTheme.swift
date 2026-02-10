//
//  ToastTheme.swift
//  UIComponents
//
//  Created by Ahmed Hamam on 28/01/2026.
//

import SwiftUI

/// A protocol defining the visual properties of a toast notification.
public protocol UIToastThemeProtocol: Sendable {
    var backgroundColor: Color { get }
    var textColor: Color { get }
    var font: Font { get }
    var cornerRadius: CGFloat { get }
    var shadowColor: Color { get }
    var padding: CGFloat { get }
    var iconColor: Color { get }
    /// An optional default SF Symbol name for the toast.
    var defaultIcon: String? { get }
}

/// A standard implementation of `UIToastThemeProtocol`.
public struct UIToastTheme: UIToastThemeProtocol, Sendable {
    public var backgroundColor: Color
    public var textColor: Color
    public var font: Font
    public var cornerRadius: CGFloat
    public var shadowColor: Color
    public var padding: CGFloat
    public var iconColor: Color
    public var defaultIcon: String?
    
    public init(
        backgroundColor: Color = .white,
        textColor: Color = .primary,
        font: Font = .subheadline,
        cornerRadius: CGFloat = 12,
        shadowColor: Color = Color.black.opacity(0.15),
        padding: CGFloat = 16,
        iconColor: Color = .blue,
        defaultIcon: String? = nil
    ) {
        self.backgroundColor = backgroundColor
        self.textColor = textColor
        self.font = font
        self.cornerRadius = cornerRadius
        self.shadowColor = shadowColor
        self.padding = padding
        self.iconColor = iconColor
        self.defaultIcon = defaultIcon
    }
}

public extension UIToastThemeProtocol where Self == UIToastTheme {
    static var `default`: UIToastTheme {
        UIToastTheme()
    }
    
    static var error: UIToastTheme {
        UIToastTheme(iconColor: .red, defaultIcon: "xmark.circle.fill")
    }
    
    static var success: UIToastTheme {
        UIToastTheme(iconColor: .green, defaultIcon: "checkmark.circle.fill")
    }
    
    static var warning: UIToastTheme {
        UIToastTheme(iconColor: .orange, defaultIcon: "exclamationmark.triangle.fill")
    }
}
