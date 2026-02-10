//
//  SkeletonTheme.swift
//  UIComponents
//
//  Created by Ahmed Hamam on 28/01/2026.
//

import SwiftUI

/// A protocol defining the visual properties and animation of a skeleton loading view.
public protocol UISkeletonThemeProtocol: Sendable {
    var baseColor: Color { get }
    var highlightColor: Color { get }
    var animationDuration: Double { get }
}

/// A standard implementation of `UISkeletonThemeProtocol`.
public struct UISkeletonTheme: UISkeletonThemeProtocol, Sendable {
    public var baseColor: Color
    public var highlightColor: Color
    public var animationDuration: Double
    
    public init(
        baseColor: Color = .gray.opacity(0.25),
        highlightColor: Color = .white.opacity(0.6),
        animationDuration: Double = 1.2
    ) {
        self.baseColor = baseColor
        self.highlightColor = highlightColor
        self.animationDuration = animationDuration
    }
}

public extension UISkeletonThemeProtocol where Self == UISkeletonTheme {
    static var `default`: UISkeletonTheme {
        UISkeletonTheme()
    }
}
