//
//  ButtonTheme.swift
//  UIComponents
//
//  Created by Ahmed Hamam on 16/10/2025.
//

import SwiftUI

public protocol ButtonThemeProtocol {
    var backgroundColor: Color { get }
    var disabledBackgroundColor: Color { get }
    var foregroundColor: Color { get }
    var cornerRadius: CGFloat { get }
    var height: CGFloat { get }
    var font: Font { get }
}

public struct ButtonTheme: ButtonThemeProtocol {
    public var backgroundColor: Color
    public var disabledBackgroundColor: Color
    public var foregroundColor: Color
    public var cornerRadius: CGFloat
    public var height: CGFloat
    public var font: Font
    
    public init(backgroundColor: Color = .blue, disabledBackgroundColor: Color? = nil, foregroundColor: Color = .white, cornerRadius: CGFloat = 6.0, height: CGFloat = 48, font: Font = .body) {
        self.backgroundColor = backgroundColor
        self.disabledBackgroundColor = disabledBackgroundColor ?? backgroundColor.opacity(0.5)
        self.foregroundColor = foregroundColor
        self.cornerRadius = cornerRadius
        self.height = height
        self.font = font
    }
}
