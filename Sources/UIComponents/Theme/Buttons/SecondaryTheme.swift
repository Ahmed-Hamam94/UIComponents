//
//  SecondaryTheme.swift
//  UIComponents
//
//  Created by Ahmed Hamam on 16/10/2025.
//

import Foundation
import SwiftUI

public struct SecondaryTheme: ButtonThemeProtocol {
    public var backgroundColor: Color = .init(white: 0.9)
    public var disabledBackgroundColor: Color = .init(white: 0.9).opacity(0.5)
    public var foregroundColor: Color = .black
    public var cornerRadius: CGFloat = 6.0
    public var height: CGFloat = 48
    public var font: Font = .body
    
    public init() {}
}
