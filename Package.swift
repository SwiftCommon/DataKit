// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "DataKit",
    platforms: [
      .macOS(.v10_12), .iOS(.v9), .tvOS(.v9), .watchOS(.v3)
    ],
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
        .package(url: "https://github.com/Quick/Nimble", "9.0.0" ..< "10.0.0")
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
    swiftLanguageVersions: [.v5]
)
