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

import XCTest
@testable import MySqlClient

class LengthEncodedIntegerEncodingTests: XCTestCase {

// Disabled until a BinaryStreamEncoder is implemented.

  func testNothing() {
    
  }

//  func testOneByteEncodingAsData() throws {
//    for byte: UInt8 in 0x00...0xfb {
//      // Given
//      let value: UInt8 = byte
//      let integer = LengthEncodedInteger(value: UInt64(value))
//
//      // When
//      let data = integer.asData()
//
//      // Then
//      XCTAssertEqual([UInt8](data), [value])
//    }
//  }
//
//  func test0xfcTwoByteEncodingAsData() throws {
//    // Given
//    let value: UInt8 = 0xfc
//    let integer = LengthEncodedInteger(value: UInt64(value))
//
//    // When
//    let data = integer.asData()
//
//    // Then
//    XCTAssertEqual([UInt8](data), [0x0fc, value, 0x00])
//  }
//
//  func test0xfdTwoByteEncodingAsData() throws {
//    // Given
//    let value: UInt8 = 0xfd
//    let integer = LengthEncodedInteger(value: UInt64(value))
//
//    // When
//    let data = integer.asData()
//
//    // Then
//    XCTAssertEqual([UInt8](data), [0x0fc, value, 0x00])
//  }
//
//  func test0xfeTwoByteEncodingAsData() throws {
//    // Given
//    let value: UInt8 = 0xfe
//    let integer = LengthEncodedInteger(value: UInt64(value))
//
//    // When
//    let data = integer.asData()
//
//    // Then
//    XCTAssertEqual([UInt8](data), [0x0fc, value, 0x00])
//  }
//
//  func testTwoByteEncodingMaxAsData() throws {
//    // Given
//    let value: UInt16 = 0x1000
//    let integer = LengthEncodedInteger(value: UInt64(value))
//
//    // When
//    let data = integer.asData()
//
//    // Then
//    XCTAssertEqual([UInt8](data), [0x0fc] + value.bytes)
//  }
//
//  func testThreeByteEncodingMinAsData() throws {
//    // Given
//    let value: UInt32 = 0x00010000
//    let integer = LengthEncodedInteger(value: UInt64(value))
//
//    // When
//    let data = integer.asData()
//
//    // Then
//    XCTAssertEqual([UInt8](data), [0x0fd] + value.bytes[0...2])
//  }
//
//  func testThreeByteEncodingMaxAsData() throws {
//    // Given
//    let value: UInt32 = 0x00ffffff
//    let integer = LengthEncodedInteger(value: UInt64(value))
//
//    // When
//    let data = integer.asData()
//
//    // Then
//    XCTAssertEqual([UInt8](data), [0x0fd] + value.bytes[0...2])
//  }
//
//  func testEightByteEncodingMinAsData() throws {
//    // Given
//    let value: UInt32 = 0x01000000
//    let integer = LengthEncodedInteger(value: UInt64(value))
//
//    // When
//    let data = integer.asData()
//
//    // Then
//    XCTAssertEqual([UInt8](data), [0x0fe] + value.bytes + [UInt8](repeating: 0, count: 4))
//  }
//
//  func testEightByteEncodingMaxAsData() throws {
//    // Given
//    let value: UInt64 = 0xffffffffffffffff
//    let integer = LengthEncodedInteger(value: UInt64(value))
//
//    // When
//    let data = integer.asData()
//
//    // Then
//    XCTAssertEqual([UInt8](data), [0x0fe] + value.bytes)
//  }
}
