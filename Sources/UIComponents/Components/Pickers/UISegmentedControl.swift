//
//  UISegmentedControl.swift
//  UIComponents
//
//  Created by Ahmed Hamam on 28/01/2026.
//

import SwiftUI

/// Determines the visual style of the segmented control.
public enum UISegmentedControlStyle: Sendable {
    /// A rectangular style with rounded corners and a sliding background.
    case rounded
    /// A rectangular style with rounded corners and a visible border.
    case bordered
    /// A capsule-shaped style with fully rounded ends.
    case circular
    /// A style with no container background, only the sliding indicator background.
    case ghost
    /// A style where segments are separated with spacing and the selection is a distinct pill.
    case pill
}

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
    ///     labelSelector: { $0.title },
    ///     style: .circular
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
        /// The layout style (rounded, circular, ghost, bordered, or pill).
        private let style: UISegmentedControlStyle
        /// Optional accessibility overrides for the control. Nil = use default (label: "Segmented control").
        private let accessibility: UIAccessibility?
        private let width: CGFloat?
        private let height: CGFloat?

        @Namespace private var namespace

        public init(
            selection: Binding<T>,
            options: [T],
            labelSelector: @escaping (T) -> String,
            theme: S,
            style: UISegmentedControlStyle = .rounded,
            accessibility: UIAccessibility? = nil,
            width: CGFloat? = nil,
            height: CGFloat? = nil
        ) {
            self._selection = selection
            self.options = options
            self.labelSelector = labelSelector
            self.theme = theme
            self.style = style
            self.accessibility = accessibility
            self.width = width
            self.height = height
        }
        
        private var effectiveHeight: CGFloat {
            height ?? theme.height
        }
        
        private var cornerRadius: CGFloat {
            switch style {
            case .circular, .pill: return effectiveHeight / 2
            default: return theme.cornerRadius
            }
        }
        
        private var containerBackgroundColor: Color {
            switch style {
            case .ghost, .pill: return .clear
            default: return theme.backgroundColor
            }
        }
        
        private var hStackSpacing: CGFloat {
            style == .pill ? 8 : 0
        }
        
        public var body: some View {
            ZStack(alignment: .leading) {
                // Background
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(containerBackgroundColor)
                    .frame(height: effectiveHeight)
                    .overlay(
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .stroke(theme.borderColor, lineWidth: style == .bordered ? 1 : 0)
                    )
                
                // Sliding Selection Indicator
                GeometryReader { geo in
                    let totalWidth = geo.size.width
                    let segmentWidth = (totalWidth - (CGFloat(options.count - 1) * hStackSpacing)) / CGFloat(options.count)
                    let selectedIndex = options.firstIndex(where: { $0.id == selection.id }) ?? 0
                    
                    RoundedRectangle(cornerRadius: max(0, cornerRadius - theme.selectedCapsulePadding))
                        .fill(theme.selectedColor)
                        .padding(theme.selectedCapsulePadding)
                        .frame(width: segmentWidth, height: effectiveHeight)
                        .offset(x: (segmentWidth + hStackSpacing) * CGFloat(selectedIndex))
                        .shadow(color: style == .pill ? Color.black.opacity(0.1) : .clear, radius: 4, x: 0, y: 2)
                        .animation(.spring(response: 0.35, dampingFraction: 0.75), value: selection)
                }
                .frame(height: effectiveHeight)
                
                // Segment Labels
                HStack(spacing: hStackSpacing) {
                    ForEach(options) { option in
                        SegmentButton(
                            label: labelSelector(option),
                            isSelected: selection.id == option.id,
                            theme: theme,
                            style: style,
                            height: effectiveHeight,
                            namespace: namespace,
                            action: { selection = option }
                        )
                    }
                }
            }
            .frame(width: width, height: height)
            .accessibilityElement(children: .contain)
            .uiAccessibility(accessibility, defaultLabel: "Segmented control")
        }
    }
}

extension Comparable {
    func clamped(to limits: ClosedRange<Self>) -> Self {
        return min(max(self, limits.lowerBound), limits.upperBound)
    }
}

extension UI.SegmentedControl where S == UISegmentedTheme {
    public init(
        selection: Binding<T>,
        options: [T],
        labelSelector: @escaping (T) -> String,
        theme: UISegmentedTheme = .default,
        style: UISegmentedControlStyle = .rounded,
        accessibility: UIAccessibility? = nil,
        width: CGFloat? = nil,
        height: CGFloat? = nil
    ) {
        self._selection = selection
        self.options = options
        self.labelSelector = labelSelector
        self.theme = theme
        self.style = style
        self.accessibility = accessibility
        self.width = width
        self.height = height
    }
}

