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

/// Configuration for the stepped progress style.
public struct UISteppedProgressConfig: Sendable {
    public let iconSize: CGFloat
    public let lineWidth: CGFloat
    public let spacing: CGFloat
    
    public init(iconSize: CGFloat = 32, lineWidth: CGFloat = 2, spacing: CGFloat = 8) {
        self.iconSize = iconSize
        self.lineWidth = lineWidth
        self.spacing = spacing
    }
    
    public static let `default` = UISteppedProgressConfig()
}

/// Configuration for the order tracking progress style.
public struct UIOrderTrackingConfig: Sendable {
    public let iconSize: CGFloat
    public let lineWidth: CGFloat
    public let spacing: CGFloat
    public let icons: [UIProgressStepIcon]?
    public let subLabels: [String]?
    public let subLabelsFont: Font?
    
    public init(
        iconSize: CGFloat = 44,
        lineWidth: CGFloat = 2,
        spacing: CGFloat = 16,
        icons: [UIProgressStepIcon]? = nil,
        subLabels: [String]? = nil,
        subLabelsFont: Font? = .caption
    ) {
        self.iconSize = iconSize
        self.lineWidth = lineWidth
        self.spacing = spacing
        self.icons = icons
        self.subLabels = subLabels
        self.subLabelsFont = subLabelsFont
    }
    
    public static let `default` = UIOrderTrackingConfig()
}

/// Defines the visual style and data of the progress bar.
public enum UIProgressBarStyle: Sendable {
    /// A simple linear progress bar.
    case linear(value: Double)
    /// A circular progress indicator.
    case circular(value: Double)
    /// A stepped progress bar for multi-stage processes.
    case stepped(currentStep: Int, totalSteps: Int, labels: [String]? = nil, config: UISteppedProgressConfig = .default)
    /// A premium order tracking style with icons and sub-labels.
    case orderTracking(currentStep: Int, totalSteps: Int, labels: [String]? = nil, config: UIOrderTrackingConfig = .default)
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
        private let width: CGFloat?
        private let height: CGFloat?
        
        public init(
            style: UIProgressBarStyle,
            theme: T,
            width: CGFloat? = nil,
            height: CGFloat? = nil
        ) {
            self.style = style
            self.theme = theme
            self.width = width
            self.height = height
        }
        
        // Helper to extract normalized value (0-1) for animation
        private var targetValue: Double {
            switch style {
            case .linear(let value), .circular(let value), .gradient(let value):
                return min(max(value, 0), 1)
            case .stepped(let currentStep, let totalSteps, _, _), 
                 .orderTracking(let currentStep, let totalSteps, _, _):
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
                case .stepped(let currentStep, let totalSteps, let labels, let config):
                    steppedProgress(currentStep: currentStep, totalSteps: totalSteps, labels: labels, config: config)
                case .orderTracking(let currentStep, let totalSteps, let labels, let config):
                    orderTrackingProgress(currentStep: currentStep, totalSteps: totalSteps, labels: labels, config: config)
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
                .frame(height: height ?? theme.height)
            }
            .frame(width: width)
            .accessibilityLabel("Progress")
            .accessibilityValue("\(Int(value * 100)) percent")
        }
        
