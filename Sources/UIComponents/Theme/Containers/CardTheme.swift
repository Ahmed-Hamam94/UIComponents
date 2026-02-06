//
//  CardTheme.swift
//  UIComponents
//
//  Created by Ahmed Hamam on 28/01/2026.
//

import SwiftUI

public protocol CardThemeProtocol: Sendable {
    var backgroundColor: Color { get }
    var cornerRadius: CGFloat { get }
    var shadowColor: Color { get }
    var shadowRadius: CGFloat { get }
    var shadowOffset: CGPoint { get }
    var padding: CGFloat { get }
}

public struct DesignCardTheme: CardThemeProtocol, Sendable {
    public var backgroundColor: Color
    public var cornerRadius: CGFloat
    public var shadowColor: Color
    public var shadowRadius: CGFloat
    public var shadowOffset: CGPoint
    public var padding: CGFloat
    
    public init(
        backgroundColor: Color = .white,
        cornerRadius: CGFloat = 12,
        shadowColor: Color = Color.black.opacity(0.1),
        shadowRadius: CGFloat = 8,
        shadowOffset: CGPoint = CGPoint(x: 0, y: 4),
        padding: CGFloat = 16
    ) {
        self.backgroundColor = backgroundColor
        self.cornerRadius = cornerRadius
        self.shadowColor = shadowColor
        self.shadowRadius = shadowRadius
        self.shadowOffset = shadowOffset
        self.padding = padding
    }
}

public extension CardThemeProtocol where Self == DesignCardTheme {
    static var `default`: DesignCardTheme {
        DesignCardTheme()
    }
}
