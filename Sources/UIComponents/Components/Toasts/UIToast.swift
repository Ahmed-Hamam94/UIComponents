//
//  UIToast.swift
//  UIComponents
//
//  Created by Ahmed Hamam on 28/01/2026.
//

import SwiftUI

/// Determines where on the screen a toast notification is displayed.
public enum ToastPosition: Sendable {
    /// The toast appears at the top of the screen.
    case top
    /// The toast appears at the bottom of the screen.
    case bottom
}

extension UI {
    /// A non-intrusive notification banner for status updates.
    ///
    /// It is recommended to use the `.uiToast(...)` view modifier instead of instantiating this struct directly.
    /// Toasts support icons, custom themes (success, error, etc.), and top/bottom positioning.
    public struct Toast<T: UIToastThemeProtocol>: View {
        /// The notification message text.
        private let message: String
        /// Optional SF Symbol name to display as an icon.
        private let icon: String?
        /// The visual style of the toast.
        private let theme: T
        
        public init(
            message: String,
            icon: String? = nil,
            theme: T
        ) {
            self.message = message
            self.icon = icon
            self.theme = theme
        }
        
        public var body: some View {
            let displayedIcon = icon ?? theme.defaultIcon
            
            HStack(spacing: 12) {
                if let displayedIcon {
                    Image(systemName: displayedIcon)
                        .foregroundStyle(theme.iconColor)
                }
                
                Text(message)
                    .font(theme.font)
                    .foregroundStyle(theme.textColor)
                
                Spacer(minLength: 0)
            }
            .padding(theme.padding)
            .background(theme.backgroundColor)
            .clipShape(.rect(cornerRadius: theme.cornerRadius))
            .shadow(color: theme.shadowColor, radius: 10, x: 0, y: 5)
            .padding(.horizontal, 20)
            .accessibilityElement(children: .combine)
            .accessibilityLabel("Notification: \(message)")
            .accessibilityAddTraits(.isStaticText)
        }
    }
}

extension UI.Toast where T == UIToastTheme {
    public init(
        message: String,
        icon: String? = nil,
        theme: UIToastTheme = .default
    ) {
        self.message = message
        self.icon = icon
        self.theme = theme
    }
}

// MARK: - Toast View Modifier
private struct ToastModifier<T: UIToastThemeProtocol>: ViewModifier {
    @Binding var isPresented: Bool
    let message: String
    let icon: String?
    let position: ToastPosition
    let duration: Double
    let theme: T
    
    func body(content: Content) -> some View {
        ZStack(alignment: position == .top ? .top : .bottom) {
            content
            
            if isPresented {
                UI.Toast(message: message, icon: icon, theme: theme)
                    .transition(.move(edge: position == .top ? .top : .bottom).combined(with: .opacity))
                    .task {
                        try? await Task.sleep(for: .seconds(duration))
                        withAnimation {
                            isPresented = false
                        }
                    }
                    .zIndex(100)
            }
        }
        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: isPresented)
    }
}

public extension View {
    func uiToast(
        isPresented: Binding<Bool>,
        message: String,
        icon: String? = nil,
        position: ToastPosition = .bottom,
        duration: Double = 3.0,
        theme: UIToastTheme = .default
    ) -> some View {
        modifier(ToastModifier(
            isPresented: isPresented,
            message: message,
            icon: icon,
            position: position,
            duration: duration,
            theme: theme
        ))
    }
    
    func uiToast<T: UIToastThemeProtocol>(
        isPresented: Binding<Bool>,
        message: String,
        icon: String? = nil,
        position: ToastPosition = .bottom,
        duration: Double = 3.0,
        theme: T
    ) -> some View {
        modifier(ToastModifier(
            isPresented: isPresented,
            message: message,
            icon: icon,
            position: position,
            duration: duration,
            theme: theme
        ))
    }
}

#Preview("Toast Top") {
    VStack(spacing: 10) {
        Color.gray.opacity(0.2)
            .uiToast(
                isPresented: .constant(true),
                message: "This is a toast message!",
                icon: "checkmark.circle.fill",
                position: .top,
                theme: UIToastTheme(backgroundColor: .green.opacity(0.2), textColor: .white, font: .body, cornerRadius: 10, shadowColor: .gray, padding: 8, iconColor: .green)
            )
        
        UI.Toast(message: "Test", icon: "checkmark.circle.fill" , theme: .success)
        
        Color.gray.opacity(0.2)
            .uiToast(
                isPresented: .constant(true),
                message: "Success! Your changes have been saved.",
                icon: "checkmark.circle.fill",
                position: .bottom,
                theme: .default
            )
    }
}
