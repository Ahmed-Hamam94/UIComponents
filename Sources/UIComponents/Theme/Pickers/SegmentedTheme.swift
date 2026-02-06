//
//  SegmentedTheme.swift
//  UIComponents
//
//  Created by Ahmed Hamam on 28/01/2026.
//

import SwiftUI

public protocol SegmentedThemeProtocol: Sendable {
    var backgroundColor: Color { get }
    var selectedColor: Color { get }
    var textColor: Color { get }
    var selectedTextColor: Color { get }
    var font: Font { get }
    var cornerRadius: CGFloat { get }
    var height: CGFloat { get }
    var selectedCapsulPadding: CGFloat { get }
}

public struct DesignSegmentedTheme: SegmentedThemeProtocol, Sendable {
    public var backgroundColor: Color
    public var selectedColor: Color
    public var textColor: Color
    public var selectedTextColor: Color
    public var font: Font
    public var cornerRadius: CGFloat
    public var height: CGFloat
    public var selectedCapsulPadding: CGFloat
    
    public init(
        backgroundColor: Color = .gray.opacity(0.15),
        selectedColor: Color = .white,
        textColor: Color = .secondary,
        selectedTextColor: Color = .primary,
        font: Font = .subheadline.weight(.medium),
        cornerRadius: CGFloat = 8,
        height: CGFloat = 40,
        selectedCapsulPadding: CGFloat = 6
    ) {
        self.backgroundColor = backgroundColor
        self.selectedColor = selectedColor
        self.textColor = textColor
        self.selectedTextColor = selectedTextColor
        self.font = font
        self.cornerRadius = cornerRadius
        self.height = height
        self.selectedCapsulPadding = selectedCapsulPadding
    }
}

public extension SegmentedThemeProtocol where Self == DesignSegmentedTheme {
    static var `default`: DesignSegmentedTheme {
        DesignSegmentedTheme()
    }
}
