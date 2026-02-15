//
//  UIDialog.swift
//  UIComponents
//
//  Created by Ahmed Hamam on 28/01/2026.
//

import SwiftUI

extension UI {
    /// A modal component for critical user interruptions and confirmations.
    ///
    /// It is recommended to use the `.uiDialog(...)` view modifier instead of instantiating this struct directly.
    /// The dialog includes a title, message, and up to two action buttons.
    /// It supports custom themes via `UIDialogThemeProtocol`.
    public struct Dialog<T: UIDialogThemeProtocol>: View {
        /// A binding to the presentation state of the dialog.
        @Binding private var isPresented: Bool
        /// The title text shown at the top of the dialog.
        private let title: String
        /// The body message text.
        private let message: String
        /// The label for the primary action button.
        private let primaryButton: String
        /// The optional label for the secondary action button.
        private let secondaryButton: String?
        /// The closure called when the primary button is tapped.
        private let primaryAction: () -> Void
        /// The optional closure called when the secondary button is tapped.
        private let secondaryAction: (() -> Void)?
        /// The visual style and behavior settings of the dialog.
        private let theme: T
        /// Optional accessibility overrides for the dialog container. Nil = use defaults.
        private let accessibility: UIAccessibility?
        private let width: CGFloat?
        private let height: CGFloat?

        public init(
            isPresented: Binding<Bool>,
            title: String,
            message: String,
            primaryButton: String,
            secondaryButton: String? = nil,
            primaryAction: @escaping () -> Void,
            secondaryAction: (() -> Void)? = nil,
            theme: T,
            accessibility: UIAccessibility? = nil,
            width: CGFloat? = nil,
            height: CGFloat? = nil
        ) {
            self._isPresented = isPresented
            self.title = title
            self.message = message
            self.primaryButton = primaryButton
            self.secondaryButton = secondaryButton
            self.primaryAction = primaryAction
            self.secondaryAction = secondaryAction
            self.theme = theme
            self.accessibility = accessibility
            self.width = width
            self.height = height
        }

        public var body: some View {
            if isPresented {
                ZStack {
                    // Background Overlay
                    SwiftUI.Button {
                        isPresented = false
                    } label: {
                        theme.overlayColor
                            .ignoresSafeArea()
                    }
                    .buttonStyle(.plain)
                    .uiAccessibility(nil, defaultLabel: "Dismiss dialog", defaultHint: "Double tap to close")

                    // Dialog Box
                    DialogContent(
                        title: title,
                        message: message,
                        primaryButton: primaryButton,
                        secondaryButton: secondaryButton,
                        theme: theme,
                        onPrimary: {
                            primaryAction()
                            isPresented = false
                        },
                        onSecondary: {
                            secondaryAction?()
                            isPresented = false
                        },
                        width: width,
                        height: height
                    )
                    .if(width == nil) { $0.frame(maxWidth: theme.maxWidth) }
                    .padding(40)
                    .transition(.scale(scale: 0.9).combined(with: .opacity))
                }
                .animation(.spring(response: 0.3, dampingFraction: 0.8), value: isPresented)
                .zIndex(100)
                .accessibilityElement(children: .contain)
                .uiAccessibility(accessibility, defaultLabel: "Dialog: \(title)", defaultTraits: .isModal)
            }
        }
    }
}

extension UI.Dialog where T == UIDialogTheme {
    public init(
        isPresented: Binding<Bool>,
        title: String,
        message: String,
        primaryButton: String,
        secondaryButton: String? = nil,
        primaryAction: @escaping () -> Void,
        secondaryAction: (() -> Void)? = nil,
        theme: UIDialogTheme = .default,
        accessibility: UIAccessibility? = nil,
        width: CGFloat? = nil,
        height: CGFloat? = nil
    ) {
        self._isPresented = isPresented
        self.title = title
        self.message = message
        self.primaryButton = primaryButton
        self.secondaryButton = secondaryButton
        self.primaryAction = primaryAction
        self.secondaryAction = secondaryAction
        self.theme = theme
        self.accessibility = accessibility
        self.width = width
        self.height = height
    }
}

