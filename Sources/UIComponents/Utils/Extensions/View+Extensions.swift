//
//  View+Extensions.swift
//  UIComponents
//
//  Created by Ahmed Hamam on 16/10/2025.
//

import SwiftUI

// MARK: - Visibility Extensions

extension View {
    /// Conditionally hides a view.
    /// - Parameters:
    ///   - hidden: Whether the view should be hidden.
    ///   - remove: If true, removes the view from the hierarchy entirely when hidden.
    ///             If false (default), hides the view but keeps it in the layout.
    /// - Returns: A view that is conditionally hidden.
    @ViewBuilder
    func isHidden(_ hidden: Bool, remove: Bool = false) -> some View {
        if hidden {
            if !remove {
                self.hidden()
            }
        } else {
            self
        }
    }
}

// MARK: - Conditional Modifiers

extension View {
    /// Applies a transformation if the condition is true.
    /// - Parameters:
    ///   - condition: The condition to evaluate.
    ///   - transform: The transformation to apply when condition is true.
    /// - Returns: Either the original view or the transformed view.
    @ViewBuilder
    func `if`<Content: View>(
        _ condition: Bool,
        transform: (Self) -> Content
    ) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
    
    /// Applies one of two transformations based on a condition.
    /// - Parameters:
    ///   - condition: The condition to evaluate.
    ///   - ifTrue: The transformation to apply when condition is true.
    ///   - ifFalse: The transformation to apply when condition is false.
    /// - Returns: The transformed view.
    @ViewBuilder
    func `if`<TrueContent: View, FalseContent: View>(
        _ condition: Bool,
        ifTrue: (Self) -> TrueContent,
        ifFalse: (Self) -> FalseContent
    ) -> some View {
        if condition {
            ifTrue(self)
        } else {
            ifFalse(self)
        }
    }
}

