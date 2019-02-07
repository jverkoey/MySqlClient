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

class LengthEncodedStringDecodingTests: XCTestCase {

  func testNilWithEmptyData() throws {
    // Given
    let data = Data()

    // Then
    XCTAssertNil(try LengthEncodedString(data: data, encoding: .utf8))
  }

  func testEmptyString() throws {
    // Given
    let data = Data([0x00])

    // When
    let lengthEncodedString = try LengthEncodedString(data: data, encoding: .utf8)

    // Then
    XCTAssertEqual(lengthEncodedString?.value, "")
  }

  func testOneByteString() throws {
    // Given
    let string = String(repeating: "A", count: 0xfb)
    let data = LengthEncodedInteger(value: UInt64(string.lengthOfBytes(using: .utf8))).asData() + string.utf8

    // When
    let lengthEncodedString = try LengthEncodedString(data: data, encoding: .utf8)

    // Then
    XCTAssertEqual(lengthEncodedString?.value, string)
    XCTAssertEqual(lengthEncodedString!.length, UInt64(string.lengthOfBytes(using: .utf8)) + 1)
  }

  func testTwoByteStringMin() throws {
    // Given
    let string = String(repeating: "A", count: 0xfc)
    let data = LengthEncodedInteger(value: UInt64(string.lengthOfBytes(using: .utf8))).asData() + string.utf8

    // When
    let lengthEncodedString = try LengthEncodedString(data: data, encoding: .utf8)

    // Then
    XCTAssertEqual(lengthEncodedString?.value, string)
    XCTAssertEqual(lengthEncodedString!.length, UInt64(string.lengthOfBytes(using: .utf8)) + 3)
  }

  func testTwoByteStringMax() throws {
    // Given
    let string = String(repeating: "A", count: 0xFFFF)
    let data = LengthEncodedInteger(value: UInt64(string.lengthOfBytes(using: .utf8))).asData() + string.utf8

    // When
    let lengthEncodedString = try LengthEncodedString(data: data, encoding: .utf8)

    // Then
    XCTAssertEqual(lengthEncodedString?.value, string)
    XCTAssertEqual(lengthEncodedString!.length, UInt64(string.lengthOfBytes(using: .utf8)) + 3)
  }

  func testThreeByteStringMin() throws {
    // Given
    let string = String(repeating: "A", count: 0x10000)
    let data = LengthEncodedInteger(value: UInt64(string.lengthOfBytes(using: .utf8))).asData() + string.utf8

    // When
    let lengthEncodedString = try LengthEncodedString(data: data, encoding: .utf8)

    // Then
    XCTAssertEqual(lengthEncodedString?.value, string)
    XCTAssertEqual(lengthEncodedString!.length, UInt64(string.lengthOfBytes(using: .utf8)) + 4)
  }

  func testThreeByteStringMax() throws {
    // Given
    let string = String(repeating: "A", count: 0xFFFFFF)
    let data = LengthEncodedInteger(value: UInt64(string.lengthOfBytes(using: .utf8))).asData() + string.utf8

    // When
    let lengthEncodedString = try LengthEncodedString(data: data, encoding: .utf8)

    // Then
    XCTAssertEqual(lengthEncodedString?.value, string)
    XCTAssertEqual(lengthEncodedString!.length, UInt64(string.lengthOfBytes(using: .utf8)) + 4)
  }

  func testEightByteStringMin() throws {
    // Given
    let string = String(repeating: "A", count: 0x1000000)
    let data = LengthEncodedInteger(value: UInt64(string.lengthOfBytes(using: .utf8))).asData() + string.utf8

    // When
    let lengthEncodedString = try LengthEncodedString(data: data, encoding: .utf8)

    // Then
    XCTAssertEqual(lengthEncodedString?.value, string)
    XCTAssertEqual(lengthEncodedString!.length, UInt64(string.lengthOfBytes(using: .utf8)) + 9)
  }
}
