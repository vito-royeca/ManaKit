// swift-tools-version:6.1

import PackageDescription

let package = Package(
  name: "ManaKit",
  platforms: [
    .iOS(.v18),
    .macOS(.v14),
  ],
  products: [
    .library(name: "ManaKit", targets: ["ManaKit"]),
  ],
  dependencies: [
    .package(url: "https://github.com/apollographql/apollo-ios.git", .upToNextMajor(from: "2.1.0")),
    .package(url: "https://github.com/ZipArchive/ZipArchive.git", from: "2.5.5"),
  ],
  targets: [
    .target(
      name: "ManaKit",
      dependencies: [
        .product(name: "Apollo", package: "apollo-ios"),
        .product(name: "ZipArchive", package: "ZipArchive"),
      ],
      resources: [.process("Resources")]
    ),
  ],
  swiftLanguageModes: [.v6, .v5]
)
