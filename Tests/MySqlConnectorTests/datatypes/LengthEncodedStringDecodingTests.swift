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

class LengthEncodedStringDecodingTests: XCTestCase {

  func testNilWithEmptyData() throws {
    // Given
    let data = Data()
    let decoder = BinaryDataDecoder()

    // Then
    XCTAssertThrowsError(try decoder.decode(LengthEncodedString.self, from: data)) { error in
      switch error {
      case BinaryDecodingError.dataCorrupted(let context):
        XCTAssertEqual(context.debugDescription,
                       "Not enough data to create a a type of UInt8. Needed: 1. Received: 0.")
      default:
        XCTFail("Unexpected error \(String(describing: error))")
      }
    }
  }

  func testEmptyString() throws {
    // Given
    let data = Data([0x00])
    let decoder = BinaryDataDecoder()

    // When
    let lengthEncodedString = try decoder.decode(LengthEncodedString.self, from: data)

    // Then
    XCTAssertEqual(lengthEncodedString.value, "")
  }

  func testOneByteString() throws {
    // Given
    let string = String(repeating: "A", count: 0xfb)
    let data = [UInt8(string.lengthOfBytes(using: .utf8))] + string.utf8
    let decoder = BinaryDataDecoder()

    // When
    let lengthEncodedString = try decoder.decode(LengthEncodedString.self, from: data)

    // Then
    XCTAssertEqual(lengthEncodedString.value, string)
    XCTAssertEqual(lengthEncodedString.length, UInt64(string.lengthOfBytes(using: .utf8)) + 1)
  }

  func testTwoByteStringMin() throws {
    // Given
    let string = String(repeating: "A", count: 0xfc)
    let data = [0xfc] + UInt16(string.lengthOfBytes(using: .utf8)).bytes + string.utf8
    let decoder = BinaryDataDecoder()

    // When
    let lengthEncodedString = try decoder.decode(LengthEncodedString.self, from: data)

    // Then
    XCTAssertEqual(lengthEncodedString.value, string)
    XCTAssertEqual(lengthEncodedString.length, UInt64(string.lengthOfBytes(using: .utf8)) + 3)
  }

  func testTwoByteStringMax() throws {
    // Given
    let string = String(repeating: "A", count: 0xFFFF)
    let data = [0xfc] + UInt16(string.lengthOfBytes(using: .utf8)).bytes + string.utf8
    let decoder = BinaryDataDecoder()

    // When
    let lengthEncodedString = try decoder.decode(LengthEncodedString.self, from: data)

    // Then
    XCTAssertEqual(lengthEncodedString.value, string)
    XCTAssertEqual(lengthEncodedString.length, UInt64(string.lengthOfBytes(using: .utf8)) + 3)
  }

  func testThreeByteStringMin() throws {
    // Given
    let string = String(repeating: "A", count: 0x10000)
    let data = [0xfd] + UInt32(string.lengthOfBytes(using: .utf8)).bytes[0...2] + string.utf8
    let decoder = BinaryDataDecoder()

    // When
    let lengthEncodedString = try decoder.decode(LengthEncodedString.self, from: data)

    // Then
    XCTAssertEqual(lengthEncodedString.value, string)
    XCTAssertEqual(lengthEncodedString.length, UInt64(string.lengthOfBytes(using: .utf8)) + 4)
  }

  func testThreeByteStringMax() throws {
    // Given
    let string = String(repeating: "A", count: 0xFFFFFF)
    let data = [0xfd] + UInt32(string.lengthOfBytes(using: .utf8)).bytes[0...2] + string.utf8
    let decoder = BinaryDataDecoder()

    // When
    let lengthEncodedString = try decoder.decode(LengthEncodedString.self, from: data)

    // Then
    XCTAssertEqual(lengthEncodedString.value, string)
    XCTAssertEqual(lengthEncodedString.length, UInt64(string.lengthOfBytes(using: .utf8)) + 4)
  }

  func testEightByteStringMin() throws {
    // Given
    let string = String(repeating: "A", count: 0x1000000)
    let data = [0xfe] + UInt64(string.lengthOfBytes(using: .utf8)).bytes + string.utf8
    let decoder = BinaryDataDecoder()

    // When
    let lengthEncodedString = try decoder.decode(LengthEncodedString.self, from: data)

    // Then
    XCTAssertEqual(lengthEncodedString.value, string)
    XCTAssertEqual(lengthEncodedString.length, UInt64(string.lengthOfBytes(using: .utf8)) + 9)
  }

  func testEightByteStringPerformance() throws {
    // Given
    let string = String(repeating: "A", count: 0x1000000)
    let data = [0xfe] + UInt64(string.lengthOfBytes(using: .utf8)).bytes + string.utf8
    let decoder = BinaryDataDecoder()

    // When
    measure {
      do {
        let _ = try decoder.decode(LengthEncodedString.self, from: data)
      } catch {

      }
    }
  }
}
