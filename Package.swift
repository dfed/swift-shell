// swift-tools-version:5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftShell",
    platforms: [
        .macOS(.v12),
    ],
    products: [
        .library(
            name: "SwiftShell",
            targets: ["SwiftShell"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "SwiftShell",
            dependencies: []),
        .testTarget(
            name: "SwiftShellTests",
            dependencies: ["SwiftShell"]),
    ],
    swiftLanguageVersions: [.v5]
)
