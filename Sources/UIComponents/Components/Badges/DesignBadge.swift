//
//  DesignBadge.swift
//  UIComponents
//
//  Created by Ahmed Hamam on 28/01/2026.
//

import SwiftUI

public struct DesignBadge: View {
    private let text: String
    private let theme: BadgeThemeProtocol
    
    public init(
        _ text: String,
        theme: BadgeThemeProtocol = DesignBadgeTheme()
    ) {
        self.text = text
        self.theme = theme
    }
    
    public var body: some View {
        Text(text)
            .font(theme.font)
            .foregroundColor(theme.textColor)
            .padding(.horizontal, theme.horizontalPadding)
            .padding(.vertical, theme.verticalPadding)
            .background(theme.backgroundColor)
            .cornerRadius(theme.cornerRadius)
    }
}

struct DesignBadge_Previews: PreviewProvider {
    static var previews: some View {
        HStack(spacing: 10) {
            DesignBadge("New")
            DesignBadge("Success", theme: DesignBadgeTheme.success)
            DesignBadge("Warning", theme: DesignBadgeTheme.warning)
            DesignBadge("Error", theme: DesignBadgeTheme.error)
        }
        .padding()
    }
}
