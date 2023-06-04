// swift-tools-version: 5.8

import PackageDescription

let package = Package(
  name: "FactsAPI",
  platforms: [.macOS(.v13)]
)

// MARK: - (DEPENDENCIES)

let vapor = (name: "Vapor", package: "vapor")

package.dependencies = [.package(url: "https://github.com/vapor/\(vapor.package)", from: "4.76.0")]

// MARK: - (TARGETS)

let api: Target = .executableTarget(
  name: "FactsAPI",
  dependencies: [
    .product(name: vapor.name, package: vapor.package)
  ],
  path: "src"
)

let apiTests: Target = .testTarget(
  name: "\(api.name)Tests",
  dependencies: [
    .target(name: api.name),
    .product(name: "XCTVapor", package: vapor.package)
  ],
  path: "test",
  exclude: [" Unit.xctestplan"]
)

package.targets = [api, apiTests]

// MARK: - (PRODUCTS)

package.products = [.executable(name: api.name, targets: [api.name])]
