//
//  UISkeleton.swift
//  UIComponents
//
//  Created by Ahmed Hamam on 28/01/2026.
//

import SwiftUI

/// Defines the geometric shape of a skeleton placeholder.
public enum SkeletonShape: Sendable {
    /// A rectangular shape with an optional corner radius.
    case rectangle(cornerRadius: CGFloat = 8)
    /// A circular shape.
    case circle
}

extension UI {
    /// An animated placeholder used to indicate that content is loading.
    ///
    /// Skeletons feature a shimmer animation and support different shapes (rectangle, circle).
    /// They support custom themes via `UISkeletonThemeProtocol`.
    ///
    /// ```swift
    /// // Manual skeleton
    /// UI.Skeleton(shape: .circle)
    ///     .frame(width: 50, height: 50)
    ///
    /// // Automatic skeleton from any view
    /// Text("Loading...")
    ///     .skeleton(isLoading: true)
    /// ```
    public struct Skeleton<T: UISkeletonThemeProtocol>: View {
        /// The shape of the skeleton placeholder.
        private let shape: SkeletonShape
        /// The visual style and animation settings of the skeleton.
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

// MARK: - Redacted Skeleton Modifier
public extension View {
    /// Applies an automatic skeleton loading effect that matches the view's shape.
    ///
    /// This modifier uses SwiftUI's redaction system to automatically create
    /// skeleton placeholders that match your view's layout.
    ///
    /// ```swift
    /// VStack {
    ///     Text("User Name")
    ///     Text("user@example.com")
    /// }
    /// .skeletonRedacted(isLoading: true)
    /// ```
    func skeletonRedacted(
        isLoading: Bool,
        theme: UISkeletonTheme = .default
    ) -> some View {
        self.modifier(RedactedSkeletonModifier(isLoading: isLoading, theme: theme))
    }
}

private struct RedactedSkeletonModifier: ViewModifier {
    let isLoading: Bool
    let theme: UISkeletonTheme
    @State private var phase: CGFloat = 0
    
    func body(content: Content) -> some View {
        content
            .redacted(reason: isLoading ? .placeholder : [])
            .overlay(
                GeometryReader { geo in
                    if isLoading {
                        // Enhanced shimmer gradient with better visibility
                        LinearGradient(
                            gradient: Gradient(colors: [
                                .clear,
                                theme.highlightColor.opacity(0.3),
                                theme.highlightColor.opacity(0.8),
                                theme.highlightColor.opacity(0.3),
                                .clear
                            ]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                        .frame(width: geo.size.width * 0.7) // Wider shimmer
                        .offset(x: -geo.size.width * 0.7 + (geo.size.width * 1.7 * phase))
                        .blendMode(.screen) // Better blend mode for visibility
                        .allowsHitTesting(false)
                    }
                }
            )
            .onAppear {
                if isLoading {
                    withAnimation(.linear(duration: theme.animationDuration * 0.8).repeatForever(autoreverses: false)) {
                        phase = 1
                    }
                }
            }
            .onChange(of: isLoading) { _, newValue in
                if newValue {
                    phase = 0
                    withAnimation(.linear(duration: theme.animationDuration * 0.8).repeatForever(autoreverses: false)) {
                        phase = 1
                    }
                }
            }
    }
}

#Preview("Automatic Skeleton") {
    VStack(spacing: 30) {
        UI.Skeleton(shape: .circle)
            .frame(width: 50, height: 50)
        
        // Using .skeleton() modifier
        VStack(alignment: .leading, spacing: 8) {
            Text("Manual Skeleton Modifier")
                .font(.headline)
            
            HStack {
                Circle()
                    .fill(.blue)
                    .frame(width: 50, height: 50)
                    .skeleton(isLoading: true, shape: .circle)
                
                VStack(alignment: .leading) {
                    Text("John Doe")
                        .skeleton(isLoading: true)
                    Text("john@example.com")
                        .font(.caption)
                        .skeleton(isLoading: true)
                }
            }
        }
        
        Divider()
        
        // Using .skeletonRedacted() modifier
        VStack(alignment: .leading, spacing: 8) {
            Text("Redacted Skeleton (Auto-shape)")
                .font(.headline)
            
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: "person.circle.fill")
                        .font(.system(size: 50))
                    
                    VStack(alignment: .leading) {
                        Text("Jane Smith")
                            .font(.headline)
                        Text("Product Designer")
                            .font(.subheadline)
                        Text("San Francisco, CA")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                
                Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.")
                    .font(.body)
                HStack {
                    Image(systemName: "person.circle.fill")
                        .font(.system(size: 50))
                    
                    VStack(alignment: .leading) {
                        Text("Jane Smith")
                            .font(.headline)
                        Text("Product Designer")
                            .font(.subheadline)
                        Text("San Francisco, CA")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                
                Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.")
                    .font(.body)
                HStack {
                    Image(systemName: "person.circle.fill")
                        .font(.system(size: 50))
                    
                    VStack(alignment: .leading) {
                        Text("Jane Smith")
                            .font(.headline)
                        Text("Product Designer")
                            .font(.subheadline)
                        Text("San Francisco, CA")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                
                Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.")
                    .font(.body)
                HStack {
                    Image(systemName: "person.circle.fill")
                        .font(.system(size: 50))
                    
                    VStack(alignment: .leading) {
                        Text("Jane Smith")
                            .font(.headline)
                        Text("Product Designer")
                            .font(.subheadline)
                        Text("San Francisco, CA")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                
                Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.")
                    .font(.body)
            }
            
        }
          .skeletonRedacted(isLoading: true)
    }
    .padding()
}
