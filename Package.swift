// swift-tools-version:5.3
import PackageDescription

let package = Package(
	name: "PinLayout",
	platforms: [
		.iOS(.v14)
	],
	products: [
		.library(name: "PinLayout", targets: ["PinLayout"])
	],
	dependencies: [
		.package(url: "https://github.com/nschum/SwiftHamcrest/", .upToNextMajor(from: "2.2.0") )
	],
	targets: [
		.target(
			name: "PinLayout",
			dependencies: [],
			path: "PinLayout",
			sources: [
				"Main/Source"
			]
		),
		.testTarget(
			name: "PinLayoutTests",
			dependencies: [
				"PinLayout",
				.product(name: "Hamcrest", package: "SwiftHamcrest"),
				.product(name: "HamcrestSwiftTesting", package: "SwiftHamcrest")
			],
			path: "PinLayout",
			sources: [
				"Test/Source"
			]
		)
	]
)
