//
//  BottomSheetThemeProtocol.swift
//  UIComponents
//
//  Created by Ahmed Hamam on 28/01/2026.

import SwiftUI

public protocol BottomSheetThemeProtocol {
    var backgroundColor: Color { get }
    var cornerRadius: CGFloat { get }
    var handleColor: Color { get }
    var overlayColor: Color { get }
    var padding: CGFloat { get }
}

public struct DesignBottomSheetTheme: BottomSheetThemeProtocol {
    public var backgroundColor: Color
    public var cornerRadius: CGFloat
    public var handleColor: Color
    public var overlayColor: Color
    public var padding: CGFloat
    
    public init(
        backgroundColor: Color = Color(.systemBackground),
        cornerRadius: CGFloat = 24,
        handleColor: Color = Color(.systemGray4),
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
