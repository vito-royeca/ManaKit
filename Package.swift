// swift-tools-version:5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ManaKit",
    platforms: [
        .macOS(.v12),
        .iOS(.v15)
    ],
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "ManaKit",
            targets: ["ManaKit"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        //.package(url: /* package url */, from: "1.0.0"),
//        .package(url: "https://github.com/tid-kijyun/Kanna.git", from: "5.2.2"),
        //.package(url: "https://github.com/kishikawakatsumi/KeychainAccess.git", from: "4.1.0"),
        .package(url: "https://github.com/ZipArchive/ZipArchive.git", from: "2.5.5"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "ManaKit",
            dependencies: [
                "ZipArchive"
            ],
            resources: [
                .process("Resources")
            ]
        ),
        .testTarget(
            name: "ManaKitTests",
            dependencies: ["ManaKit"],
            path: "Tests"
        )
    ],
    swiftLanguageVersions: [.v5]
)
