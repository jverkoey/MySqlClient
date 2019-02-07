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

import XCTest
@testable import MySqlConnector

private enum SomeEnum: UInt8, Decodable {
  case value1 = 0x00
}

private struct Payload: Decodable {
  let unsignedValue: UInt32
  let enumValue: SomeEnum
  let signedValue: Int32

  init(from decoder: Decoder) throws {
    var container = try decoder.unkeyedContainer()
    self.unsignedValue = try container.decode(type(of: unsignedValue))
    self.enumValue = try container.decode(type(of: enumValue))
    self.signedValue = try container.decode(type(of: signedValue))
  }
}

class PacketDecodingTests: XCTestCase {

  func testThrowsWithEmptyData() throws {
    // Given
    let data = Data()
    let decoder = PacketDecoder()

    // Then
    XCTAssertThrowsError(try decoder.decode(Payload.self, from: data.makeIterator())) { error in
      switch error {
      case DecodingError.dataCorrupted(let context):
        XCTAssertEqual(context.debugDescription, "Unable to read packet length.")
      default:
        XCTFail("Unexpected error \(String(describing: error))")
      }
    }
  }

  func testThrowsWithPartialPacketHeader() throws {
    // Given
    let packetHeader = UInt32(4).bytes[0...2]
    let data = Data(packetHeader)
    let decoder = PacketDecoder()

    // Then
    XCTAssertThrowsError(try decoder.decode(Payload.self, from: data.makeIterator())) { error in
      switch error {
      case DecodingError.dataCorrupted(let context):
        XCTAssertEqual(context.debugDescription, "Unable to read packet sequence number.")
      default:
        XCTFail("Unexpected error \(String(describing: error))")
      }
    }
  }

  func testThrowsWithMissingPayload() throws {
    // Given
    let packetHeader = UInt32(4).bytes[0...2] + [0]
    let data = Data(packetHeader)
    let decoder = PacketDecoder()

    // Then
    XCTAssertThrowsError(try decoder.decode(Payload.self, from: data.makeIterator())) { error in
      switch error {
      case DecodingError.dataCorrupted(let context):
        XCTAssertEqual(context.debugDescription, "Packet is missing payload data.")
      default:
        XCTFail("Unexpected error \(String(describing: error))")
      }
    }
  }

  func testThrowsWithPartialPayload() throws {
    // Given
    let payloadData = UInt32(0x012345678).bytes
    let packetHeader = UInt32(8).bytes[0...2] + [0]
    let data = Data(packetHeader + payloadData)
    let decoder = PacketDecoder()

    // Then
    XCTAssertThrowsError(try decoder.decode(Payload.self, from: data.makeIterator())) { error in
      switch error {
      case DecodingError.dataCorrupted(let context):
        XCTAssertEqual(context.debugDescription, "Packet is missing payload data.")
      default:
        XCTFail("Unexpected error \(String(describing: error))")
      }
    }
  }

  func testSuccess() throws {
    // Given
    let payloadData = UInt32(0x012345678).bytes + UInt8(0x00).bytes + Int32(-500).bytes
    let packetHeader = UInt32(payloadData.count).bytes[0...2] + [0]
    let data = Data(packetHeader + payloadData)
    let decoder = PacketDecoder()

    // When
    let payload = try decoder.decode(Payload.self, from: data.makeIterator())

    // Then
    XCTAssertEqual(payload.unsignedValue, 0x012345678)
    XCTAssertEqual(payload.enumValue, .value1)
    XCTAssertEqual(payload.signedValue, -500)
  }
}
