//
//  ToggleTheme.swift
//  UIComponents
//
//  Created by Ahmed Hamam on 28/01/2026.
//

import SwiftUI

public protocol ToggleThemeProtocol: Sendable {
    var onColor: Color { get }
    var offColor: Color { get }
    var thumbColor: Color { get }
    var font: Font { get }
    var textColor: Color { get }
    /// Track width; use for accessibility or custom sizing.
    var trackWidth: CGFloat { get }
    /// Track height; use for accessibility or custom sizing.
    var trackHeight: CGFloat { get }
}

public struct DesignToggleTheme: ToggleThemeProtocol, Sendable {
    public var onColor: Color
    public var offColor: Color
    public var thumbColor: Color
    public var font: Font
    public var textColor: Color
    public var trackWidth: CGFloat
    public var trackHeight: CGFloat
    
    public init(
        onColor: Color = .blue,
        offColor: Color = .gray.opacity(0.3),
        thumbColor: Color = .white,
        font: Font = .body,
        textColor: Color = .primary,
        trackWidth: CGFloat = 50,
        trackHeight: CGFloat = 30
    ) {
        self.onColor = onColor
        self.offColor = offColor
        self.thumbColor = thumbColor
        self.font = font
        self.textColor = textColor
        self.trackWidth = trackWidth
        self.trackHeight = trackHeight
    }
}

public extension ToggleThemeProtocol where Self == DesignToggleTheme {
    static var `default`: DesignToggleTheme {
        DesignToggleTheme()
    }
}
