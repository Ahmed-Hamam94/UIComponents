//
//  DesignCard.swift
//  UIComponents
//
//  Created by Ahmed Hamam on 28/01/2026.
//

import SwiftUI

public struct DesignCard<Content: View>: View {
    private let content: Content
    private let theme: CardThemeProtocol
    
    public init(
        theme: CardThemeProtocol = DesignCardTheme(),
        @ViewBuilder content: () -> Content
    ) {
        self.theme = theme
        self.content = content()
    }
    
    public var body: some View {
        content
            .padding(theme.padding)
            .background(theme.backgroundColor)
            .cornerRadius(theme.cornerRadius)
            .shadow(
                color: theme.shadowColor,
                radius: theme.shadowRadius,
                x: theme.shadowOffset.x,
                y: theme.shadowOffset.y
            )
    }
}

struct DesignCard_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            DesignCard {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Card Title")
                        .font(.headline)
                    Text("This is some content inside the card. It looks premium and clean.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            
            DesignCard(theme: DesignCardTheme(backgroundColor: .green)) {
                Text("Green Card")
                    .foregroundColor(.white)
                    .bold()
            }
        }
        .padding()
    }
}
