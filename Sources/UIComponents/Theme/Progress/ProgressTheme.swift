//
//  ProgressTheme.swift
//  UIComponents
//
//  Created by Ahmed Hamam on 10/02/2026.
//

import SwiftUI

/// A protocol defining the visual properties of a progress indicator.
public protocol UIProgressThemeProtocol: Sendable {
    var trackColor: Color { get }
    var fillColor: Color { get }
    var height: CGFloat { get }
    var cornerRadius: CGFloat { get }
    var showPercentage: Bool { get }
    var font: Font { get }
    var textColor: Color { get }
}

/// A standard implementation of `UIProgressThemeProtocol`.
public struct UIProgressTheme: UIProgressThemeProtocol, Sendable {
    public var trackColor: Color
    public var fillColor: Color
    public var height: CGFloat
    public var cornerRadius: CGFloat
    public var showPercentage: Bool
    public var font: Font
    public var textColor: Color
    
    public init(
        trackColor: Color = .gray.opacity(0.2),
        fillColor: Color = .blue,
        height: CGFloat = 8,
        cornerRadius: CGFloat = 4,
        showPercentage: Bool = false,
        font: Font = .caption,
        textColor: Color = .primary
    ) {
        self.trackColor = trackColor
        self.fillColor = fillColor
        self.height = height
        self.cornerRadius = cornerRadius
        self.showPercentage = showPercentage
        self.font = font
        self.textColor = textColor
    }
}

public extension UIProgressThemeProtocol where Self == UIProgressTheme {
    static var `default`: UIProgressTheme {
        UIProgressTheme()
    }
    
    static var success: UIProgressTheme {
        UIProgressTheme(fillColor: .green)
    }
    
    static var warning: UIProgressTheme {
        UIProgressTheme(fillColor: .orange)
    }
    
    static var danger: UIProgressTheme {
        UIProgressTheme(fillColor: .red)
    }
}
