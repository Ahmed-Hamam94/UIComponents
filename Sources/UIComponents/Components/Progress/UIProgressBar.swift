//
//  UIProgressBar.swift
//  UIComponents
//
//  Created by Ahmed Hamam on 10/02/2026.
//

import SwiftUI

extension UI {
    /// A customizable progress indicator for showing task completion.
    ///
    /// **Recommended**: Use the new data/visualStyle initializer for better separation of concerns:
    /// ```swift
    /// // Linear progress with separated data and style
    /// UI.ProgressBar(
    ///     data: UIProgressData(value: 0.75),
    ///     visualStyle: .linear
    /// )
    ///
    /// // Stepped progress
    /// UI.ProgressBar(
    ///     data: UIProgressData(currentStep: 2, totalSteps: 4, labels: ["Order", "Processing", "Shipped", "Delivered"]),
    ///     visualStyle: .stepped()
    /// )
    /// ```
    ///
    /// **Legacy**: The combined style initializer is still supported but deprecated:
    /// ```swift
    /// UI.ProgressBar(style: .linear(value: 0.75))
    /// ```
    public struct ProgressBar<T: UIProgressThemeProtocol>: View {
        // Internal storage uses the legacy style for rendering
        private let style: UIProgressBarStyle
        private let theme: T
        private let accessibility: UIAccessibility?
        
        @Environment(\.accessibilityReduceMotion) private var reduceMotion
        @State private var animatedValue: Double = 0
        private let width: CGFloat?
        private let height: CGFloat?
        
        // MARK: - New Initializer (Recommended)
        
        /// Creates a progress bar with separated data and visual style.
        /// - Parameters:
        ///   - data: The progress data (value, steps, labels).
        ///   - visualStyle: The visual presentation style.
        ///   - theme: The color and typography theme.
        ///   - accessibility: Optional custom accessibility configuration.
        ///   - width: Optional fixed width.
        ///   - height: Optional fixed height.
        public init(
            data: UIProgressData,
            visualStyle: UIProgressVisualStyle,
            theme: T,
            accessibility: UIAccessibility? = nil,
            width: CGFloat? = nil,
            height: CGFloat? = nil
        ) {
            // Convert to legacy style for internal rendering
            switch visualStyle {
            case .linear:
                self.style = .linear(value: data.value)
            case .circular:
                self.style = .circular(value: data.value)
            case .gradient:
                self.style = .gradient(value: data.value)
            case .stepped(let config):
                self.style = .stepped(currentStep: data.currentStep, totalSteps: data.totalSteps, labels: data.labels, config: config)
            case .orderTracking(let config):
                self.style = .orderTracking(currentStep: data.currentStep, totalSteps: data.totalSteps, labels: data.labels, config: config)
            }
            self.theme = theme
            self.accessibility = accessibility
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
        
        // Computed accessibility defaults based on style
        private var defaultAccessibilityLabel: String {
            switch style {
            case .linear, .circular, .gradient:
                return "Progress"
            case .stepped(let currentStep, let totalSteps, let labels, _):
                if let labels = labels, currentStep < labels.count {
                    return "Step \(currentStep + 1) of \(totalSteps): \(labels[currentStep])"
                }
                return "Step \(currentStep + 1) of \(totalSteps)"
            case .orderTracking(let currentStep, let totalSteps, let labels, _):
                if let labels = labels, currentStep > 0, currentStep - 1 < labels.count {
                    return "Order tracking: \(labels[currentStep - 1]) completed, step \(currentStep) of \(totalSteps)"
                }
                return "Order tracking: Step \(currentStep) of \(totalSteps)"
            }
        }
        
        private var defaultAccessibilityValue: String {
            switch style {
            case .linear(let value), .circular(let value), .gradient(let value):
                return "\(Int(value * 100)) percent"
            case .stepped(let currentStep, let totalSteps, _, _),
                 .orderTracking(let currentStep, let totalSteps, _, _):
                let percent = totalSteps > 0 ? Int(Double(currentStep) / Double(totalSteps) * 100) : 0
                return "\(percent) percent complete"
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
                if reduceMotion {
                    animatedValue = targetValue
                } else {
                    withAnimation(.easeOut(duration: 0.6)) {
                        animatedValue = targetValue
                    }
                }
            }
            .onChange(of: targetValue) { _, newValue in
                if reduceMotion {
                    animatedValue = newValue
                } else {
                    withAnimation(.easeOut(duration: 0.3)) {
                        animatedValue = newValue
                    }
                }
            }
            .accessibilityElement(children: .ignore)
            .uiAccessibility(
                accessibility,
                defaultLabel: defaultAccessibilityLabel,
                defaultValue: defaultAccessibilityValue,
                defaultHint: nil
            )
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
                                .offset(y: (config.circleSize / 2) - (config.lineWidth / 2))
                            }
                            .frame(height: config.circleSize)
                            
                            // Circle Icon
                            ZStack {
                                Circle()
                                    .fill(step < currentStep ? theme.fillColor : theme.trackColor)
                                    .frame(width: config.circleSize, height: config.circleSize)
                                
                                if let icons = config.icons, step < icons.count {
                                    switch icons[step] {
                                    case .system(let name):
                                        Image(systemName: name)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: config.iconSize, height: config.iconSize)
                                            .fontWeight(.semibold)
                                            .foregroundStyle(step < currentStep ? .white : theme.textColor.opacity(0.5))
                                    case .asset(let name):
                                        Image(name)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: config.iconSize, height: config.iconSize)
                                            .foregroundStyle(step < currentStep ? .white : theme.textColor.opacity(0.5))
                                    case .default:
                                        defaultStepIcon(step: step, currentStep: currentStep, iconSize: config.iconSize)
                                    }
                                } else {
                                    defaultStepIcon(step: step, currentStep: currentStep, iconSize: config.iconSize)
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
        }
        
