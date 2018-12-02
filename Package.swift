// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "xcstats",
    dependencies: [
        .package(url: "https://github.com/tuist/xcodeproj.git", .upToNextMajor(from: "6.2.0")),
    ],
    targets: [
        .target(
            name: "xcstats",
            dependencies: ["xcodeproj"]),
    ]
)
