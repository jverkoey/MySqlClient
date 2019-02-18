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
@testable import MySqlConnector
import XCTest

class HandshakeDecodingTests: XCTestCase {

  func testThrowsWithEmptyData() throws {
    // Given
    let data = Data()
    let decoder = BinaryDataDecoder()

    // Then
    XCTAssertThrowsError(try decoder.decode(Packet<Handshake>.self, from: data)) { error in
      switch error {
      case BinaryDecodingError.dataCorrupted(let context):
        XCTAssertEqual(context.debugDescription, "Not enough bytes available to decode. Requested 3, but received 0.")
      default:
        XCTFail("Unexpected error \(String(describing: error))")
      }
    }
  }

  func testThrowsWithUnsupportedProtocol() throws {
    // Given
    let protocolVersion = ProtocolVersion.v9.rawValue.bytes
    let payloadData = protocolVersion
    let packetHeader = UInt32(payloadData.count).bytes[0...2] + [0]
    let data = Data(packetHeader + payloadData)
    let decoder = BinaryDataDecoder()

    // Then
    XCTAssertThrowsError(try decoder.decode(Packet<Handshake>.self, from: data)) { error in
      switch error {
      case HandshakeDecodingError.unsupportedProtocol(let context):
        XCTAssertEqual(context.debugDescription, "Only protocol v10 is presently supported, but v9 was found instead.")
      default:
        XCTFail("Unexpected error \(String(describing: error))")
      }
    }
  }

  func testShortv10HandshakeSucceeds() throws {
    // Given
    let protocolVersion = ProtocolVersion.v10
    let serverVersion = "unit.tests"
    let connectionIdentifier: UInt32 = 123
    let firstAuthPluginData = [UInt8](repeating: 0xf1, count: 8)
    let capabilityFlags: CapabilityFlags = [.protocol41]
    var payloadData: [UInt8] = []
    payloadData.append(contentsOf: protocolVersion.rawValue.bytes + serverVersion.utf8 + [0])
    payloadData.append(contentsOf: connectionIdentifier.bytes)
    payloadData.append(contentsOf: firstAuthPluginData + [0])
    payloadData.append(contentsOf: capabilityFlags.rawValue.bytes.prefix(2))

    let packetHeader = UInt32(payloadData.count).bytes[0...2] + [0]
    let data = Data(packetHeader + payloadData)
    let decoder = BinaryDataDecoder()

    // Then
    let packet = try decoder.decode(Packet<Handshake>.self, from: data)

    XCTAssertEqual(packet.payload.protocolVersion, .v10)
  }
}
