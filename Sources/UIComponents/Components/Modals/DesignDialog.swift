//
//  DesignDialog.swift
//  UIComponents
//
//  Created by Ahmed Hamam on 28/01/2026.
//

import SwiftUI

public struct DesignDialog: View {
    @Binding var isPresented: Bool
    private let title: String
    private let message: String
    private let primaryButton: String
    private let secondaryButton: String?
    private let primaryAction: () -> Void
    private let secondaryAction: (() -> Void)?
    private let theme: DialogThemeProtocol
    
    public init(
        isPresented: Binding<Bool>,
        title: String,
        message: String,
        primaryButton: String,
        secondaryButton: String? = nil,
        primaryAction: @escaping () -> Void,
        secondaryAction: (() -> Void)? = nil,
        theme: DialogThemeProtocol = DesignDialogTheme()
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
                VStack(spacing: 0) {
                    VStack(spacing: 8) {
                        Text(title)
                            .font(theme.titleFont)
                            .foregroundColor(theme.titleColor)
                            .multilineTextAlignment(.center)
                        
                        Text(message)
                            .font(theme.messageFont)
                            .foregroundColor(theme.messageColor)
                            .multilineTextAlignment(.center)
                    }
                    .padding(24)
                    
                    Divider()
                    
                    HStack(spacing: 0) {
                        if let secondaryButton = secondaryButton {
                            Button(action: {
                                secondaryAction?()
                                isPresented = false
                            }) {
                                Text(secondaryButton)
                                    .font(theme.buttonFont)
                                    .frame(maxWidth: .infinity, minHeight: 48)
                            }
                            
                            Divider()
                                .frame(height: 48)
                        }
                        
                        Button(action: {
                            primaryAction()
                            isPresented = false
                        }) {
                            Text(primaryButton)
                                .font(theme.buttonFont)
                                .frame(maxWidth: .infinity, minHeight: 48)
                        }
                    }
                }
                .background(theme.backgroundColor)
                .cornerRadius(theme.cornerRadius)
                .frame(maxWidth: theme.maxWidth)
                .padding(40)
                .transition(.scale(scale: 0.9).combined(with: .opacity))
            }
            .animation(.spring(response: 0.3, dampingFraction: 0.8), value: isPresented)
            .zIndex(100)
        }
    }
}

// Extension to use as a modifier
public extension View {
    func designDialog(
        isPresented: Binding<Bool>,
        title: String,
        message: String,
        primaryButton: String,
        secondaryButton: String? = nil,
        primaryAction: @escaping () -> Void,
        secondaryAction: (() -> Void)? = nil,
        theme: DialogThemeProtocol = DesignDialogTheme()
    ) -> some View {
        ZStack {
            self
            DesignDialog(
                isPresented: isPresented,
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

struct DesignDialog_Previews: PreviewProvider {
    @State static var isPresented = true
    
    static var previews: some View {
        Color.gray
            .designDialog(
                isPresented: $isPresented,
                title: "Confirm Action",
                message: "Are you sure you want to proceed with this operation? This cannot be undone.",
                primaryButton: "Confirm",
                secondaryButton: "Cancel",
                primaryAction: { print("Confirmed") }
            )
    }
}