// MARK: - Segment Button View
private struct SegmentButton<S: UISegmentedThemeProtocol>: View {
    let label: String
    let isSelected: Bool
    let theme: S
    let style: UISegmentedControlStyle // Added style
    let height: CGFloat
    let namespace: Namespace.ID
    let action: () -> Void
    
    var body: some View {
        SwiftUI.Button(action: action) {
            Text(label)
                .font(theme.font)
                .fontWeight(isSelected ? .semibold : .medium)
                .foregroundStyle(isSelected ? theme.selectedTextColor : theme.textColor)
                .scaleEffect(isSelected ? 1.05 : 1.0)
                .frame(maxWidth: .infinity, maxHeight: height)
                .background(
                    isSelected ? Color.clear : Color.primary.opacity(0.001) // Ensure hit test
                )
                .contentShape(Rectangle())
        }
        .buttonStyle(SegmentButtonStyle())
        .animation(.easeInOut(duration: 0.2), value: isSelected)
        .accessibilityLabel(label)
        .accessibilityValue(isSelected ? "Selected" : "Not selected")
        .accessibilityAddTraits(isSelected ? [.isButton, .isSelected] : .isButton)
    }
}

private struct SegmentButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .opacity(configuration.isPressed ? 0.7 : 1.0)
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
    }
}

#Preview("Default Theme") {
    PreviewWrapper()
}

private struct PreviewWrapper: View {
    @State private var selection = PreviewSegmentOption(id: 0, title: "Day")
    private let options = [
        PreviewSegmentOption(id: 0, title: "Day"),
        PreviewSegmentOption(id: 1, title: "Week"),
        PreviewSegmentOption(id: 2, title: "Month")
    ]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                VStack(alignment: .leading) {
                    Text("Rounded (Default)")
                        .font(.caption).foregroundStyle(.secondary)
                    UI.SegmentedControl(
                        selection: $selection,
                        options: options,
                        labelSelector: { $0.title }
                    )
                }
                
                VStack(alignment: .leading) {
                    Text("Circular")
                        .font(.caption).foregroundStyle(.secondary)
                    UI.SegmentedControl(
                        selection: $selection,
                        options: options,
                        labelSelector: { $0.title },
                        style: .circular
                    )
                }
                
                VStack(alignment: .leading) {
                    Text("Ghost")
                        .font(.caption).foregroundStyle(.secondary)
                    UI.SegmentedControl(
                        selection: $selection,
                        options: options,
                        labelSelector: { $0.title },
                        style: .ghost
                    )
                }
                
                VStack(alignment: .leading) {
                    Text("Bordered")
                        .font(.caption).foregroundStyle(.secondary)
                    UI.SegmentedControl(
                        selection: $selection,
                        options: options,
                        labelSelector: { $0.title },
                        theme: UISegmentedTheme(
                            backgroundColor: .white,
                            selectedColor: .blue,
                            textColor: .secondary,
                            selectedTextColor: .white,
                            cornerRadius: 16,
                            borderColor: .blue.opacity(0.3)
                        ),
                        style: .bordered
                    )
                }

                VStack(alignment: .leading) {
                    Text("Pill")
                        .font(.caption).foregroundStyle(.secondary)
                    UI.SegmentedControl(
                        selection: $selection,
                        options: options,
                        labelSelector: { $0.title },
                        theme: UISegmentedTheme(
                            backgroundColor: .clear,
                            selectedColor: .white,
                            textColor: .secondary,
                            selectedTextColor: .blue,
                            selectedCapsulePadding: 2
                        ),
                        style: .pill,
                        width: 290,
                        height: 70
                    )
                    .padding(4)
                    .background(Color.gray.opacity(0.1))
                    .clipShape(Capsule())
                }
                
                VStack(alignment: .leading) {
                    Text("Custom Theme & Circular")
                        .font(.caption).foregroundStyle(.secondary)
                    UI.SegmentedControl(
                        selection: $selection,
                        options: options,
                        labelSelector: { $0.title },
                        theme: UISegmentedTheme(
                            backgroundColor: .blue.opacity(0.1),
                            selectedColor: .blue,
                            textColor: .blue,
                            selectedTextColor: .white,
                            height: 60
                        ),
                        style: .circular
                    )
                }
            }
            .padding()
        }
    }
}

private struct PreviewSegmentOption: Hashable, Identifiable {
    let id: Int
    let title: String
}
