//
//  PrimaryTheme.swift
//  UIComponents
//
//  Created by Ahmed Hamam on 16/10/2025.
//

import Foundation
import SwiftUI

public struct PrimaryTheme: ButtonThemeProtocol {
    public var backgroundColor: Color = .blue
    public var disabledBackgroundColor: Color = .blue.opacity(0.5)
    public var foregroundColor: Color = .white
    public var cornerRadius: CGFloat = 6.0
    public var height: CGFloat = 48
    public var font: Font = .title2
    
    public init() {}
}
