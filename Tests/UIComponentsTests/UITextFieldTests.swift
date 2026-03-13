//
//  UITextFieldTests.swift
//  UIComponents
//
//  Created by Ahmed Hamam on 28/02/2026.
//

import Testing
import SwiftUI
@testable import UIComponents

@Suite("UITextField")
struct UITextFieldTests {

    @MainActor
    @Test("TextField can be instantiated")
    func initialization() {
        let textBinding = Binding<String>(get: { "" }, set: { _ in })
        let view = UI.TextField(text: textBinding, placeholder: "Test")
        _ = view // Verifies instantiation compiles
    }
}
