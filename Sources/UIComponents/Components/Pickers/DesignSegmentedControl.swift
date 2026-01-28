//
//  DesignSegmentedControl.swift
//  UIComponents
//
//  Created by Ahmed Hamam on 28/01/2026.
//

import SwiftUI

public struct DesignSegmentedControl<T: Hashable & Identifiable>: View {
    @Binding private var selection: T
    private let options: [T]
    private let labelSelector: (T) -> String
    private let theme: SegmentedThemeProtocol
    
    public init(
        selection: Binding<T>,
        options: [T],
        labelSelector: @escaping (T) -> String,
        theme: SegmentedThemeProtocol = DesignSegmentedTheme()
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
            
            // Sliding Selection
            GeometryReader { geo in
                let segmentWidth = geo.size.width / CGFloat(options.count)
                let selectedIndex = options.firstIndex(where: { $0.id == selection.id }) ?? 0
                
                RoundedRectangle(cornerRadius: theme.cornerRadius - 2)
                    .fill(theme.selectedColor)
                    .padding(2)
                    .frame(width: segmentWidth, height: theme.height)
                    .offset(x: segmentWidth * CGFloat(selectedIndex))
                    .animation(.spring(response: 0.3, dampingFraction: 0.8), value: selection)
            }
            .frame(height: theme.height)
            
            // Labels
            HStack(spacing: 0) {
                ForEach(options) { option in
                    Button(action: {
                        selection = option
                    }) {
                        Text(labelSelector(option))
                            .font(theme.font)
                            .foregroundColor(selection.id == option.id ? theme.selectedTextColor : theme.textColor)
                            .frame(maxWidth: .infinity, maxHeight: theme.height)
                            .contentShape(Rectangle())
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
    }
}

// Helper for Preview
struct SegmentOption: Hashable, Identifiable {
    let id: Int
    let title: String
}

struct DesignSegmentedControl_Previews: PreviewProvider {
    @State static var selection = options[0]
    static let options = [
        SegmentOption(id: 0, title: "Day"),
        SegmentOption(id: 1, title: "Week"),
        SegmentOption(id: 2, title: "Month")
    ]
    
    static var previews: some View {
        VStack(spacing: 30) {
            DesignSegmentedControl(
                selection: $selection,
                options: options,
                labelSelector: { $0.title }
            )
            
            DesignSegmentedControl(
                selection: $selection,
                options: options,
                labelSelector: { $0.title.uppercased() },
                theme: DesignSegmentedTheme(
                    backgroundColor: .black,
                    selectedColor: .blue,
                    textColor: .gray,
                    selectedTextColor: .white
                )
            )
        }
        .padding()
    }
}
