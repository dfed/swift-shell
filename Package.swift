// swift-tools-version:6.0
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
			targets: ["SwiftShell"]
		),
	],
	dependencies: [],
	targets: [
		.target(
			name: "SwiftShell",
			dependencies: [],
			swiftSettings: [
				.swiftLanguageMode(.v6),
			]
		),
		.testTarget(
			name: "SwiftShellTests",
			dependencies: ["SwiftShell"],
			swiftSettings: [
				.swiftLanguageMode(.v6),
			]
		),
	]
)
