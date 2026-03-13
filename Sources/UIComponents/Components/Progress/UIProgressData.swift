//
//  UIProgressData.swift
//  UIComponents
//
//  Created by Ahmed Hamam on 13/03/2026.
//

import SwiftUI

/// Holds progress data values, separated from visual style.
///
/// Use this struct to provide progress data independently of the visual presentation.
public struct UIProgressData: Sendable {
    /// The progress value (0.0 to 1.0) for linear, circular, and gradient styles.
    public var value: Double
    /// The current step for stepped and order tracking styles.
    public var currentStep: Int
    /// The total number of steps for stepped and order tracking styles.
    public var totalSteps: Int
    /// Optional labels for each step.
    public var labels: [String]?
    
    /// Creates progress data for a percentage-based progress indicator.
    /// - Parameter value: Progress value from 0.0 to 1.0.
    public init(value: Double) {
        self.value = min(max(value, 0), 1)
        self.currentStep = 0
        self.totalSteps = 1
        self.labels = nil
    }
    
    /// Creates progress data for a stepped/multi-stage progress indicator.
    /// - Parameters:
    ///   - currentStep: The current step (0-indexed completion, so 1 means first step done).
    ///   - totalSteps: The total number of steps.
    ///   - labels: Optional labels for each step.
    public init(currentStep: Int, totalSteps: Int, labels: [String]? = nil) {
        self.value = totalSteps > 0 ? Double(currentStep) / Double(totalSteps) : 0
        self.currentStep = currentStep
        self.totalSteps = totalSteps
        self.labels = labels
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
