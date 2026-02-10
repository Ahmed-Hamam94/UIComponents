//
//  UIProgressBar.swift
//  UIComponents
//
//  Created by Ahmed Hamam on 10/02/2026.
//

import SwiftUI

/// Represents an icon used in a progress step.
public enum UIProgressStepIcon: Sendable, ExpressibleByStringLiteral {
    /// A system symbol (SF Symbol).
    case system(String)
    /// An image from the asset catalog.
    case asset(String)
    /// Uses the default behavior (checkmark for completed, dot for pending).
    case `default`
    
    public init(stringLiteral value: String) {
        self = .system(value)
    }
}

/// Defines the visual style and data of the progress bar.
public enum UIProgressBarStyle: Sendable {
    /// A simple linear progress bar.
    case linear(value: Double)
    /// A circular progress indicator.
    case circular(value: Double)
    /// A stepped progress bar for multi-stage processes.
    case stepped(currentStep: Int, totalSteps: Int, labels: [String]? = nil)
    /// A premium order tracking style with icons and timestamps.
    case orderTracking(currentStep: Int, totalSteps: Int, labels: [String]? = nil, icons: [UIProgressStepIcon]? = nil, timestamps: [String]? = nil)
    /// A gradient-filled progress bar.
    case gradient(value: Double)
}

extension UI {
    /// A customizable progress indicator for showing task completion.
    ///
    /// The initialization depends on the chosen style, which carries the necessary data.
    ///
    /// ```swift
    /// // Linear progress
    /// UI.ProgressBar(style: .linear(value: 0.75))
    ///
    /// // Stepped progress
    /// UI.ProgressBar(
    ///     style: .stepped(
    ///         currentStep: 2, 
    ///         totalSteps: 4, 
    ///         labels: ["Order", "Processing", "Shipped", "Delivered"]
    ///     )
    /// )
    /// ```
    public struct ProgressBar<T: UIProgressThemeProtocol>: View {
        private let style: UIProgressBarStyle
        private let theme: T
        
        @State private var animatedValue: Double = 0
        
        public init(
            style: UIProgressBarStyle,
            theme: T
        ) {
            self.style = style
            self.theme = theme
        }
        
        // Helper to extract normalized value (0-1) for animation
        private var targetValue: Double {
            switch style {
            case .linear(let value), .circular(let value), .gradient(let value):
                return min(max(value, 0), 1)
            case .stepped(let currentStep, let totalSteps, _), 
                 .orderTracking(let currentStep, let totalSteps, _, _, _):
                return totalSteps > 0 ? Double(currentStep) / Double(totalSteps) : 0
            }
        }
        
        public var body: some View {
            Group {
                switch style {
                case .linear(let value):
                    linearProgress(value: value)
                case .circular(let value):
                    circularProgress(value: value)
                case .stepped(let currentStep, let totalSteps, let labels):
                    steppedProgress(currentStep: currentStep, totalSteps: totalSteps, labels: labels)
                case .orderTracking(let currentStep, let totalSteps, let labels, let icons, let timestamps):
                    orderTrackingProgress(currentStep: currentStep, totalSteps: totalSteps, labels: labels, icons: icons, timestamps: timestamps)
                case .gradient(let value):
                    gradientProgress(value: value)
                }
            }
            .onAppear {
                withAnimation(.easeOut(duration: 0.6)) {
                    animatedValue = targetValue
                }
            }
            .onChange(of: targetValue) { _, newValue in
                withAnimation(.easeOut(duration: 0.3)) {
                    animatedValue = newValue
                }
            }
        }
        
