// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Thumbprint",
    platforms: [
            .iOS(.v13)
        ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "Thumbprint",
            targets: ["Thumbprint"]),
    ],
    dependencies: [
        .package(url: "https://github.com/SnapKit/SnapKit.git", .upToNextMajor(from: "5.6.0")),
        .package(url: "https://github.com/thumbtack/TTCalendarPicker.git", from: "0.2.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "Thumbprint",
            dependencies: [
                "SnapKit",
                "TTCalendarPicker",
            ]),
        .binaryTarget(
            name: "ThumbprintTokens",
            url: "https://unpkg.com/@thumbtack/thumbprint-tokens@12.1.0/dist/ios.zip",
            checksum: "dd4daf5b0a4e44d381e2279f98aa919453ad9f80f4a53866180b516fb2f27dd2"
        ),
        .testTarget(
            name: "ThumbprintTests",
            dependencies: [
                "Thumbprint",
                "SnapKit",
            ]),
    ],
    swiftLanguageVersions: [
        .v5
    ]
)