        // MARK: - Default Step Icon Helper
        @ViewBuilder
        private func defaultStepIcon(step: Int, currentStep: Int, iconSize: CGFloat) -> some View {
            if step < currentStep {
                Image(systemName: "checkmark")
                    .resizable()
                    .scaledToFit()
                    .frame(width: iconSize, height: iconSize)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
            } else {
                Text("\(step + 1)")
                    .font(.system(size: iconSize * 0.9, weight: .bold))
                    .foregroundStyle(step == currentStep ? .white : theme.textColor.opacity(0.5))
            }
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
                                    .frame(width: config.circleSize, height: config.circleSize)
                                
                                if let icons = config.icons, step < icons.count {
                                    switch icons[step] {
                                    case .system(let name):
                                        Image(systemName: name)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: config.iconSize, height: config.iconSize)
                                            .fontWeight(.semibold)
                                            .foregroundStyle(step < currentStep ? .white : theme.textColor.opacity(0.5))
                                    case .asset(let name):
                                        Image(name)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: config.iconSize, height: config.iconSize)
                                            .foregroundStyle(step < currentStep ? .white : theme.textColor.opacity(0.5))
                                    case .default:
                                        if step < currentStep {
                                            Image(systemName: "checkmark.circle.fill")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: config.iconSize, height: config.iconSize)
                                                .foregroundStyle(.white)
                                        } else {
                                            Circle()
                                                .fill(step == currentStep ? theme.fillColor.opacity(0.2) : .clear)
                                                .frame(width: config.circleSize * 0.27, height: config.circleSize * 0.27)
                                        }
                                    }
                                } else if step < currentStep {
                                    Image(systemName: "checkmark.circle.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: config.iconSize, height: config.iconSize)
                                        .foregroundStyle(.white)
                                } else {
                                    Circle()
                                        .fill(step == currentStep ? theme.fillColor.opacity(0.2) : .clear)
                                        .frame(width: config.circleSize * 0.27, height: config.circleSize * 0.27)
                                }
                            }
                            .overlay(
                                Circle()
                                    .stroke(step == currentStep ? theme.fillColor : .clear, lineWidth: config.lineWidth * 1.5)
                                    .scaleEffect(1.15)
                            )
                            .padding(.bottom, step == currentStep ? config.circleSize * 0.1 : 0)
                            .shadow(
                                color: step == currentStep ? theme.fillColor.opacity(0.3) : .clear,
                                radius: config.circleSize * 0.18,
                                x: 0,
                                y: config.circleSize * 0.09
                            )
                            
                            // Connecting line
                            if step < totalSteps - 1 {
                                Rectangle()
                                    .fill(step < currentStep - 1 ? theme.fillColor : theme.trackColor)
                                    .frame(width: config.lineWidth)
                                    .frame(height: config.circleSize * 0.9)
                            }
                        }
                        .alignmentGuide(VerticalAlignment.center) { d in config.circleSize / 2 }
                        
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
        }
    }
}

