// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "xcstats",
    dependencies: [
        .package(url: "git@github.com:apple/swift-package-manager.git", .exact("0.3.0")),
        .package(url: "git@github.com:apple/swift-syntax.git", .exact("0.40200.0")),
        .package(url: "git@github.com:tuist/xcodeproj.git", .exact("6.3.0"))
    ],
    targets: [
        .target(
            name: "xcstats",
            dependencies: [
                "SwiftSyntax",
                "Utility",
                "xcodeproj"
            ]
        )
    ]
)
