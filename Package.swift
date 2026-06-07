// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "CodexTokenDashboard",
    platforms: [
        .macOS(.v14)
    ],
    products: [
        .executable(name: "CodexTokenDashboard", targets: ["CodexTokenDashboard"])
    ],
    targets: [
        .executableTarget(
            name: "CodexTokenDashboard",
            path: "Sources/CodexTokenDashboard"
        )
    ]
)

