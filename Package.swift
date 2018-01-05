// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "xcstats",
    dependencies: [
        .package(url: "https://github.com/xcodeswift/xcproj.git", .upToNextMajor(from: "1.8.0")),
    ],
    targets: [
        .target(
            name: "xcstats",
            dependencies: ["xcproj"]),
    ]
)
