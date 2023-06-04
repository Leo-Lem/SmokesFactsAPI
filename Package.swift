// swift-tools-version: 5.8

import PackageDescription

let package = Package(
  name: "FactsAPI",
  platforms: [.macOS(.v13)]
)

// MARK: - (DEPENDENCIES)

package.dependencies = [
  .package(url: "https://github.com/vapor/vapor", from: "4.76.0"),
  .package(url: "https://github.com/pointfreeco/swift-dependencies", from: "0.5.1")
]

// MARK: - (TARGETS)

let api: Target = .executableTarget(
  name: package.name,
  dependencies: [
    .product(name: "Vapor", package: "vapor"),
    .product(name: "Dependencies", package: "swift-dependencies")
  ],
  path: "src"
)

let apiTests: Target = .testTarget(
  name: "\(api.name)Tests",
  dependencies: [
    .target(name: api.name),
    .product(name: "XCTVapor", package: "vapor")
  ],
  path: "test",
  exclude: [" Unit.xctestplan"]
)

package.targets = [api, apiTests]

// MARK: - (PRODUCTS)

package.products = [.executable(name: api.name, targets: [api.name])]
