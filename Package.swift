// swift-tools-version: 5.6

import PackageDescription

let package = Package(
  name: "DelegateExtension",
  platforms: [.iOS(.v14), .watchOS(.v6), .tvOS(.v13), .macOS(.v10_15)],
  products: [
    .library(
      name: "DelegateExtension",
      targets: ["DelegateExtension"]
    ),
  ],
  dependencies: [
    .package(url: "https://github.com/tjerwinchen/DelegateFoundation", from: "0.0.2"),
  ],
  targets: [
    .target(
      name: "DelegateExtension",
      dependencies: [
        "DelegateFoundation",
      ]
    ),
  ]
)
