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

class LengthEncodedIntegerInitializationTests: XCTestCase {

  // MARK: Initializers

  func testOneByteEncoding() throws {
    for byte: UInt8 in 0x00...0xfb {
      // Given
      let value: UInt8 = byte

      // When
      let integer = LengthEncodedInteger(value: UInt64(value))

      // Then
      XCTAssertEqual(integer.value, UInt64(value))
      XCTAssertEqual(integer.length, 1)
    }
  }

  func test0xfcTwoByteEncoding() throws {
    // Given
    let value: UInt8 = 0xfc

    // When
    let integer = LengthEncodedInteger(value: UInt64(value))

    // Then
    XCTAssertEqual(integer.value, UInt64(value))
    XCTAssertEqual(integer.length, 3)
  }

  func test0xfdTwoByteEncoding() throws {
    // Given
    let value: UInt8 = 0xfd

    // When
    let integer = LengthEncodedInteger(value: UInt64(value))

    // Then
    XCTAssertEqual(integer.value, UInt64(value))
    XCTAssertEqual(integer.length, 3)
  }

  func test0xfeTwoByteEncoding() throws {
    // Given
    let value: UInt8 = 0xfe

    // When
    let integer = LengthEncodedInteger(value: UInt64(value))

    // Then
    XCTAssertEqual(integer.value, UInt64(value))
    XCTAssertEqual(integer.length, 3)
  }

  func testTwoByteEncodingMax() throws {
    // Given
    let value: UInt16 = 0x1000

    // When
    let integer = LengthEncodedInteger(value: UInt64(value))

    // Then
    XCTAssertEqual(integer.value, UInt64(value))
    XCTAssertEqual(integer.length, 3)
  }

  func testThreeByteEncodingMin() throws {
    // Given
    let value: UInt32 = 0x00010000

    // When
    let integer = LengthEncodedInteger(value: UInt64(value))

    // Then
    XCTAssertEqual(integer.value, UInt64(value))
    XCTAssertEqual(integer.length, 4)
  }

  func testThreeByteEncodingMax() throws {
    // Given
    let value: UInt32 = 0x00ffffff

    // When
    let integer = LengthEncodedInteger(value: UInt64(value))

    // Then
    XCTAssertEqual(integer.value, UInt64(value))
    XCTAssertEqual(integer.length, 4)
  }

  func testEightByteEncodingMin() throws {
    // Given
    let value: UInt32 = 0x01000000

    // When
    let integer = LengthEncodedInteger(value: UInt64(value))

    // Then
    XCTAssertEqual(integer.value, UInt64(value))
    XCTAssertEqual(integer.length, 9)
  }

  func testEightByteEncodingMax() throws {
    // Given
    let value: UInt64 = 0xffffffffffffffff

    // When
    let integer = LengthEncodedInteger(value: UInt64(value))

    // Then
    XCTAssertEqual(integer.value, UInt64(value))
    XCTAssertEqual(integer.length, 9)
  }
}
