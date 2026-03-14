# UIComponents

A production-ready, themeable SwiftUI component library for iOS. Ship polished interfaces faster with protocol-driven theming, built-in validation, and full accessibility support.

[![Swift 6.0](https://img.shields.io/badge/Swift-6.0-orange.svg)](https://swift.org)
[![iOS 17+](https://img.shields.io/badge/iOS-17%2B-blue.svg)](https://developer.apple.com/ios/)
[![SPM Compatible](https://img.shields.io/badge/SPM-Compatible-brightgreen.svg)](https://swift.org/package-manager/)
[![License: MIT](https://img.shields.io/badge/License-MIT-lightgrey.svg)](LICENSE)

---

## ✨ Features

- **🛡️ Namespace-protected** — All components live under the `UI` namespace (`UI.Button`, `UI.TextField`, etc.), avoiding collisions with SwiftUI or third-party types.
- **🎨 Protocol-driven theming** — Every component is generic over its theme protocol. Swap styles instantly or build custom themes from scratch.
- **✅ Powerful Validation** — Composable rules (`.required()`, `.email()`, `.minLength()`, etc.) that plug directly into `ValidatedTextField`.
- **♿ Accessibility First** — Native support for labels, hints, traits, and **Reduce Motion** out of the box.
- **⚡ Performance Optimized** — Built for Swift 6 with strict concurrency support and efficient SwiftUI rendering.

---

## 🛠️ Requirements

| Requirement | Minimum |
|-------------|---------|
| iOS | 17.0 |
| Swift | 6.0 |
| Xcode | 16.0 |

---

## 📦 Installation

### Swift Package Manager

Add the following to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/Ahmed-Hamam94/UIComponents.git", from: "1.0.0")
]
```

Or in Xcode: **File > Add Package Dependencies**, and paste the repository URL.

---

## 🚀 Quick Start

```swift
import SwiftUI
import UIComponents

struct LoginView: View {
    @State private var email = ""
    @State private var isValid = true

    var body: some View {
        VStack(spacing: 20) {
            UI.ValidatedTextField(
                text: $email,
                isValid: $isValid,
                title: "Login",
                placeholder: "Enter your email",
                validationRules: [.required(), .email()],
                image: "envelope",
                imagePosition: .leading
            )

            UI.Button(title: "Continue", style: .primary) {
                print("Proceeding with \(email)")
            }
            .disabled(!isValid)
        }
        .padding()
    }
}
```

---

## 🧩 Components

Explore the full set of components available in the `UI` namespace.

### Buttons & Selection
| Component | Description |
|-----------|-------------|
| `UI.Button` | Full-width text button with smooth press animations. |
| `UI.ImageButton` | Configurable button with SF Symbols and flexible icon positioning. |
| `UI.Checkbox` | Interactive square toggle for multiple selection lists. |
| `UI.RadioButton` | Sleek circular indicator for single-choice lists. |
| `UI.Toggle` | Modern capsule switch with spring-driven animations. |

#### Checkbox & Radio Button
<p align="center">
  <img src="/Users/ahmedhamam/.gemini/antigravity/brain/1be5956c-6823-45a5-b0c6-57e25f4a2009/checkbox_preview.png" alt="Checkbox Preview" width="200">
  <img src="/Users/ahmedhamam/.gemini/antigravity/brain/1be5956c-6823-45a5-b0c6-57e25f4a2009/radio_button_preview.png" alt="Radio Button Preview" width="200">
</p>

```swift
// Checkbox usage
UI.Checkbox(isOn: $isChecked, label: "Checkbox Label")
UI.Checkbox(isOn: $isSecondary, label: "Secondary", theme: .secondary)

// Radio Button usage
UI.RadioButton(id: 1, selection: $selection, label: "Option 1")
UI.RadioButton(id: 2, selection: $selection, label: "Success", theme: .success)
```

### Forms & Inputs
| Component | Description |
|-----------|-------------|
| `UI.TextField` | Themed text input with optional icons and built-in error states. |
| `UI.ValidatedTextField` | Advanced input with real-time validation and error feedback. |
| `UI.PhoneNumberTextField` | International phone input with a built-in country picker. |

#### Validated TextField
<p align="center">
  <img src="/Users/ahmedhamam/.gemini/antigravity/brain/1be5956c-6823-45a5-b0c6-57e25f4a2009/validated_textfield_preview.png" alt="Validated TextField Preview" width="300">
</p>

```swift
UI.ValidatedTextField(
    text: $email,
    isValid: $isEmailValid,
    title: "Email (onChange)",
    placeholder: "Enter your email",
    validationRules: [.required(), .email()],
    image: "envelope"
)
```

### Progress & Displays
| Component | Description |
|-----------|-------------|
| `UI.ProgressBar` | Multi-style indicator (Linear, Circular, Stepped, Order Tracking). |
| `UI.Badge` | Compact status indicator with distinct semantic themes. |
| `UI.Card` | Elevated container for grouping related content. |
| `UI.Skeleton` | Premium shimmering loaders for content-heavy views. |

#### Progress Bar
<p align="center">
  <img src="/Users/ahmedhamam/.gemini/antigravity/brain/1be5956c-6823-45a5-b0c6-57e25f4a2009/progress_bar_preview.png" alt="Progress Bar Preview" width="400">
</p>

```swift
// Linear Progress
UI.ProgressBar(data: UIProgressData(value: 0.65), visualStyle: .linear)

// Circular Progress
UI.ProgressBar(data: UIProgressData(value: 0.65), visualStyle: .circular)

// Stepped Progress
UI.ProgressBar(
    data: UIProgressData(currentStep: 2, totalSteps: 4, labels: ["Cart", "Pay", "Ship", "Done"]),
    visualStyle: .stepped(config: UISteppedProgressConfig(
        icons: ["cart", "creditcard", "shippingbox", "checkmark.seal"]
    ))
)
```

### Modals & Overlays (View Modifiers)
| Modifier | Usage |
|----------|-------|
| `.uiToast()` | Self-dismissing info/error banners. |
| `.uiDialog()` | Centered confirmation dialogs for critical actions. |
| `.uiBottomSheet()` | Interactive, draggable sheets with optional handles. |

#### Dialog
<p align="center">
  <img src="/Users/ahmedhamam/.gemini/antigravity/brain/1be5956c-6823-45a5-b0c6-57e25f4a2009/dialog_preview.png" alt="Dialog Preview" width="300">
</p>

```swift
.uiDialog(
    isPresented: $showDialog,
    title: "Session Expired",
    message: "Please sign in again to continue.",
    primaryButton: "OK",
    primaryAction: { /* handle OK */ }
)
```

---

## 💅 Theming

### Use Built-in Presets
Styling is as simple as using dot-syntax for common themes:
```swift
UI.Button(title: "Save", style: .primary)
UI.Badge("Success", theme: .success)
```

### Deep Customization
Need something unique? Conform to any theme protocol:
```swift
struct MyTheme: UIButtonThemeProtocol {
    var backgroundColor: Color { .indigo }
    var foregroundColor: Color { .white }
    var cornerRadius: CGFloat { 12 }
    var font: Font { .headline }
    // ... and more
}

UI.Button(title: "Custom", style: MyTheme())
```

---

## ♿ Accessibility

We believe accessibility isn't an "add-on". 

- **Implicit Safety**: Components use `Button` targets instead of `onTapGesture` for reliable VoiceOver focus.
- **Reduce Motion**: Animations across the entire library automatically simplify when `accessibilityReduceMotion` is enabled in System Settings.
- **Overrides**: Every component accepts an `accessibility: UIAccessibility?` parameter for custom labels and hints.

---

## 🤝 Contributing

Contributions are what make the open-source community such an amazing place to learn, inspire, and create.

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## 📄 License

Distributed under the MIT License. See `LICENSE` for more information.
