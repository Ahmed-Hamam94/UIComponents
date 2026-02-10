//
//  BottomSheetTheme.swift
//  UIComponents
//
//  Created by Ahmed Hamam on 28/01/2026.
//

import SwiftUI

/// A protocol defining the visual properties of a bottom sheet.
public protocol UIBottomSheetThemeProtocol: Sendable {
    var backgroundColor: Color { get }
    var cornerRadius: CGFloat { get }
    var handleColor: Color { get }
    var overlayColor: Color { get }
    var padding: CGFloat { get }
}

/// A standard implementation of `UIBottomSheetThemeProtocol`.
public struct UIBottomSheetTheme: UIBottomSheetThemeProtocol, Sendable {
    public var backgroundColor: Color
    public var cornerRadius: CGFloat
    public var handleColor: Color
    public var overlayColor: Color
    public var padding: CGFloat
    
    public init(
        backgroundColor: Color = .white,
        cornerRadius: CGFloat = 24,
        handleColor: Color = .gray.opacity(0.4),
        overlayColor: Color = Color.black.opacity(0.4),
        padding: CGFloat = 20
    ) {
        self.backgroundColor = backgroundColor
        self.cornerRadius = cornerRadius
        self.handleColor = handleColor
        self.overlayColor = overlayColor
        self.padding = padding
    }
}

public extension UIBottomSheetThemeProtocol where Self == UIBottomSheetTheme {
    static var `default`: UIBottomSheetTheme {
        UIBottomSheetTheme()
    }
}
