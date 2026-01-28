//
//  ToggleThemeProtocol.swift
//  UIComponents
//
//  Created by Ahmed Hamam on 28/01/2026.
//

import SwiftUI

public protocol ToggleThemeProtocol {
    var onColor: Color { get }
    var offColor: Color { get }
    var thumbColor: Color { get }
    var font: Font { get }
    var textColor: Color { get }
}

public struct DesignToggleTheme: ToggleThemeProtocol {
    public var onColor: Color
    public var offColor: Color
    public var thumbColor: Color
    public var font: Font
    public var textColor: Color
    
    public init(
        onColor: Color = .blue,
        offColor: Color = Color(.systemGray5),
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
