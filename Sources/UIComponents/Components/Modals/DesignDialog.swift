//
//  DesignDialog.swift
//  UIComponents
//
//  Created by Ahmed Hamam on 28/01/2026.
//

import SwiftUI

public struct DesignDialog<T: DialogThemeProtocol>: View {
    @Binding var isPresented: Bool
    private let title: String
    private let message: String
    private let primaryButton: String
    private let secondaryButton: String?
    private let primaryAction: () -> Void
    private let secondaryAction: (() -> Void)?
    private let theme: T
    
    public init(
        isPresented: Binding<Bool>,
        title: String,
        message: String,
        primaryButton: String,
        secondaryButton: String? = nil,
        primaryAction: @escaping () -> Void,
        secondaryAction: (() -> Void)? = nil,
        theme: T
    ) {
        self._isPresented = isPresented
        self.title = title
        self.message = message
        self.primaryButton = primaryButton
        self.secondaryButton = secondaryButton
        self.primaryAction = primaryAction
        self.secondaryAction = secondaryAction
        self.theme = theme
    }
    
    public var body: some View {
        if isPresented {
            ZStack {
                // Background Overlay
                theme.overlayColor
                    .ignoresSafeArea()
                    .onTapGesture {
                        isPresented = false
                    }
                
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
                    }
                )
                .frame(maxWidth: theme.maxWidth)
                .padding(40)
                .transition(.scale(scale: 0.9).combined(with: .opacity))
            }
            .animation(.spring(response: 0.3, dampingFraction: 0.8), value: isPresented)
            .zIndex(100)
            .accessibilityElement(children: .contain)
            .accessibilityAddTraits(.isModal)
            .accessibilityLabel("Dialog: \(title)")
        }
    }
}

extension DesignDialog where T == DesignDialogTheme {
    public init(
        isPresented: Binding<Bool>,
        title: String,
        message: String,
        primaryButton: String,
        secondaryButton: String? = nil,
        primaryAction: @escaping () -> Void,
        secondaryAction: (() -> Void)? = nil,
        theme: DesignDialogTheme = .default
    ) {
        self._isPresented = isPresented
        self.title = title
        self.message = message
        self.primaryButton = primaryButton
        self.secondaryButton = secondaryButton
        self.primaryAction = primaryAction
        self.secondaryAction = secondaryAction
        self.theme = theme
    }
}

// MARK: - Dialog Content View
private struct DialogContent<T: DialogThemeProtocol>: View {
    let title: String
    let message: String
    let primaryButton: String
    let secondaryButton: String?
    let theme: T
    let onPrimary: () -> Void
    let onSecondary: () -> Void
    
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
        .background(theme.backgroundColor)
        .clipShape(.rect(cornerRadius: theme.cornerRadius))
    }
}

// MARK: - Dialog View Modifier
private struct DialogModifier<T: DialogThemeProtocol>: ViewModifier {
    @Binding var isPresented: Bool
    let title: String
    let message: String
    let primaryButton: String
    let secondaryButton: String?
    let primaryAction: () -> Void
    let secondaryAction: (() -> Void)?
    let theme: T
    
    func body(content: Content) -> some View {
        ZStack {
            content
            DesignDialog(
                isPresented: $isPresented,
                title: title,
                message: message,
                primaryButton: primaryButton,
                secondaryButton: secondaryButton,
                primaryAction: primaryAction,
                secondaryAction: secondaryAction,
                theme: theme
            )
        }
    }
}

public extension View {
    func designDialog(
        isPresented: Binding<Bool>,
        title: String,
        message: String,
        primaryButton: String,
        secondaryButton: String? = nil,
        primaryAction: @escaping () -> Void,
        secondaryAction: (() -> Void)? = nil,
        theme: DesignDialogTheme = .default
    ) -> some View {
        modifier(DialogModifier(
            isPresented: isPresented,
            title: title,
            message: message,
            primaryButton: primaryButton,
            secondaryButton: secondaryButton,
            primaryAction: primaryAction,
            secondaryAction: secondaryAction,
            theme: theme
        ))
    }
    
    func designDialog<T: DialogThemeProtocol>(
        isPresented: Binding<Bool>,
        title: String,
        message: String,
        primaryButton: String,
        secondaryButton: String? = nil,
        primaryAction: @escaping () -> Void,
        secondaryAction: (() -> Void)? = nil,
        theme: T
    ) -> some View {
        modifier(DialogModifier(
            isPresented: isPresented,
            title: title,
            message: message,
            primaryButton: primaryButton,
            secondaryButton: secondaryButton,
            primaryAction: primaryAction,
            secondaryAction: secondaryAction,
            theme: theme
        ))
    }
}

#Preview("Confirmation Dialog") {
    Color.gray.opacity(0.2)
        .designDialog(
            isPresented: .constant(true),
            title: "Confirm Action",
            message: "Are you sure you want to proceed with this operation? This cannot be undone.",
            primaryButton: "Confirm",
            secondaryButton: "Cancel",
            primaryAction: {},
            theme: .default
        )
}
