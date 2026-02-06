//
//  DialogTheme.swift
//  UIComponents
//
//  Created by Ahmed Hamam on 28/01/2026.
//

import SwiftUI

public protocol DialogThemeProtocol: Sendable {
    var backgroundColor: Color { get }
    var cornerRadius: CGFloat { get }
    var titleFont: Font { get }
    var messageFont: Font { get }
    var buttonFont: Font { get }
    var titleColor: Color { get }
    var messageColor: Color { get }
    var overlayColor: Color { get }
    var maxWidth: CGFloat { get }
}

public struct DesignDialogTheme: DialogThemeProtocol, Sendable {
    public var backgroundColor: Color
    public var cornerRadius: CGFloat
    public var titleFont: Font
    public var messageFont: Font
    public var buttonFont: Font
    public var titleColor: Color
    public var messageColor: Color
    public var overlayColor: Color
    public var maxWidth: CGFloat
    
    public init(
        backgroundColor: Color = .white,
        cornerRadius: CGFloat = 16,
        titleFont: Font = .headline,
        messageFont: Font = .subheadline,
        buttonFont: Font = .body.weight(.semibold),
        titleColor: Color = .primary,
        messageColor: Color = .secondary,
        overlayColor: Color = Color.black.opacity(0.4),
        maxWidth: CGFloat = 300
    ) {
        self.backgroundColor = backgroundColor
        self.cornerRadius = cornerRadius
        self.titleFont = titleFont
        self.messageFont = messageFont
        self.buttonFont = buttonFont
        self.titleColor = titleColor
        self.messageColor = messageColor
        self.overlayColor = overlayColor
        self.maxWidth = maxWidth
    }
}

public extension DialogThemeProtocol where Self == DesignDialogTheme {
    static var `default`: DesignDialogTheme {
        DesignDialogTheme()
    }
}
