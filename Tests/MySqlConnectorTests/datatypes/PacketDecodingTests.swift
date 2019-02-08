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

private struct Payload: Codable {
  let unsignedValue: UInt32
  let enumValue: SomeEnum
  let stringValue: String
  let signedValue: Int32

  init(from decoder: Decoder) throws {
    var container = try decoder.unkeyedContainer()
    self.unsignedValue = try container.decode(type(of: unsignedValue))
    self.enumValue = try container.decode(type(of: enumValue))
    self.stringValue = try container.decode(type(of: stringValue))
    self.signedValue = try container.decode(type(of: signedValue))
  }

  func encode(to encoder: Encoder) throws {
    preconditionFailure("Unimplemented")
  }
}

class PacketDecodingTests: XCTestCase {

  func testThrowsWithEmptyData() throws {
    // Given
    let data = Data()
    let decoder = BinaryStreamDecoder()

    // Then
    XCTAssertThrowsError(try decoder.decode(Packet<Payload>.self, from: data.makeIterator())) { error in
      switch error {
      case DecodingError.dataCorrupted(let context):
        XCTAssertEqual(context.debugDescription, "Not enough data to parse a UInt8.")
      default:
        XCTFail("Unexpected error \(String(describing: error))")
      }
    }
  }

  func testThrowsWithPartialPacketHeader() throws {
    // Given
    let packetHeader = UInt32(4).bytes[0...2]
    let data = Data(packetHeader)
    let decoder = BinaryStreamDecoder()

    // Then
    XCTAssertThrowsError(try decoder.decode(Packet<Payload>.self, from: data.makeIterator())) { error in
      switch error {
      case DecodingError.dataCorrupted(let context):
        XCTAssertEqual(context.debugDescription, "Not enough data to parse a UInt8.")
      default:
        XCTFail("Unexpected error \(String(describing: error))")
      }
    }
  }

  func testThrowsWithMissingPayload() throws {
    // Given
    let packetHeader = UInt32(4).bytes[0...2] + [0]
    let data = Data(packetHeader)
    let decoder = BinaryStreamDecoder()

    // Then
    XCTAssertThrowsError(try decoder.decode(Packet<Payload>.self, from: data.makeIterator())) { error in
      switch error {
      case DecodingError.dataCorrupted(let context):
        XCTAssertEqual(context.debugDescription, "Not enough data to parse a UInt32.")
      default:
        XCTFail("Unexpected error \(String(describing: error))")
      }
    }
  }

  func testThrowsWithPartialPayload() throws {
    // Given
    let payloadData = UInt32(0x012345678).bytes
    let packetHeader = UInt32(4).bytes[0...2] + [0]
    let data = Data(packetHeader + payloadData)
    let decoder = BinaryStreamDecoder()

    // Then
    XCTAssertThrowsError(try decoder.decode(Packet<Payload>.self, from: data.makeIterator())) { error in
      switch error {
      case DecodingError.dataCorrupted(let context):
        XCTAssertEqual(context.debugDescription, "Not enough data to parse a UInt8.")
      default:
        XCTFail("Unexpected error \(String(describing: error))")
      }
    }
  }

  func testThrowsWithPartialPayloadSize() throws {
    // Given
    let value1 = UInt32(0x012345678).bytes
    let value2 = UInt8(0x00).bytes
    let value3 = "Test".utf8 + [0]
    let value4 = Int32(-500).bytes
    let payloadData = value1 + value2 + value3 + value4
    let packetHeaderSize: UInt32 = 2
    let packetHeader = packetHeaderSize.bytes[0...2] + [0]
    let data = Data(packetHeader + payloadData)
    let decoder = BinaryStreamDecoder()

    // Then
    XCTAssertThrowsError(try decoder.decode(Packet<Payload>.self, from: data.makeIterator())) { error in
      switch error {
      case DecodingError.dataCorrupted(let context):
        XCTAssertEqual(context.debugDescription, "Not enough data to parse a UInt32.")
      default:
        XCTFail("Unexpected error \(String(describing: error))")
      }
    }
  }

  func testThrowsWithNoNullTerminator() throws {
    // Given
    let value1 = UInt32(0x012345678).bytes
    let value2 = UInt8(0x00).bytes
    let value3 = "Test".utf8
    let value4 = Int32(-500).bytes
    let payloadData = value1 + value2 + value3 + value4
    let packetHeader = UInt32(payloadData.count).bytes[0...2] + [0]
    let data = Data(packetHeader + payloadData)
    let decoder = BinaryStreamDecoder()

    // Then
    XCTAssertThrowsError(try decoder.decode(Packet<Payload>.self, from: data.makeIterator())) { error in
      switch error {
      case DecodingError.dataCorrupted(let context):
        XCTAssertEqual(context.debugDescription, "Did not find null terminator for string.")
      default:
        XCTFail("Unexpected error \(String(describing: error))")
      }
    }
  }

  func testSuccess() throws {
    // Given
    let value1 = UInt32(0x012345678).bytes
    let value2 = UInt8(0x00).bytes
    let value3 = "Test".utf8 + [0]
    let value4 = Int32(-500).bytes
    let payloadData = value1 + value2 + value3 + value4
    let packetHeader = UInt32(payloadData.count).bytes[0...2] + [0]
    let data = Data(packetHeader + payloadData)
    let decoder = BinaryStreamDecoder()

    // When
    let packet = try decoder.decode(Packet<Payload>.self, from: data.makeIterator())

    // Then
    XCTAssertEqual(packet.payload.unsignedValue, 0x012345678)
    XCTAssertEqual(packet.payload.enumValue, .value1)
    XCTAssertEqual(packet.payload.stringValue, "Test")
    XCTAssertEqual(packet.payload.signedValue, -500)
  }
}
