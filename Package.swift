// swift-tools-version:4.2
// Copyright 2019-present the MySqlConnector authors. All Rights Reserved.
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
  name: "MySqlConnector",
  products: [
    .executable(
      name: "MySqlClient",
      targets: ["MySqlClient"]
    ),
    .library(
      name: "MySqlConnector",
      targets: ["MySqlConnector"]
    ),
    .library(
      name: "SocketIterator",
      targets: ["SocketIterator"]
    ),
    .library(
      name: "CustomStringConvertible+description",
      targets: ["CustomStringConvertible+description"]
    )
  ],
  dependencies: [
    .package(url: "https://github.com/IBM-Swift/BlueSocket.git", .upToNextMajor(from: "1.0.0"))
  ],
  targets: [
    .target(
      name: "MySqlClient",
      dependencies: [
        "MySqlConnector"
      ]
    ),
    .target(
      name: "MySqlConnector",
      dependencies: [
        "CustomStringConvertible+description",
        "Data+xored",
        "FixedWidthInteger+bytes",
        "IteratorProtocol+next",
        "SocketIterator"
      ]
    ),

    .testTarget(
      name: "MySqlConnectorTests",
      dependencies: ["MySqlConnector"]
    ),

    // Foundation extensions

    .target(
      name: "CustomStringConvertible+description",
      dependencies: []
    ),
    .testTarget(
      name: "CustomStringConvertible+descriptionTests",
      dependencies: ["CustomStringConvertible+description"]
    ),

    .target(
      name: "Data+xored",
      dependencies: []
    ),
    .testTarget(
      name: "Data+xoredTests",
      dependencies: ["Data+xored"]
    ),

    .target(
      name: "FixedWidthInteger+bytes",
      dependencies: []
    ),
    .testTarget(
      name: "FixedWidthInteger+bytesTests",
      dependencies: ["FixedWidthInteger+bytes"]
    ),

    .target(
      name: "IteratorProtocol+next",
      dependencies: []
    ),
    .testTarget(
      name: "IteratorProtocol+nextTests",
      dependencies: ["IteratorProtocol+next"]
    ),

    // Socket extensions

    .target(
      name: "SocketIterator",
      dependencies: [
        "Socket"
      ]
    )
  ]
)
