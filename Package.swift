// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.
// Requires Swift 6.0+ for iOS 18. Use Xcode or Terminal to build if the IDE run fails (sandbox).

import PackageDescription

let package = Package(
    name: "UIComponents",
    platforms: [
        .iOS(.v18),
        .macOS(.v15)
    ],
    products: [
        .library(
            name: "UIComponents",
            targets: ["UIComponents"]
        ),
    ],
    targets: [
        .target(
            name: "UIComponents"
        ),
        .testTarget(
            name: "UIComponentsTests",
            dependencies: ["UIComponents"]
        ),
    ]
)
