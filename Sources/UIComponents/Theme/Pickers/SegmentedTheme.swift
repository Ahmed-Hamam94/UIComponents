//
//  SegmentedTheme.swift
//  UIComponents
//
//  Created by Ahmed Hamam on 28/01/2026.
//

import SwiftUI

/// A protocol defining the visual properties of a segmented control.
public protocol UISegmentedThemeProtocol: Sendable {
    var backgroundColor: Color { get }
    var selectedColor: Color { get }
    var textColor: Color { get }
    var selectedTextColor: Color { get }
    var font: Font { get }
    var cornerRadius: CGFloat { get }
    var height: CGFloat { get }
    var selectedCapsulePadding: CGFloat { get }
    var borderColor: Color { get }
}

/// A standard implementation of `UISegmentedThemeProtocol`.
public struct UISegmentedTheme: UISegmentedThemeProtocol, Sendable {
    public var backgroundColor: Color
    public var selectedColor: Color
    public var textColor: Color
    public var selectedTextColor: Color
    public var font: Font
    public var cornerRadius: CGFloat
    public var height: CGFloat
    public var selectedCapsulePadding: CGFloat
    public var borderColor: Color
    
    public init(
        backgroundColor: Color = .gray.opacity(0.15),
        selectedColor: Color = .white,
        textColor: Color = .secondary,
        selectedTextColor: Color = .primary,
        font: Font = .subheadline.weight(.medium),
        cornerRadius: CGFloat = 8,
        height: CGFloat = 40,
        selectedCapsulePadding: CGFloat = 6,
        borderColor: Color = .clear
    ) {
        self.backgroundColor = backgroundColor
        self.selectedColor = selectedColor
        self.textColor = textColor
        self.selectedTextColor = selectedTextColor
        self.font = font
        self.cornerRadius = cornerRadius
        self.height = height
        self.selectedCapsulePadding = selectedCapsulePadding
        self.borderColor = borderColor
    }
}

public extension UISegmentedThemeProtocol where Self == UISegmentedTheme {
    static var `default`: UISegmentedTheme {
        UISegmentedTheme()
    }
}
