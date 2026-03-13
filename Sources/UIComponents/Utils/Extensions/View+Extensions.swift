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
    ///
    /// - Warning: Using this modifier with changing conditions can break SwiftUI view identity
    ///   and animations. When the condition changes, SwiftUI treats the result as a completely
    ///   different view, causing:
    ///   - Loss of view state (@State properties reset)
    ///   - Broken animations and transitions
    ///   - Unexpected re-initialization of child views
    ///
    ///   **Prefer these alternatives when the condition changes at runtime:**
    ///   - `.opacity(condition ? 1 : 0)` for visibility toggling
    ///   - `.disabled(!condition)` for interaction toggling
    ///   - `.overlay()` for conditional decorations
    ///   - Direct conditional modifiers: `.foregroundStyle(condition ? .red : .blue)`
    ///
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
    ///
    /// - Warning: Using this modifier with changing conditions can break SwiftUI view identity
    ///   and animations. See the single-transform variant's documentation for details and
    ///   recommended alternatives.
    ///
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

