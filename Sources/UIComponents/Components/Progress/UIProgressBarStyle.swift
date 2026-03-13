//
//  UIProgressBarStyle.swift
//  UIComponents
//
//  Created by Ahmed Hamam on 13/03/2026.
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

/// Defines the visual presentation style of the progress bar, without data.
public enum UIProgressVisualStyle: Sendable {
    /// A simple linear progress bar.
    case linear
    /// A circular progress indicator.
    case circular
    /// A stepped progress bar for multi-stage processes.
    case stepped(config: UISteppedProgressConfig = .default)
    /// A premium order tracking style with icons and sub-labels.
    case orderTracking(config: UIOrderTrackingConfig = .default)
    /// A gradient-filled progress bar.
    case gradient
}

/// Defines the visual style and data of the progress bar.
///
/// - Note: Prefer using `UIProgressData` and `UIProgressVisualStyle` separately for better separation of concerns.
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
