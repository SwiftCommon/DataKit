// swift-tools-version:4.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DataKit",
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "DataKit",
            targets: ["DataKit"]
        ),
        .executable(
            name: "DataKitBenchmark",
            targets: ["DataKitBenchmark"]
        )
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/Quick/Nimble", .branch("master"))
    ],
    targets: [
        .target(
            name: "DataKit",
            dependencies: []
        ),
        .testTarget(
            name: "DataKitTests",
            dependencies: ["DataKit", "Nimble"]
        ),
        .target(
            name: "DataKitBenchmark",
            dependencies: ["DataKit"]
        )
    ],
    swiftLanguageVersions: [.v4, .v4_2]
)
