// swift-tools-version:4.2
// Copyright 2019-present the MySqlClient authors. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import PackageDescription

let package = Package(
  name: "MySqlClient",
  products: [
    .executable(name: "bootstrap", targets: ["bootstrap"]),
    .library(
      name: "MySqlClient",
      targets: ["MySqlClient"]
    )
  ],
  dependencies: [
    .package(url: "https://github.com/IBM-Swift/BlueSocket.git", .upToNextMajor(from: "1.0.0")),
    .package(url: "https://github.com/IBM-Swift/BlueCryptor.git", .upToNextMajor(from: "1.0.0")),
    .package(url: "https://github.com/jverkoey/BinaryCodable.git", .upToNextMinor(from: "0.3.0")),
    .package(url: "https://github.com/apple/swift-argument-parser", .upToNextMinor(from: "0.2.0")),
  ],
  targets: [
    .target(
      name: "bootstrap",
      dependencies: [
        .product(name: "ArgumentParser", package: "swift-argument-parser")
      ]
    ),

    .target(
      name: "MySqlClient",
      dependencies: [
        "Cryptor",
        "BinaryCodable",
        "Socket",
      ]
    ),
    .testTarget(
      name: "MySqlClientTests",
      dependencies: ["MySqlClient"]
    ),
  ]
)
