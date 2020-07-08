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

class LengthEncodedIntegerDecodingTests: XCTestCase {

  func testThrowsWithEmptyData() throws {
    // Given
    let data = Data()
    let decoder = BinaryDataDecoder()

    // Then
    XCTAssertThrowsError(try decoder.decode(LengthEncodedInteger.self, from: data)) { error in
      switch error {
      case BinaryDecodingError.dataCorrupted(let context):
        XCTAssertEqual(context.debugDescription,
                       "Not enough data to create a a type of UInt8. Needed: 1. Received: 0.")
      default:
        XCTFail("Unexpected error \(String(describing: error))")
      }
    }
  }

  func test0x00Through0xfbIsOneByteInteger() throws {
    for byte: UInt8 in 0x00...0xfb {
      // Given
      let data = Data([byte])
      let decoder = BinaryDataDecoder()

      // When
      let integer = try decoder.decode(LengthEncodedInteger.self, from: data)

      // Then
      XCTAssertEqual(integer.value, UInt64(byte))
      XCTAssertEqual(integer.length, 1)
    }
  }

  func test0xfcIsTwoByteInteger() throws {
    for bit in 0..<16 {
      // Given
      let value = UInt16(1) << bit
      let data = Data([0xfc] + value.bytes)
      let decoder = BinaryDataDecoder()

      // When
      let integer = try decoder.decode(LengthEncodedInteger.self, from: data)

      // Then
      XCTAssertEqual(integer.value, UInt64(value))
      XCTAssertEqual(integer.length, 3)
    }
  }

  func test0xfdIsThreeByteInteger() throws {
    for bit in 0..<24 {
      // Given
      let value = UInt32(1) << bit
      let data = Data([0xfd] + value.bytes[0...2])
      let decoder = BinaryDataDecoder()

      // When
      let integer = try decoder.decode(LengthEncodedInteger.self, from: data)

      // Then
      XCTAssertEqual(integer.value, UInt64(value))
      XCTAssertEqual(integer.length, 4)
    }
  }

  func test0xfeIsEightByteInteger() throws {
    for bit in 0..<64 {
      // Given
      let value = UInt64(1) << bit
      let data = Data([0xfe] + value.bytes)
      let decoder = BinaryDataDecoder()

      // When
      let integer = try decoder.decode(LengthEncodedInteger.self, from: data)

      // Then
      XCTAssertEqual(integer.value, value)
      XCTAssertEqual(integer.length, 9)
    }
  }

  // MARK: Values that look like length-encoded integers, but aren't

  func test0xffThrows() throws {
    // Given
    let data = Data([0xff])
    let decoder = BinaryDataDecoder()

    // Then
    // Is likely an error packet
    // https://dev.mysql.com/doc/internals/en/integer.html#packet-Protocol::LengthEncodedInteger
    XCTAssertThrowsError(try decoder.decode(LengthEncodedInteger.self, from: data)) { error in
      switch error {
      case BinaryDecodingError.dataCorrupted(let context):
        XCTAssertEqual(context.debugDescription, "Not a length-encoded integer.")
      default:
        XCTFail("Unexpected error \(String(describing: error))")
      }
    }
  }

  func test0xfeThrowsWithLessThanNineBytesOfData() throws {
    for extraBytes in 0...7 {
      // Given
      let data = Data([0xfe] + [UInt8](repeating: 0, count: extraBytes))
      let decoder = BinaryDataDecoder()

      // Then
      // Is more likely an EOF packet.
      // https://dev.mysql.com/doc/internals/en/integer.html#packet-Protocol::LengthEncodedInteger
      XCTAssertThrowsError(try decoder.decode(LengthEncodedInteger.self, from: data)) { error in
        switch error {
        case BinaryDecodingError.dataCorrupted(let context):
          XCTAssertEqual(context.debugDescription,
                         "Not enough data to create a a type of UInt64. Needed: 8. Received: \(extraBytes).")
        default:
          XCTFail("Unexpected error \(String(describing: error))")
        }
      }
    }
  }
}
