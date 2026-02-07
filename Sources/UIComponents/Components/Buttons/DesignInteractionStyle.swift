//
//  DesignInteractionStyle.swift
//  UIComponents
//
//  Created by Ahmed Hamam on 07/02/2026.
//

import SwiftUI

//  Shared button style for design buttons (press opacity and scale).
struct DesignInteractionStyle: ButtonStyle {
    let theme: ButtonThemeProtocol
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .opacity(configuration.isPressed ? theme.pressedOpacity : 1.0)
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}
