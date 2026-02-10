//
//  UISegmentedControl.swift
//  UIComponents
//
//  Created by Ahmed Hamam on 28/01/2026.
//

import SwiftUI

extension UI {
    /// A horizontal control for selecting a single option from a set of segments.
    ///
    /// The control features a sliding background indicator for the selected segment.
    /// It works with any type that conforms to `Hashable` and `Identifiable`.
    ///
    /// ```swift
    /// UI.SegmentedControl(
    ///     selection: $mode,
    ///     options: modes,
    ///     labelSelector: { $0.title }
    /// )
    /// ```
    public struct SegmentedControl<T: Hashable & Identifiable, S: UISegmentedThemeProtocol>: View {
        /// A binding to the currently selected option.
        @Binding private var selection: T
        /// The list of available options.
        private let options: [T]
        /// A closure that returns the display string for a given option.
        private let labelSelector: (T) -> String
        /// The visual style of the segmented control.
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
                        .padding(theme.selectedCapsulePadding)
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
}

extension UI.SegmentedControl where S == UISegmentedTheme {
    public init(
        selection: Binding<T>,
        options: [T],
        labelSelector: @escaping (T) -> String,
        theme: UISegmentedTheme = .default
    ) {
        self._selection = selection
        self.options = options
        self.labelSelector = labelSelector
        self.theme = theme
    }
}

// MARK: - Segment Button View
private struct SegmentButton<S: UISegmentedThemeProtocol>: View {
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
            UI.SegmentedControl(
                selection: $selection,
                options: options,
                labelSelector: { $0.title }
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
