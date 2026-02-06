//
//  DesignSegmentedControl.swift
//  UIComponents
//
//  Created by Ahmed Hamam on 28/01/2026.
//

import SwiftUI

public struct DesignSegmentedControl<T: Hashable & Identifiable, S: SegmentedThemeProtocol>: View {
    @Binding private var selection: T
    private let options: [T]
    private let labelSelector: (T) -> String
    private let theme: S
    
    public init(
        selection: Binding<T>,
        options: [T],
        labelSelector: @escaping (T) -> String,
        theme: S
    ) {
        self._selection = selection
        self.options = options
        self.labelSelector = labelSelector
        self.theme = theme
    }
    
    public var body: some View {
        ZStack(alignment: .leading) {
            // Background
            RoundedRectangle(cornerRadius: theme.cornerRadius)
                .fill(theme.backgroundColor)
                .frame(height: theme.height)
            
            // Sliding Selection Indicator
            GeometryReader { geo in
                let segmentWidth = geo.size.width / CGFloat(options.count)
                let selectedIndex = options.firstIndex(where: { $0.id == selection.id }) ?? 0
                
                RoundedRectangle(cornerRadius: theme.cornerRadius - 2)
                    .fill(theme.selectedColor)
                    .padding(theme.selectedCapsulPadding)
                    .frame(width: segmentWidth, height: theme.height)
                    .offset(x: segmentWidth * CGFloat(selectedIndex))
                    .animation(.spring(response: 0.3, dampingFraction: 0.8), value: selection)
            }
            .frame(height: theme.height)
            
            // Segment Labels
            HStack(spacing: 0) {
                ForEach(options) { option in
                    SegmentButton(
                        label: labelSelector(option),
                        isSelected: selection.id == option.id,
                        theme: theme,
                        action: { selection = option }
                    )
                }
            }
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Segmented control")
    }
}

extension DesignSegmentedControl where S == DesignSegmentedTheme {
    public init(
        selection: Binding<T>,
        options: [T],
        labelSelector: @escaping (T) -> String,
        theme: DesignSegmentedTheme = .default
    ) {
        self._selection = selection
        self.options = options
        self.labelSelector = labelSelector
        self.theme = theme
    }
}

// MARK: - Segment Button View
private struct SegmentButton<S: SegmentedThemeProtocol>: View {
    let label: String
    let isSelected: Bool
    let theme: S
    let action: () -> Void
    
    var body: some View {
        SwiftUI.Button(action: action) {
            Text(label)
                .font(theme.font)
                .foregroundStyle(isSelected ? theme.selectedTextColor : theme.textColor)
                .frame(maxWidth: .infinity, maxHeight: theme.height)
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel(label)
        .accessibilityValue(isSelected ? "Selected" : "Not selected")
        .accessibilityAddTraits(isSelected ? [.isButton, .isSelected] : .isButton)
    }
}

#Preview("Default Theme") {
    struct PreviewWrapper: View {
        @State private var selection = SegmentOption(id: 0, title: "Day")
        private let options = [
            SegmentOption(id: 0, title: "Day"),
            SegmentOption(id: 1, title: "Week"),
            SegmentOption(id: 2, title: "Month")
        ]
        
        var body: some View {
            DesignSegmentedControl(
                selection: $selection,
                options: options,
                labelSelector: { $0.title },
                theme: DesignSegmentedTheme(backgroundColor: .brown, selectedColor: .gray, textColor: .black, selectedTextColor: .white, font: .callout, cornerRadius: 8, height: 45)
            )
            .padding()
        }
    }
    
    struct SegmentOption: Hashable, Identifiable {
        let id: Int
        let title: String
    }
    
    return PreviewWrapper()
}
