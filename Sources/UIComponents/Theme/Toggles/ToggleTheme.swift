//
//  ToggleTheme.swift
//  UIComponents
//
//  Created by Ahmed Hamam on 28/01/2026.
//

import SwiftUI

/// A protocol defining the visual properties of a custom toggle switch.
public protocol UIToggleThemeProtocol: Sendable {
    /// The color of the track when the toggle is on.
    var onColor: Color { get }
    /// The color of the track when the toggle is off.
    var offColor: Color { get }
    /// The color of the sliding thumb.
    var thumbColor: Color { get }
    /// The font used for the toggle's label.
    var font: Font { get }
    /// The color of the label text.
    var textColor: Color { get }
    /// The horizontal width of the toggle track.
    var trackWidth: CGFloat { get }
    /// The vertical height of the toggle track.
    var trackHeight: CGFloat { get }
}

/// A standard implementation of `UIToggleThemeProtocol`.
public struct UIToggleTheme: UIToggleThemeProtocol, Sendable {
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

public extension UIToggleThemeProtocol where Self == UIToggleTheme {
    static var `default`: UIToggleTheme {
        UIToggleTheme()
    }
}
