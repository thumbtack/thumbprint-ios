// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Thumbprint",
    platforms: [
        .iOS(.v13),
        .macOS(.v12), // Required for running swiftformat in CI
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "Thumbprint",
            targets: ["Thumbprint"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/SnapKit/SnapKit.git", exact: "5.6.0"),
        .package(url: "https://github.com/thumbtack/TTCalendarPicker.git", exact: "0.2.0"),
        .package(url: "https://github.com/pointfreeco/swift-snapshot-testing.git", exact: "1.11.0"),
        .package(url: "https://github.com/thumbtack/thumbprint-tokens.git", exact: "13.0.1"),
        .package(url: "https://github.com/lukepistrol/SwiftLintPlugin", exact: "0.2.6"),
        .package(url: "https://github.com/nicklockwood/SwiftFormat", exact: "0.51.8"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "Thumbprint",
            dependencies: [
                "SnapKit",
                "TTCalendarPicker",
                .product(name: "ThumbprintTokens", package: "thumbprint-tokens"),
            ],
            resources: [
                .copy("Resources/Assets.xcassets"),
            ],
            plugins: [
                .plugin(name: "SwiftLint", package: "SwiftLintPlugin"),
                .plugin(name: "SwiftFormat", package: "SwiftFormat"),
            ]
        ),
        .testTarget(
            name: "ThumbprintTests",
            dependencies: [
                "Thumbprint",
                "SnapKit",
                "TTCalendarPicker",
                .product(name: "ThumbprintTokens", package: "thumbprint-tokens"),
                .product(name: "SnapshotTesting", package: "swift-snapshot-testing"),
            ],
            exclude: ["Snapshot"]
        ),
    ],
    swiftLanguageVersions: [
        .v5,
    ]
)
