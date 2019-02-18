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

import BinaryCodable
import Cryptor
@testable import MySqlConnector
import XCTest

class HandshakeResponseEncodingTests: XCTestCase {

  func testSucceedsWithNoCapabilities() throws {
    // Given
    let response = HandshakeResponse(username: "username",
                                     password: "password",
                                     database: "database",
                                     capabilityFlags: [],
                                     authPluginData: Data(repeating: 0xf1, count: 20),
                                     authPluginName: "plugin")
    let encoder = BinaryDataEncoder()

    // When
    let data = try encoder.encode(response)

    // Then
    let payloadDataPart1 = response.capabilityFlags.rawValue.bytes
      + UInt32(0).bytes
      + CharacterSet.utf8mb4.rawValue.bytes
      + [UInt8](repeating: 0, count: 23)
    let payloadDataPart2 = response.username.utf8 + [0]
    XCTAssertEqual([UInt8](data), payloadDataPart1 + payloadDataPart2)
  }

  func testSucceedsWithAllCapabilities() throws {
    // Given
    let response = HandshakeResponse(username: "username",
                                     password: "password",
                                     database: "database",
                                     capabilityFlags: [.secureConnection, .connectWithDb, .pluginAuth],
                                     authPluginData: Data(repeating: 0xf1, count: 20),
                                     authPluginName: "plugin")
    let encoder = BinaryDataEncoder()

    // When
    let data = try encoder.encode(response)

    // Then
    let payloadDataPart1 = response.capabilityFlags.rawValue.bytes
      + UInt32(0).bytes
      + CharacterSet.utf8mb4.rawValue.bytes
      + [UInt8](repeating: 0, count: 23)
    let payloadDataPart2 = response.username.utf8 + [0]
    let authDataPart1: Data = CryptoUtils.data(fromHex: response.password.sha1)
    let authDataPart2: Data = (response.authPluginData + CryptoUtils.data(fromHex: response.password.sha1).sha1).sha1
    let authData = authDataPart1.xored(with: authDataPart2)
    let payloadDataPart3 = [UInt8(authData.count)] + authData
    let payloadDataPart4 = response.database!.utf8 + [0] + response.authPluginName!.utf8 + [0]
    XCTAssertEqual([UInt8](data), payloadDataPart1 + payloadDataPart2 + payloadDataPart3 + payloadDataPart4)
  }
}
