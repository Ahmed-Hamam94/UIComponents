//
//  DesignImageButton.swift
//  UIComponents
//
//  Created by Ahmed Hamam on 22/01/2026.
//

import SwiftUI

public struct DesignImageButton: View {
    var title: String?
    var image: String
    var imagePosition: ImagePosition
    var spacing: CGFloat
    var style: ButtonThemeProtocol
    var action: () -> Void
    
    @Environment(\.isEnabled) private var isEnabled
    
    public init(title: String? = nil, image: String, imagePosition: ImagePosition = .leading, spacing: CGFloat = 8, style: ButtonThemeProtocol = PrimaryTheme(), action: @escaping () -> Void) {
        self.title = title
        self.image = image
        self.imagePosition = imagePosition
        self.spacing = spacing
        self.style = style
        self.action = action
    }
    
    public var body: some View {
        Button(action: action) {
            HStack(spacing: spacing) {
                if imagePosition == .leading {
                    imageView
                    titleView
                } else {
                    titleView
                    imageView
                }
            }
            .frame(height: style.height)
            .frame(maxWidth: title != nil ? .infinity : style.height) // Square if no title
            .background(isEnabled ? style.backgroundColor : style.disabledBackgroundColor)
            .foregroundColor(style.foregroundColor)
            .cornerRadius(style.cornerRadius)
        }
    }
    
    private var imageView: some View {
        Image(systemName: image)
            .font(style.font)
    }
    
    @ViewBuilder
    private var titleView: some View {
        if let title = title {
            Text(title)
                .font(style.font)
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        // Image + Text (Leading)
        DesignImageButton(title: "Leading Image", image: "square.and.arrow.up", imagePosition: .leading, style: PrimaryTheme(), action: {})
    
        
        // Image + Text (Trailing)
        DesignImageButton(title: "Trailing Image", image: "arrow.right", imagePosition: .trailing, style: PrimaryTheme(), action: {})
        
        // Image Only
        DesignImageButton(image: "square.and.arrow.up", style: PrimaryTheme(), action: {})
        
        Divider()
        
        // Styles
        DesignImageButton(title: "Secondary", image: "star.fill", style: SecondaryTheme(), action: {})
        DesignImageButton(title: "Destructive", image: "trash", style: DestructiveTheme(), action: {})
        
        Divider()
        
        // Disabled
        DesignImageButton(title: "Disabled", image: "lock",imagePosition: .leading,spacing: 200, style: PrimaryTheme(), action: {})
            .disabled(true)
    }
    .padding()
}
