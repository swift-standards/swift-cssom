// swift-tools-version:6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "swift-cssom",
    platforms: [
        .macOS(.v15),
        .iOS(.v18),
        .tvOS(.v18),
        .watchOS(.v11),
        .macCatalyst(.v18)
    ],
    products: [
        .library(
            name: "W3C CSSOM",
            targets: ["W3C CSSOM"]
        )
    ],
    targets: [
        .target(
            name: "W3C CSSOM",
            dependencies: []
        ),
        .testTarget(
            name: "W3C CSSOM Tests",
            dependencies: ["W3C CSSOM"]
        )
    ],
    swiftLanguageModes: [.v6]
)
