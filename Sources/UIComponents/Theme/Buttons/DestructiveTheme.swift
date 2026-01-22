//
//  DestructiveTheme.swift.swift
//  UIComponents
//
//  Created by Ahmed Hamam on 16/10/2025.
//

import SwiftUI

public struct DestructiveTheme: ButtonThemeProtocol {
    public var backgroundColor: Color = .red
    public var disabledBackgroundColor: Color = .red.opacity(0.5)
    public var foregroundColor: Color = .white
    public var cornerRadius: CGFloat = 6.0
    public var height: CGFloat = 48
    public var font: Font = .body
    
    public init() {}
}
