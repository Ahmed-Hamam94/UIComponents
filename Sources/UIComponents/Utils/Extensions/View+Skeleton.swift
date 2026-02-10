//
//  View+Skeleton.swift
//  UIComponents
//
//  Created by Ahmed Hamam on 10/02/2026.
//

import SwiftUI

public extension View {
    /// Applies a skeleton loading effect to the view.
    ///
    /// When `isLoading` is true, the view is replaced with an animated skeleton placeholder
    /// that matches the shape and layout of the original content.
    ///
    /// ```swift
    /// Text("Hello World")
    ///     .skeleton(isLoading: isLoadingData)
    /// ```
    ///
    /// - Parameters:
    ///   - isLoading: Whether to show the skeleton or the actual content
    ///   - shape: The shape of the skeleton (rectangle or circle)
    ///   - theme: The visual theme for the skeleton
    /// - Returns: A view that shows skeleton or content based on loading state
    func skeleton(
        isLoading: Bool,
        shape: SkeletonShape = .rectangle(),
        theme: UISkeletonTheme = .default
    ) -> some View {
        self.modifier(SkeletonModifier(isLoading: isLoading, shape: shape, theme: theme))
    }
}

// MARK: - Skeleton Modifier
private struct SkeletonModifier: ViewModifier {
    let isLoading: Bool
    let shape: SkeletonShape
    let theme: UISkeletonTheme
    
    func body(content: Content) -> some View {
        ZStack {
            if isLoading {
                content
                    .hidden()
                    .overlay(
                        UI.Skeleton(shape: shape, theme: theme)
                    )
            } else {
                content
            }
        }
    }
}
