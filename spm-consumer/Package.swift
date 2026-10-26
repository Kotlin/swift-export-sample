// swift-tools-version: 6.0
import PackageDescription

// A plain Swift package consuming the Swift package exported by `./gradlew :shared:exportDebugSwiftPackage`
let package = Package(
    name: "SpmConsumer",
    platforms: [
        // Swift export requires at least iOS 18 / macOS 15
        .macOS(.v15),
        .iOS(.v18),
    ],
    dependencies: [
        // Add `outputDirectory/Debug` (or `/Release`) as a local package, not `outputDirectory` itself
        .package(name: "Shared", path: "../shared/SwiftPackage/Debug"),
    ],
    targets: [
        .executableTarget(
            name: "SpmConsumer",
            dependencies: [.product(name: "SharedLibrary", package: "Shared")],
            swiftSettings: [.swiftLanguageMode(.v5)]
        ),
        .testTarget(
            name: "SwiftExportTests",
            dependencies: [.product(name: "SharedLibrary", package: "Shared")],
            swiftSettings: [.swiftLanguageMode(.v5)]
        ),
    ]
)
