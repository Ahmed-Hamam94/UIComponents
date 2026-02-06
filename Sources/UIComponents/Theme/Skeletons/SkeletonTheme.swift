//
//  SkeletonTheme.swift
//  UIComponents
//
//  Created by Ahmed Hamam on 28/01/2026.
//

import SwiftUI

public protocol SkeletonThemeProtocol: Sendable {
    var baseColor: Color { get }
    var highlightColor: Color { get }
    var animationDuration: Double { get }
}

public struct DesignSkeletonTheme: SkeletonThemeProtocol, Sendable {
    public var baseColor: Color
    public var highlightColor: Color
    public var animationDuration: Double
    
    public init(
        baseColor: Color = .gray.opacity(0.2),
        highlightColor: Color = .gray.opacity(0.3),
        animationDuration: Double = 1.5
    ) {
        self.baseColor = baseColor
        self.highlightColor = highlightColor
        self.animationDuration = animationDuration
    }
}

public extension SkeletonThemeProtocol where Self == DesignSkeletonTheme {
    static var `default`: DesignSkeletonTheme {
        DesignSkeletonTheme()
    }
}
