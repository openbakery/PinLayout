// swift-tools-version:5.3
import PackageDescription

let package = Package(
	name: "PinLayout",
	platforms: [
		.iOS(.v14),
	],
	products: [
		.library(name: "PinLayout", targets: ["PinLayout"]),
	],
	dependencies: [
		.package(
			url: "https://github.com/nschum/SwiftHamcrest/",
			.upToNextMajor(from: "2.2.0")
		),
	],
	targets: [
		.target(
			name: "PinLayout",
			dependencies: [],
			path: "Main/Source",
			exclude: [
				"Demo",
				"Test",
				"Cartfile.private"
			]

		),
		.testTarget(
			name: "PinLayoutTests",
			dependencies: ["PinLayout", "SwiftHamcrest"],
			path: "Test/Source"
		),
	]
)
