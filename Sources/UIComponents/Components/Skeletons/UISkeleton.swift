//
//  UISkeleton.swift
//  UIComponents
//
//  Created by Ahmed Hamam on 28/01/2026.
//

import SwiftUI

// MARK: - Redacted Skeleton Modifier
public extension View {
    /// Applies an automatic skeleton loading effect that matches the view's shape.
    ///
    /// This modifier uses SwiftUI's redaction system to automatically create
    /// skeleton placeholders that match your view's layout.
    ///
    /// - Parameters:
    ///   - isLoading: Whether to show the skeleton loading state.
    ///   - theme: The visual theme for the skeleton effect.
    ///   - loadingLabel: Custom VoiceOver label when loading (default: "Loading content").
    ///
    /// ```swift
    /// VStack {
    ///     Text("User Name")
    ///     Text("user@example.com")
    /// }
    /// .skeletonRedacted(isLoading: true, loadingLabel: "Loading profile")
    /// ```
    func skeletonRedacted(
        isLoading: Bool,
        theme: UISkeletonTheme = .default,
        loadingLabel: String = "Loading content"
    ) -> some View {
        self.modifier(RedactedSkeletonModifier(isLoading: isLoading, theme: theme, loadingLabel: loadingLabel))
    }
}

private struct RedactedSkeletonModifier: ViewModifier {
    let isLoading: Bool
    let theme: UISkeletonTheme
    let loadingLabel: String
    @State private var phase: CGFloat = 0
    
    func body(content: Content) -> some View {
        content
            .redacted(reason: isLoading ? .placeholder : [])
            .overlay(
                // Using drawingGroup() for better animation performance
                // This flattens the shimmer to a Metal layer, reducing layout overhead
                shimmerOverlay
                    .drawingGroup()
            )
            .accessibilityElement(children: isLoading ? .ignore : .contain)
            .accessibilityLabel(isLoading ? loadingLabel : "")
            .accessibilityAddTraits(isLoading ? .updatesFrequently : [])
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
    
    @ViewBuilder
    private var shimmerOverlay: some View {
        if isLoading {
            GeometryReader { geo in
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
    }
}

#Preview("Automatic Skeleton") {
    VStack(spacing: 30) {
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
            }
        }
        .skeletonRedacted(isLoading: true, theme: UISkeletonTheme(baseColor: .cyan, highlightColor: .gray.opacity(0.1), animationDuration: 1.9))
    }
    .padding()
}