        // MARK: - Circular Progress
        private func circularProgress(value: Double) -> some View {
            let size = min(width ?? 100, height ?? 100)
            return ZStack {
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
            .frame(width: size, height: size)
            .accessibilityLabel("Progress")
            .accessibilityValue("\(Int(value * 100)) percent")
        }
        
        // MARK: - Stepped Progress
        private func steppedProgress(currentStep: Int, totalSteps: Int, labels: [String]?, config: UISteppedProgressConfig) -> some View {
            HStack(alignment: .top, spacing: 0) {
                ForEach(0..<totalSteps, id: \.self) { step in
                    VStack(spacing: config.spacing) {
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
                                .frame(height: config.lineWidth)
                                .offset(y: (config.iconSize / 2) - (config.lineWidth / 2))
                            }
                            .frame(height: config.iconSize)
                            
                            // Circle Icon
                            ZStack {
                                Circle()
                                    .fill(step < currentStep ? theme.fillColor : theme.trackColor)
                                    .frame(width: config.iconSize, height: config.iconSize)
                                
                                if step < currentStep {
                                    Image(systemName: "checkmark")
                                        .font(.system(size: config.iconSize * 0.45, weight: .bold))
                                        .foregroundStyle(.white)
                                } else {
                                    Text("\(step + 1)")
                                        .font(.system(size: config.iconSize * 0.4, weight: .bold))
                                        .foregroundStyle(step == currentStep ? .white : theme.textColor.opacity(0.5))
                                }
                            }
                            .overlay(
                                Circle()
                                    .stroke(step == currentStep ? theme.fillColor : .clear, lineWidth: config.lineWidth)
                                    .scaleEffect(1.3)
                            )
                        }
                        
                        // Label
                        if let labels = labels, step < labels.count {
                            Text(labels[step])
                                .font(theme.font)
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
        private func orderTrackingProgress(currentStep: Int, totalSteps: Int, labels: [String]?, config: UIOrderTrackingConfig) -> some View {
            VStack(alignment: .leading, spacing: config.spacing) {
                ForEach(0..<totalSteps, id: \.self) { step in
                    HStack(alignment: .center, spacing: config.spacing) {
                        // Timeline indicator
                        VStack(spacing: 0) {
                            // Icon circle
                            ZStack {
                                Circle()
                                    .fill(step < currentStep ? theme.fillColor : theme.trackColor)
                                    .frame(width: config.iconSize, height: config.iconSize)
                                
                                if let icons = config.icons, step < icons.count {
                                    switch icons[step] {
                                    case .system(let name):
                                        Image(systemName: name)
                                            .font(.system(size: config.iconSize * 0.4, weight: .semibold))
                                            .foregroundStyle(step < currentStep ? .white : theme.textColor.opacity(0.5))
                                    case .asset(let name):
                                        Image(name)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: config.iconSize * 0.45, height: config.iconSize * 0.45)
                                            .foregroundStyle(step < currentStep ? .white : theme.textColor.opacity(0.5))
                                    case .default:
                                        if step < currentStep {
                                            Image(systemName: "checkmark.circle.fill")
                                                .font(.system(size: config.iconSize * 0.45))
                                                .foregroundStyle(.white)
                                        } else {
                                            Circle()
                                                .fill(step == currentStep ? theme.fillColor.opacity(0.2) : .clear)
                                                .frame(width: config.iconSize * 0.27, height: config.iconSize * 0.27)
                                        }
                                    }
                                } else if step < currentStep {
                                    Image(systemName: "checkmark.circle.fill")
                                        .font(.system(size: config.iconSize * 0.45))
                                        .foregroundStyle(.white)
                                } else {
                                    Circle()
                                        .fill(step == currentStep ? theme.fillColor.opacity(0.2) : .clear)
                                        .frame(width: config.iconSize * 0.27, height: config.iconSize * 0.27)
                                }
                            }
                            .overlay(
                                Circle()
                                    .stroke(step == currentStep ? theme.fillColor : .clear, lineWidth: config.lineWidth * 1.5)
                                    .scaleEffect(1.15)
                            )
                            .shadow(
                                color: step == currentStep ? theme.fillColor.opacity(0.3) : .clear,
                                radius: config.iconSize * 0.18,
                                x: 0,
                                y: config.iconSize * 0.09
                            )
                            
                            // Connecting line
                            if step < totalSteps - 1 {
                                Rectangle()
                                    .fill(step < currentStep - 1 ? theme.fillColor : theme.trackColor)
                                    .frame(width: config.lineWidth)
                                    .frame(height: config.iconSize * 0.9)
                            }
                        }
                        .alignmentGuide(VerticalAlignment.center) { d in config.iconSize / 2 }
                        
                        // Content
                        VStack(alignment: .leading, spacing: 4) {
                            if let labels = labels, step < labels.count {
                                Text(labels[step])
                                    .font(.system(size: 16, weight: step == currentStep ? .semibold : .medium))
                                    .foregroundStyle(step <= currentStep ? theme.textColor : theme.textColor.opacity(0.5))
                            }
                            
                            if let subLabels = config.subLabels, step < subLabels.count {
                                Text(subLabels[step])
                                    .font(config.subLabelsFont ?? .caption)
                                    .foregroundStyle(step < currentStep ? theme.fillColor : theme.textColor.opacity(0.4))
                            }
                        }
                        
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
                .frame(height: height ?? theme.height)
            }
            .frame(width: width)
            .accessibilityLabel("Progress")
            .accessibilityValue("\(Int(value * 100)) percent")
        }
    }
}

// MARK: - Convenience Initializer
extension UI.ProgressBar where T == UIProgressTheme {
    public init(
        style: UIProgressBarStyle,
        theme: UIProgressTheme = .default,
        width: CGFloat? = nil,
        height: CGFloat? = nil
    ) {
        self.style = style
        self.theme = theme
        self.width = width
        self.height = height
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
                    theme: UIProgressTheme(showPercentage: true),
                    width: 300,
                    height: 15
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
                    
                    UI.ProgressBar(
                        style: .circular(value: 0.65),
                        theme: UIProgressTheme(fillColor: .green, height: 30, showPercentage: true)
                    )
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
                        currentStep: 2,
                        totalSteps: 4,
                        labels: ["Small", "Tiny", "Dots", "End"],
                        config: UISteppedProgressConfig(iconSize: 16, lineWidth: 1, spacing: 4)
                    )
                )
            }
            .padding()
            
            Divider()
            
            // Order Tracking Section
            VStack(alignment: .leading, spacing: 20) {
                Text("Order Tracking (Configured)")
                    .font(.headline)
                
                UI.ProgressBar(
                    style: .orderTracking(
                        currentStep: 2,
                        totalSteps: 4,
                        labels: ["Ordered", "Packaged", "Shipped", "Delivered"],
                        config: UIOrderTrackingConfig(
                            iconSize: 60,
                            lineWidth: 4,
                            spacing: 24,
                            icons: ["cart.fill", .default, .system("shippingbox.fill"), "house.fill"],
                            subLabels: ["10:30 AM", "2:15 PM", "On Way", "Est. Tomorrow"],
                            subLabelsFont: .body
                        )
                    ),
                    theme: UIProgressTheme(fillColor: .orange)
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
                    theme: UIProgressTheme(fillColor: .cyan, showPercentage: true),
                    width: 250,
                    height: 50
                )
            }
            .padding()
        }
    }
}
