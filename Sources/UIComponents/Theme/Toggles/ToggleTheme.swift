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
}

public struct DesignToggleTheme: ToggleThemeProtocol, Sendable {
    public var onColor: Color
    public var offColor: Color
    public var thumbColor: Color
    public var font: Font
    public var textColor: Color
    
    public init(
        onColor: Color = .blue,
        offColor: Color = .gray.opacity(0.3),
        thumbColor: Color = .white,
        font: Font = .body,
        textColor: Color = .primary
    ) {
        self.onColor = onColor
        self.offColor = offColor
        self.thumbColor = thumbColor
        self.font = font
        self.textColor = textColor
    }
}

public extension ToggleThemeProtocol where Self == DesignToggleTheme {
    static var `default`: DesignToggleTheme {
        DesignToggleTheme()
    }
}
