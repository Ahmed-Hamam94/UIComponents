//
//  DesignToast.swift
//  UIComponents
//
//  Created by Ahmed Hamam on 28/01/2026.
//

import SwiftUI

public enum ToastPosition {
    case top, bottom
}

public struct DesignToast: View {
    private let message: String
    private let icon: String?
    private let theme: ToastThemeProtocol
    
    public init(
        message: String,
        icon: String? = nil,
        theme: ToastThemeProtocol = DesignToastTheme()
    ) {
        self.message = message
        self.icon = icon
        self.theme = theme
    }
    
    public var body: some View {
        HStack(spacing: 12) {
            if let icon = icon {
                Image(systemName: icon)
                    .foregroundColor(theme.iconColor)
            }
            
            Text(message)
                .font(theme.font)
                .foregroundColor(theme.textColor)
            
            Spacer(minLength: 0)
        }
        .padding(theme.padding)
        .background(theme.backgroundColor)
        .cornerRadius(theme.cornerRadius)
        .shadow(color: theme.shadowColor, radius: 10, x: 0, y: 5)
        .padding(.horizontal, 20)
    }
}

public extension View {
    func designToast(
        isPresented: Binding<Bool>,
        message: String,
        icon: String? = nil,
        position: ToastPosition = .bottom,
        duration: Double = 3.0,
        theme: ToastThemeProtocol = DesignToastTheme()
    ) -> some View {
        ZStack(alignment: position == .top ? .top : .bottom) {
            self
            
            if isPresented.wrappedValue {
                DesignToast(message: message, icon: icon, theme: theme)
                    .transition(.move(edge: position == .top ? .top : .bottom).combined(with: .opacity))
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                            withAnimation {
                                isPresented.wrappedValue = false
                            }
                        }
                    }
                    .zIndex(100)
            }
        }
        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: isPresented.wrappedValue)
    }
}

struct DesignToast_Previews: PreviewProvider {
    @State static var isPresented = true
    
    static var previews: some View {
        Color.gray
            .designToast(
                isPresented: $isPresented,
                message: "This is a toast message!",
                icon: "checkmark.circle.fill",
                position: .top
            )
    }
}
