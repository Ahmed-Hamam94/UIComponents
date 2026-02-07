//
//  UISkeleton.swift
//  UIComponents
//
//  Created by Ahmed Hamam on 28/01/2026.
//

import SwiftUI

public enum SkeletonShape: Sendable {
    case rectangle(cornerRadius: CGFloat = 8)
    case circle
}

extension UI {
    public struct Skeleton<T: UISkeletonThemeProtocol>: View {
        private let shape: SkeletonShape
        private let theme: T
        @State private var phase: CGFloat = 0
        
        public init(
            shape: SkeletonShape = .rectangle(),
            theme: T
        ) {
            self.shape = shape
            self.theme = theme
        }
        
        public var body: some View {
            GeometryReader { geo in
                ZStack {
                    SkeletonBaseShape(shape: shape, color: theme.baseColor)
                    
                    LinearGradient(
                        gradient: Gradient(colors: [.clear, theme.highlightColor, .clear]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .frame(width: geo.size.width * 0.5)
                    .offset(x: -geo.size.width * 0.5 + (geo.size.width * 1.5 * phase))
                    .mask(SkeletonBaseShape(shape: shape, color: theme.baseColor))
                }
                .onAppear {
                    withAnimation(.linear(duration: theme.animationDuration).repeatForever(autoreverses: false)) {
                        phase = 1
                    }
                }
            }
            .accessibilityLabel("Loading")
            .accessibilityAddTraits(.updatesFrequently)
        }
    }
}

extension UI.Skeleton where T == UISkeletonTheme {
    public init(
        shape: SkeletonShape = .rectangle(),
        theme: UISkeletonTheme = .default
    ) {
        self.shape = shape
        self.theme = theme
    }
}

// MARK: - Skeleton Base Shape
private struct SkeletonBaseShape: View {
    let shape: SkeletonShape
    let color: Color
    
    var body: some View {
        switch shape {
        case .rectangle(let cornerRadius):
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(color)
        case .circle:
            Circle()
                .fill(color)
        }
    }
}

#Preview("Skeleton Card") {
    VStack(spacing: 20) {
        HStack {
            UI.Skeleton(shape: .circle)
                .frame(width: 50, height: 50)
            
            VStack(alignment: .leading) {
                UI.Skeleton()
                    .frame(height: 20)
                UI.Skeleton()
                    .frame(width: 150, height: 15)
            }
        }
        .frame(height: 60)
        
        UI.Skeleton(shape: .rectangle(cornerRadius: 5), theme: .default)
            .frame(height: 100)
    }
    .padding()
}