// MARK: - Dialog Content View
private struct DialogContent<T: UIDialogThemeProtocol>: View {
    let title: String
    let message: String
    let primaryButton: String
    let secondaryButton: String?
    let theme: T
    let onPrimary: () -> Void
    let onSecondary: () -> Void
    let width: CGFloat?
    let height: CGFloat?
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 8) {
                Text(title)
                    .font(theme.titleFont)
                    .foregroundStyle(theme.titleColor)
                    .multilineTextAlignment(.center)
                
                Text(message)
                    .font(theme.messageFont)
                    .foregroundStyle(theme.messageColor)
                    .multilineTextAlignment(.center)
            }
            .padding(24)
            .frame(maxHeight: height != nil ? .infinity : nil)
            
            Divider()
            
            HStack(spacing: 0) {
                if let secondaryButton {
                    SwiftUI.Button(action: onSecondary) {
                        Text(secondaryButton)
                            .font(theme.buttonFont)
                            .frame(maxWidth: .infinity, minHeight: 48)
                    }
                    
                    Divider()
                        .frame(height: 48)
                }
                
                SwiftUI.Button(action: onPrimary) {
                    Text(primaryButton)
                        .font(theme.buttonFont)
                        .frame(maxWidth: .infinity, minHeight: 48)
                }
            }
        }
        .frame(width: width, height: height)
        .background(theme.backgroundColor)
        .clipShape(.rect(cornerRadius: theme.cornerRadius))
    }
}

// MARK: - Dialog View Modifier
private struct DialogModifier<T: UIDialogThemeProtocol>: ViewModifier {
    @Binding var isPresented: Bool
    let title: String
    let message: String
    let primaryButton: String
    let secondaryButton: String?
    let primaryAction: () -> Void
    let secondaryAction: (() -> Void)?
    let theme: T
    let width: CGFloat?
    let height: CGFloat?
    
    func body(content: Content) -> some View {
        ZStack {
            content
            UI.Dialog(
                isPresented: $isPresented,
                title: title,
                message: message,
                primaryButton: primaryButton,
                secondaryButton: secondaryButton,
                primaryAction: primaryAction,
                secondaryAction: secondaryAction,
                theme: theme,
                width: width,
                height: height
            )
        }
    }
}

public extension View {
    func uiDialog(
        isPresented: Binding<Bool>,
        title: String,
        message: String,
        primaryButton: String,
        secondaryButton: String? = nil,
        primaryAction: @escaping () -> Void,
        secondaryAction: (() -> Void)? = nil,
        theme: UIDialogTheme = .default,
        width: CGFloat? = nil,
        height: CGFloat? = nil
    ) -> some View {
        modifier(DialogModifier(
            isPresented: isPresented,
            title: title,
            message: message,
            primaryButton: primaryButton,
            secondaryButton: secondaryButton,
            primaryAction: primaryAction,
            secondaryAction: secondaryAction,
            theme: theme,
            width: width,
            height: height
        ))
    }
    
    func uiDialog<T: UIDialogThemeProtocol>(
        isPresented: Binding<Bool>,
        title: String,
        message: String,
        primaryButton: String,
        secondaryButton: String? = nil,
        primaryAction: @escaping () -> Void,
        secondaryAction: (() -> Void)? = nil,
        theme: T,
        width: CGFloat? = nil,
        height: CGFloat? = nil
    ) -> some View {
        modifier(DialogModifier(
            isPresented: isPresented,
            title: title,
            message: message,
            primaryButton: primaryButton,
            secondaryButton: secondaryButton,
            primaryAction: primaryAction,
            secondaryAction: secondaryAction,
            theme: theme,
            width: width,
            height: height
        ))
    }
}

#Preview("Confirmation Dialog") {
    Color.gray.opacity(0.2)
        .uiDialog(
            isPresented: .constant(true),
            title: "Confirm Action",
            message: "Are you sure you want to proceed with this operation? This cannot be undone.",
            primaryButton: "Confirm",
            secondaryButton: "Cancel",
            primaryAction: {},
            theme: .default,
            width: 380,
         //   height: 300
        )
}
