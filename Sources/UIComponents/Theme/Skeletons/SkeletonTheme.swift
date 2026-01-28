//
//  SkeletonThemeProtocol.swift
//  UIComponents
//
//  Created by Ahmed Hamam on 28/01/2026.

import SwiftUI

public protocol SkeletonThemeProtocol {
    var baseColor: Color { get }
    var highlightColor: Color { get }
    var animationDuration: Double { get }
}

public struct DesignSkeletonTheme: SkeletonThemeProtocol {
    public var baseColor: Color
    public var highlightColor: Color
    public var animationDuration: Double
    
    public init(
        baseColor: Color = Color(.systemGray5),
        highlightColor: Color = Color(.systemGray4),
        animationDuration: Double = 1.5
    ) {
        self.baseColor = baseColor
        self.highlightColor = highlightColor
        self.animationDuration = animationDuration
    }
}
