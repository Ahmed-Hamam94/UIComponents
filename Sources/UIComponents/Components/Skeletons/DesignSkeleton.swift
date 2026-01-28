//
//  DesignSkeleton.swift
//  UIComponents
//
//  Created by Ahmed Hamam on 28/01/2026.
//

import SwiftUI

public struct DesignSkeleton: View {
    private let shape: SkeletonShape
    private let theme: SkeletonThemeProtocol
    @State private var phase: CGFloat = 0
    
    public enum SkeletonShape {
        case rectangle(cornerRadius: CGFloat = 8)
        case circle
    }
    
    public init(
        shape: SkeletonShape = .rectangle(),
        theme: SkeletonThemeProtocol = DesignSkeletonTheme()
    ) {
        self.shape = shape
        self.theme = theme
    }
    
    public var body: some View {
        GeometryReader { geo in
            ZStack {
                skeletonView
                
                LinearGradient(
                    gradient: Gradient(colors: [.clear, theme.highlightColor, .clear]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
                .frame(width: geo.size.width * 0.5)
                .offset(x: -geo.size.width * 0.5 + (geo.size.width * 1.5 * phase))
                .mask(skeletonView)
            }
            .onAppear {
                withAnimation(Animation.linear(duration: theme.animationDuration).repeatForever(autoreverses: false)) {
                    phase = 1
                }
            }
        }
    }
    
    @ViewBuilder
    private var skeletonView: some View {
        switch shape {
        case .rectangle(let cornerRadius):
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(theme.baseColor)
        case .circle:
            Circle()
                .fill(theme.baseColor)
        }
    }
}

struct DesignSkeleton_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            HStack {
                DesignSkeleton(shape: .circle)
                    .frame(width: 50, height: 50)
                
                VStack(alignment: .leading) {
                    DesignSkeleton()
                        .frame(height: 20)
                    DesignSkeleton()
                        .frame(width: 150, height: 15)
                }
            }
            .frame(height: 60)
            
            DesignSkeleton()
                .frame(height: 100)
        }
        .padding()
    }
}
