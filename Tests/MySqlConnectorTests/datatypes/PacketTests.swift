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

private struct SimplePayload: PayloadReader {
  let value: UInt32

  init(payloadData data: Data, capabilityFlags: CapabilityFlags) throws {
    if data.isEmpty {
      throw PayloadReaderError.unexpectedEmptyPayload(kind: type(of: self))
    }

    if data.count < 4 {
      throw PayloadReaderError.unexpectedEndOfPayload(kind: type(of: self), context: "UInt32 value")
    }

    self.value = data[0...3].withUnsafeBytes { (ptr: UnsafePointer<UInt32>) -> UInt32 in
      return ptr.pointee
    }
  }
}

class PacketTests: XCTestCase {

  // MARK: Packet errors

  func testThrowsPacketErrorWithEmptyPacket() throws {
    // Given
    let data = Data()

    // Then
    XCTAssertThrowsError(try Packet<SimplePayload>(iterator: data.makeIterator(), capabilityFlags: .init(rawValue: 0))) { error in
      switch error {
      case PacketError.unexpectedEndOfPacket(let payloadType):
        XCTAssertTrue(payloadType.self == SimplePayload.self)
      default:
        XCTFail("Unexpected error type \(error)")
      }
    }
  }

  func testThrowsPacketErrorWithPartialPacketHeader() throws {
    // Given
    let data = Data(UInt32(0).bytes[0...2])

    // Then
    XCTAssertThrowsError(try Packet<SimplePayload>(iterator: data.makeIterator(), capabilityFlags: .init(rawValue: 0))) { error in
      switch error {
      case PacketError.unexpectedEndOfPacket(let payloadType):
        XCTAssertTrue(payloadType.self == SimplePayload.self)
      default:
        XCTFail("Unexpected error type \(error)")
      }
    }
  }

  // MARK: Payload errors

  func testThrowsPayloadErrorWithEmptyPayload() throws {
    // Given
    let data = Data(UInt32(0).bytes[0...2] + [0])

    // Then
    XCTAssertThrowsError(try Packet<SimplePayload>(iterator: data.makeIterator(), capabilityFlags: .init(rawValue: 0))) { error in
      XCTAssertTrue(error is PayloadReaderError)
      switch error {
      case PayloadReaderError.unexpectedEmptyPayload(let payloadType):
        XCTAssertTrue(payloadType.self == SimplePayload.self)
      default:
        XCTFail("Unexpected error type \(error)")
      }
    }
  }

  func testThrowsPayloadErrorWithPartialPayload() throws {
    // Given
    let data = Data(UInt32(1).bytes[0...2] + [0] + [0])

    // Then
    XCTAssertThrowsError(try Packet<SimplePayload>(iterator: data.makeIterator(), capabilityFlags: .init(rawValue: 0))) { error in
      XCTAssertTrue(error is PayloadReaderError)
      switch error {
      case PayloadReaderError.unexpectedEndOfPayload(let payloadType, let context):
        XCTAssertTrue(payloadType.self == SimplePayload.self)
        XCTAssertEqual(context, "UInt32 value")
      default:
        XCTFail("Unexpected error type \(error)")
      }
    }
  }

  // MARK: Payload success

  func testSucceedsWithFullPayload() throws {
    // Given
    let packetHeader = UInt32(4).bytes[0...2] + [0]
    let payload = UInt32(0x012345678).bytes
    let data = Data(packetHeader + payload)

    // When
    let packet = try Packet<SimplePayload>(iterator: data.makeIterator(), capabilityFlags: .init(rawValue: 0))

    // Then
    XCTAssertEqual(packet.content.value, 0x012345678)
  }
}
