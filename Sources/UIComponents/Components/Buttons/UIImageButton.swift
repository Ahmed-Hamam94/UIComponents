//
//  UIImageButton.swift
//  UIComponents
//
//  Created by Ahmed Hamam on 22/01/2026.
//

import SwiftUI

extension UI {
    /// A button component that displays an image alongside optional text.
    ///
    /// The image can be positioned to the leading or trailing side of the text.
    /// It supports custom themes via `UIButtonThemeProtocol`.
    ///
    /// ```swift
    /// UI.ImageButton(title: "Share", image: "square.and.arrow.up", action: { share() })
    /// ```
    public struct ImageButton<S: UIButtonThemeProtocol>: View {
        /// Optional text shown on the button.
        private let title: String?
        /// The SF Symbol name for the button's image.
        private let image: String
        /// The position of the image relative to the title.
        private let imagePosition: ImagePosition
        /// The spacing between the image and the title.
        private let spacing: CGFloat
        /// The visual style of the button.
        private let style: S
        /// The closure called when the button is tapped.
        private let action: () -> Void
        
        @Environment(\.isEnabled) private var isEnabled
        
        public init(
            title: String? = nil,
            image: String,
            imagePosition: ImagePosition = .leading,
            spacing: CGFloat = 8,
            style: S,
            action: @escaping () -> Void
        ) {
            self.title = title
            self.image = image
            self.imagePosition = imagePosition
            self.spacing = spacing
            self.style = style
            self.action = action
        }
        
        public var body: some View {
            SwiftUI.Button(action: action) {
                HStack(spacing: spacing) {
                    if imagePosition == .leading {
                        ButtonIcon(systemName: image, font: style.font)
                        ButtonTitle(title: title, font: style.font)
                    } else {
                        ButtonTitle(title: title, font: style.font)
                        ButtonIcon(systemName: image, font: style.font)
                    }
                }
                .frame(height: style.height)
                .frame(maxWidth: title != nil ? .infinity : style.height)
                .background(isEnabled ? style.backgroundColor : style.disabledBackgroundColor)
                .foregroundStyle(style.foregroundColor)
                .clipShape(.rect(cornerRadius: style.cornerRadius))
            }
            .buttonStyle(UIInteractionStyle(theme: style))
            .accessibilityLabel(title ?? image)
            .accessibilityAddTraits(.isButton)
        }
    }
}

extension UI.ImageButton where S == UIButtonTheme {
    public init(
        title: String? = nil,
        image: String,
        imagePosition: ImagePosition = .leading,
        spacing: CGFloat = 8,
        style: UIButtonTheme = .primary,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.image = image
        self.imagePosition = imagePosition
        self.spacing = spacing
        self.style = style
        self.action = action
    }
}

// MARK: - Button Icon
private struct ButtonIcon: View {
    let systemName: String
    let font: Font
    
    var body: some View {
        Image(systemName: systemName)
            .font(font)
    }
}

// MARK: - Button Title
private struct ButtonTitle: View {
    let title: String?
    let font: Font
    
    var body: some View {
        if let title {
            Text(title)
                .font(font)
        }
    }
}

#Preview("Image Positions") {
    VStack(spacing: 20) {
        UI.ImageButton(
            title: "Leading Image",
            image: "square.and.arrow.up",
            imagePosition: .leading,
            style: .primary,
            action: {}
        )
        
        UI.ImageButton(
            title: "Trailing Image",
            image: "arrow.right",
            imagePosition: .trailing,
            style: .secondary,
            action: {}
        )
        
        UI.ImageButton(image: "star.fill", style: .destructive, action: {})
    }
    .padding()
}
