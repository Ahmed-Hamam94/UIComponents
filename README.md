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
[
](https://github.com/Ahmed-Hamam94/UIComponents/blob/34ea2037dc4c859fb9e130093243d1e512c34d98/Assets/Checkbox.png)[
](https://github.com/Ahmed-Hamam94/UIComponents/blob/34ea2037dc4c859fb9e130093243d1e512c34d98/Assets/Radio%20Button.png)
https://github.com/Ahmed-Hamam94/UIComponents/blob/551f52d318011d5b5b55dd3c67d9d085d79adc33/Assets/Button.png

```swift
// Standard Buttons
UI.Button(title: "Save Changes", style: .primary) {
    // Action
}

UI.ImageButton(title: "Scan", systemImage: "qrcode.viewfinder", style: .secondary) {
    // Action
}

// Selection Toggles
UI.Toggle(isOn: $isEnabled, label: "Notifications")

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
[
](https://github.com/Ahmed-Hamam94/UIComponents/blob/34ea2037dc4c859fb9e130093243d1e512c34d98/Assets/Validated%20TextField.png)
```swift
// Themed TextField
UI.TextField(text: $username, title: "Username", placeholder: "Enter username", image: "person")

// Advanced Validation
UI.ValidatedTextField(
    text: $email,
    isValid: $isEmailValid,
    title: "Email (onChange)",
    placeholder: "Enter your email",
    validationRules: [.required(), .email()],
    image: "envelope"
)

// International Phone Picker
UI.PhoneNumberTextField(phoneNumber: $phone, selectedCountry: $country)
```

### Progress & Displays
| Component | Description |
|-----------|-------------|
| `UI.ProgressBar` | Multi-style indicator (Linear, Circular, Stepped, Order Tracking). |
| `UI.Badge` | Compact status indicator with distinct semantic themes. |
| `UI.Card` | Elevated container for grouping related content. |
| `UI.Skeleton` | Premium shimmering loaders for content-heavy views. |

#### Progress Bar
[
](https://github.com/Ahmed-Hamam94/UIComponents/blob/34ea2037dc4c859fb9e130093243d1e512c34d98/Assets/Progress%20Bar.png)
[
](https://github.com/Ahmed-Hamam94/UIComponents/blob/34ea2037dc4c859fb9e130093243d1e512c34d98/Assets/Progress%20Bar2.png)
[
](https://github.com/Ahmed-Hamam94/UIComponents/blob/34ea2037dc4c859fb9e130093243d1e512c34d98/Assets/Progress%20Bar3.png)
```swift
// Progress Indicators
UI.ProgressBar(data: UIProgressData(value: 0.65), visualStyle: .linear)
UI.ProgressBar(data: UIProgressData(value: 0.65), visualStyle: .circular)

// Status Badges
UI.Badge("Active", theme: .success)
UI.Badge("Pending", theme: .warning)

// Elevated Content
UI.Card {
    VStack(alignment: .leading) {
        Text("Order Summary").font(.headline)
        Text("1x Espresso")
    }
}

// Shimmering Loaders
UI.Skeleton(width: 200, height: 20, cornerRadius: 4)
```

### Modals & Overlays (View Modifiers)
| Modifier | Usage |
|----------|-------|
| `.uiToast()` | Self-dismissing info/error banners. |
| `.uiDialog()` | Centered confirmation dialogs for critical actions. |
| `.uiBottomSheet()` | Interactive, draggable sheets with optional handles. |

#### Dialog
[
](https://github.com/Ahmed-Hamam94/UIComponents/blob/34ea2037dc4c859fb9e130093243d1e512c34d98/Assets/Dialog.png)
```swift
// Confirmation Dialogs
.uiDialog(
    isPresented: $showDialog,
    title: "Session Expired",
    message: "Please sign in again to continue.",
    primaryButton: "OK",
    primaryAction: { /* handle OK */ }
)

// Toast Notifications
.uiToast(isPresented: $showToast, message: "Changes Saved!", style: .success)

// Bottom Sheets
.uiBottomSheet(isPresented: $showSheet) {
    VStack {
        Text("Settings").font(.headline)
        // ...
    }
}
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
Welcome contributions! If you find any issues or have suggestions for improvements, feel free to open an issue or submit a pull request. Together, we can make UIComponents even better! 🚀

---

## 📄 License
UIComponents is available under the MIT license.

Copyright (c) 2026 Ahmed Hamam

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