        // MARK: - Linear Progress
        private func linearProgress(value: Double) -> some View {
            VStack(alignment: .leading, spacing: 4) {
                if theme.showPercentage {
                    Text("\(Int(value * 100))%")
                        .font(theme.font)
                        .foregroundStyle(theme.textColor)
                }
                
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        // Track
                        RoundedRectangle(cornerRadius: theme.cornerRadius)
                            .fill(theme.trackColor)
                        
                        // Fill
                        RoundedRectangle(cornerRadius: theme.cornerRadius)
                            .fill(theme.fillColor)
                            .frame(width: geo.size.width * animatedValue)
                    }
                }
                .frame(height: theme.height)
            }
            .accessibilityLabel("Progress")
            .accessibilityValue("\(Int(value * 100)) percent")
        }
        
        // MARK: - Circular Progress
        private func circularProgress(value: Double) -> some View {
            ZStack {
                // Background circle
                Circle()
                    .stroke(theme.trackColor, lineWidth: theme.height)
                
                // Progress circle
                Circle()
                    .trim(from: 0, to: animatedValue)
                    .stroke(theme.fillColor, style: StrokeStyle(lineWidth: theme.height, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                
                // Percentage text
                if theme.showPercentage {
                    Text("\(Int(value * 100))%")
                        .font(theme.font)
                        .foregroundStyle(theme.textColor)
                }
            }
            .accessibilityLabel("Progress")
            .accessibilityValue("\(Int(value * 100)) percent")
        }
        
        // MARK: - Stepped Progress
        private func steppedProgress(currentStep: Int, totalSteps: Int, labels: [String]?) -> some View {
            HStack(alignment: .top, spacing: 0) {
                ForEach(0..<totalSteps, id: \.self) { step in
                    VStack(spacing: 8) {
                        // Step Icon + Lines
                        ZStack {
                            // Connecting Lines
                            GeometryReader { geo in
                                HStack(spacing: 0) {
                                    // Left Line
                                    Rectangle()
                                        .fill(step > 0 && step <= currentStep ? theme.fillColor : (step > 0 ? theme.trackColor : .clear))
                                        .frame(width: geo.size.width / 2)
                                    
                                    // Right Line
                                    Rectangle()
                                        .fill(step < totalSteps - 1 && step < currentStep ? theme.fillColor : (step < totalSteps - 1 ? theme.trackColor : .clear))
                                        .frame(width: geo.size.width / 2)
                                }
                                .frame(height: 2)
                                .offset(y: 15) // Center of 32px circle
                            }
                            .frame(height: 32)
                            
                            // Circle Icon
                            ZStack {
                                Circle()
                                    .fill(step < currentStep ? theme.fillColor : theme.trackColor)
                                    .frame(width: 32, height: 32)
                                
                                if step < currentStep {
                                    Image(systemName: "checkmark")
                                        .font(.system(size: 14, weight: .bold))
                                        .foregroundStyle(.white)
                                } else {
                                    Text("\(step + 1)")
                                        .font(.caption.bold())
                                        .foregroundStyle(step == currentStep ? .white : theme.textColor.opacity(0.5))
                                }
                            }
                            .overlay(
                                Circle()
                                    .stroke(step == currentStep ? theme.fillColor : .clear, lineWidth: 2)
                                    .scaleEffect(1.3)
                            )
                        }
                        
                        // Label
                        if let labels = labels, step < labels.count {
                            Text(labels[step])
                                .font(.caption) // Keep distinct from timestamps
                                .fontWeight(step == currentStep ? .semibold : .regular)
                                .foregroundStyle(step <= currentStep ? theme.textColor : theme.textColor.opacity(0.5))
                                .multilineTextAlignment(.center)
                                .fixedSize(horizontal: false, vertical: true) // Allow wrapping
                                .padding(.horizontal, 4)
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .accessibilityLabel("Step \(currentStep) of \(totalSteps)")
        }
        
        // MARK: - Order Tracking Progress
        private func orderTrackingProgress(currentStep: Int, totalSteps: Int, labels: [String]?, icons: [UIProgressStepIcon]?, timestamps: [String]?) -> some View {
            VStack(alignment: .leading, spacing: 16) {
                ForEach(0..<totalSteps, id: \.self) { step in
                    HStack(alignment: .top, spacing: 16) {
                        // Timeline indicator
                        VStack(spacing: 0) {
                            // Icon circle
                            ZStack {
                                Circle()
                                    .fill(step < currentStep ? theme.fillColor : theme.trackColor)
                                    .frame(width: 44, height: 44)
                                
                                if let icons = icons, step < icons.count {
                                    switch icons[step] {
                                    case .system(let name):
                                        Image(systemName: name)
                                            .font(.system(size: 18, weight: .semibold))
                                            .foregroundStyle(step < currentStep ? .white : theme.textColor.opacity(0.5))
                                    case .asset(let name):
                                        Image(name)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 20, height: 20)
                                            .foregroundStyle(step < currentStep ? .white : theme.textColor.opacity(0.5))
                                    case .default:
                                        if step < currentStep {
                                            Image(systemName: "checkmark.circle.fill")
                                                .font(.system(size: 20))
                                                .foregroundStyle(.white)
                                        } else {
                                            Circle()
                                                .fill(step == currentStep ? theme.fillColor.opacity(0.2) : .clear)
                                                .frame(width: 12, height: 12)
                                        }
                                    }
                                } else if step < currentStep {
                                    Image(systemName: "checkmark.circle.fill")
                                        .font(.system(size: 20))
                                        .foregroundStyle(.white)
                                } else {
                                    Circle()
                                        .fill(step == currentStep ? theme.fillColor.opacity(0.2) : .clear)
                                        .frame(width: 12, height: 12)
                                }
                            }
                            .overlay(
                                Circle()
                                    .stroke(step == currentStep ? theme.fillColor : .clear, lineWidth: 3)
                                    .scaleEffect(1.15)
                            )
                            .shadow(
                                color: step == currentStep ? theme.fillColor.opacity(0.3) : .clear,
                                radius: 8,
                                x: 0,
                                y: 4
                            )
                            
                            // Connecting line
                            if step < totalSteps - 1 {
                                Rectangle()
                                    .fill(step < currentStep - 1 ? theme.fillColor : theme.trackColor)
                                    .frame(width: 2)
                                    .frame(height: 40)
                            }
                        }
                        
                        // Content
                        VStack(alignment: .leading, spacing: 4) {
                            if let labels = labels, step < labels.count {
                                Text(labels[step])
                                    .font(.system(size: 16, weight: step == currentStep ? .semibold : .medium))
                                    .foregroundStyle(step <= currentStep ? theme.textColor : theme.textColor.opacity(0.5))
                            }
                            
                            if let timestamps = timestamps, step < timestamps.count {
                                Text(timestamps[step])
                                    .font(.caption)
                                    .foregroundStyle(step < currentStep ? theme.fillColor : theme.textColor.opacity(0.4))
                            }
                        }
                        .padding(.top, 8)
                        
                        Spacer()
                    }
                }
            }
            .accessibilityLabel("Order tracking: Step \(currentStep) of \(totalSteps)")
        }
        
        // MARK: - Gradient Progress
        private func gradientProgress(value: Double) -> some View {
            VStack(alignment: .leading, spacing: 4) {
                if theme.showPercentage {
                    Text("\(Int(value * 100))%")
                        .font(theme.font)
                        .foregroundStyle(theme.textColor)
                }
                
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        // Track
                        RoundedRectangle(cornerRadius: theme.cornerRadius)
                            .fill(theme.trackColor)
                        
                        // Gradient fill
                        RoundedRectangle(cornerRadius: theme.cornerRadius)
                            .fill(
                                LinearGradient(
                                    colors: [theme.fillColor.opacity(0.6), theme.fillColor, theme.fillColor.opacity(0.8)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(width: geo.size.width * animatedValue)
                            .overlay(
                                // Shimmer effect
                                LinearGradient(
                                    colors: [.clear, .white.opacity(0.3), .clear],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                                .frame(width: geo.size.width * animatedValue * 0.3)
                                .offset(x: geo.size.width * animatedValue * 0.7)
                            )
                            .clipShape(RoundedRectangle(cornerRadius: theme.cornerRadius))
                    }
                }
                .frame(height: theme.height)
            }
            .accessibilityLabel("Progress")
            .accessibilityValue("\(Int(value * 100)) percent")
        }
    }
}

// MARK: - Convenience Initializer
extension UI.ProgressBar where T == UIProgressTheme {
    public init(
        style: UIProgressBarStyle,
        theme: UIProgressTheme = .default
    ) {
        self.style = style
        self.theme = theme
    }
}

// MARK: - Previews
#Preview("Progress Styles") {
    ScrollView {
        VStack(spacing: 40) {
            // Linear Section
            VStack(alignment: .leading, spacing: 20) {
                Text("Linear Style")
                    .font(.headline)
                
                UI.ProgressBar(
                    style: .linear(value: 0.65),
                    theme: UIProgressTheme(showPercentage: true)
                )
                
                UI.ProgressBar(
                    style: .linear(value: 0.35),
                    theme: UIProgressTheme(fillColor: .green, showPercentage: true)
                )
            }
            .padding()
            
            Divider()
            
            // Circular Section
            VStack(alignment: .leading, spacing: 20) {
                Text("Circular Style")
                    .font(.headline)
                
                HStack(spacing: 40) {
                    UI.ProgressBar(
                        style: .circular(value: 0.25),
                        theme: UIProgressTheme(height: 8, showPercentage: true)
                    )
                    .frame(width: 80, height: 80)
                    
                    UI.ProgressBar(
                        style: .circular(value: 0.65),
                        theme: UIProgressTheme(fillColor: .green, height: 10, showPercentage: true)
                    )
                    .frame(width: 100, height: 100)
                }
            }
            .padding()
            
            Divider()
            
            // Stepped Section
            VStack(alignment: .leading, spacing: 20) {
                Text("Stepped Style")
                    .font(.headline)
                
                UI.ProgressBar(
                    style: .stepped(
                        currentStep: 2,
                        totalSteps: 4,
                        labels: ["Order Placed", "Processing", "Shipped", "Delivered"]
                    )
                )
                
                UI.ProgressBar(
                    style: .stepped(
                        currentStep: 1,
                        totalSteps: 3,
                        labels: ["Profile", "Verification", "Complete"]
                    ),
                    theme: UIProgressTheme(fillColor: .purple)
                )
            }
            .padding()
            
            Divider()
            
            // Order Tracking Section
            VStack(alignment: .leading, spacing: 20) {
                Text("Order Tracking (Mixed Icon Types)")
                    .font(.headline)
                
                UI.ProgressBar(
                    style: .orderTracking(
                        currentStep: 2,
                        totalSteps: 4,
                        labels: ["Ordered", "Packaged", "Shipped", "Delivered"],
                        icons: [
                            "cart.fill",                // String literal -> .system
                            .default,                   // Use default styling (check/dot)
                            .system("shippingbox.fill"), // Explicit .system
                            "house.fill"
                        ],
                        timestamps: ["10:30 AM", "2:15 PM", "On Way", "Est. Tomorrow"]
                    ),
                    theme: UIProgressTheme(fillColor: .blue)
                )
            }
            .padding()
            
            Divider()
            
            // Gradient Section
            VStack(alignment: .leading, spacing: 20) {
                Text("Gradient Style")
                    .font(.headline)
                
                UI.ProgressBar(
                    style: .gradient(value: 0.75),
                    theme: UIProgressTheme(fillColor: .cyan, height: 10, showPercentage: true)
                )
            }
            .padding()
        }
    }
}