// MARK: - Convenience Initializers (Default Theme)
extension UI.ProgressBar where T == UIProgressTheme {
    /// Convenience initializer using the default theme with separated data and style.
    public init(
        data: UIProgressData,
        visualStyle: UIProgressVisualStyle,
        theme: UIProgressTheme = .default,
        accessibility: UIAccessibility? = nil,
        width: CGFloat? = nil,
        height: CGFloat? = nil
    ) {
        switch visualStyle {
        case .linear:
            self.style = .linear(value: data.value)
        case .circular:
            self.style = .circular(value: data.value)
        case .gradient:
            self.style = .gradient(value: data.value)
        case .stepped(let config):
            self.style = .stepped(currentStep: data.currentStep, totalSteps: data.totalSteps, labels: data.labels, config: config)
        case .orderTracking(let config):
            self.style = .orderTracking(currentStep: data.currentStep, totalSteps: data.totalSteps, labels: data.labels, config: config)
        }
        self.theme = theme
        self.accessibility = accessibility
        self.width = width
        self.height = height
    }
    
    /// Legacy convenience initializer using the default theme.
    /// - Note: This initializer is deprecated. Use `init(data:visualStyle:)` instead.
    @available(*, deprecated, message: "Use init(data:visualStyle:theme:) for better separation of concerns")
    public init(
        style: UIProgressBarStyle,
        theme: UIProgressTheme = .default,
        accessibility: UIAccessibility? = nil,
        width: CGFloat? = nil,
        height: CGFloat? = nil
    ) {
        self.style = style
        self.theme = theme
        self.accessibility = accessibility
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
                    data: UIProgressData(value: 0.65),
                    visualStyle: .linear,
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
                        data: UIProgressData(value: 0.25),
                        visualStyle: .circular,
                        theme: UIProgressTheme(height: 8, showPercentage: true)
                    )
                    
                    UI.ProgressBar(
                        data: UIProgressData(value: 0.65),
                        visualStyle: .circular,
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
                    data: UIProgressData(
                        currentStep: 2,
                        totalSteps: 4,
                        labels: ["Order Placed", "Processing", "Shipped", "Delivered"]
                    ),
                    visualStyle: .stepped()
                )
                
                UI.ProgressBar(
                    data: UIProgressData(
                        currentStep: 2,
                        totalSteps: 4,
                        labels: ["Small", "Tiny", "Dots", "End"]
                    ),
                    visualStyle: .stepped(config: UISteppedProgressConfig(iconSize: 16, lineWidth: 1, spacing: 4))
                )
            }
            .padding()
            
            Divider()
            
            // Order Tracking Section
            VStack(alignment: .leading, spacing: 20) {
                Text("Order Tracking (Configured)")
                    .font(.headline)
                
                UI.ProgressBar(
                    data: UIProgressData(
                        currentStep: 2,
                        totalSteps: 4,
                        labels: ["Ordered", "Packaged", "Shipped", "Delivered"]
                    ),
                    visualStyle: .orderTracking(config: UIOrderTrackingConfig(
                        iconSize: 60,
                        lineWidth: 4,
                        spacing: 24,
                        icons: ["cart.fill", .default, .system("shippingbox.fill"), "house.fill"],
                        subLabels: ["10:30 AM", "2:15 PM", "On Way", "Est. Tomorrow"],
                        subLabelsFont: .body
                    )),
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
                    data: UIProgressData(value: 0.75),
                    visualStyle: .gradient,
                    theme: UIProgressTheme(fillColor: .cyan, showPercentage: true),
                    width: 250,
                    height: 50
                )
            }
            .padding()
        }
    }
}
