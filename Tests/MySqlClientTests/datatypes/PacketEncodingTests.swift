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

import BinaryCodable
@testable import MySqlClient
import XCTest

private enum SomeEnum: UInt8, BinaryEncodable {
  case value1 = 0x00
}

private struct Payload: BinaryEncodable {
  let unsignedValue: UInt32
  let enumValue: SomeEnum
  let stringValue: String
  let signedValue: Int32

  func encode(to encoder: BinaryEncoder) throws {
    var container = encoder.container()
    try container.encode(unsignedValue)
    try container.encode(enumValue)
    try container.encode(stringValue, encoding: .utf8, terminator: 0)
    try container.encode(signedValue)
  }
}

class PacketEncodingTests: XCTestCase {

  func testSucceeds() throws {
    // Given
    let payload = Payload(unsignedValue: 1234, enumValue: .value1, stringValue: "Some string", signedValue: -123)
    let encoder = BinaryDataEncoder()

    // When
    let data = try encoder.encode(payload)

    // Then
    XCTAssertEqual([UInt8](data),
                   payload.unsignedValue.bytes
                    + payload.enumValue.rawValue.bytes
                    + payload.stringValue.utf8 + [0]
                    + payload.signedValue.bytes
    )
  }

  func testSucceedsAsPacket() throws {
    // Given
    let payload = Payload(unsignedValue: 1234, enumValue: .value1, stringValue: "Some string", signedValue: -123)

    // When
    let data = try payload.encodedAsPacket(sequenceNumber: 0)

    // Then
    let packetHeader = UInt32(21).bytes[0...2] + [0]
    let payloadData = payload.unsignedValue.bytes
      + payload.enumValue.rawValue.bytes
      + payload.stringValue.utf8 + [0]
      + payload.signedValue.bytes
    XCTAssertEqual([UInt8](data), packetHeader + payloadData)
  }
}
