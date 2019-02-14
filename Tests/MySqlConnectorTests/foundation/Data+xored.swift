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

@testable import MySqlConnector
import XCTest

final class DataXoredTests: XCTestCase {

  func testXorsEmptyData() {
    // Given
    let data1 = Data()
    let data2 = Data()

    // When
    let xored = data1.xored(with: data2)

    // Then
    XCTAssertEqual([UInt8](xored), [])
  }

  func testXorsOneByte() {
    // Given
    let data1 = Data([0b00001111])
    let data2 = Data([0b11111111])

    // When
    let xored = data1.xored(with: data2)

    // Then
    XCTAssertEqual([UInt8](xored), [0b11110000])
  }

  func testXorsMultipleBytes() {
    // Given
    let data1 = Data([0b00001111, 0b10101010])
    let data2 = Data([0b11111111, 0b01010101])

    // When
    let xored = data1.xored(with: data2)

    // Then
    XCTAssertEqual([UInt8](xored), [0b11110000, 0b11111111])
  }

  func testXorsUpToSmallerOfBothValuesLeftHandSide() {
    // Given
    let data1 = Data([0b00001111, 0b00001111])
    let data2 = Data([0b11111111])

    // When
    let xored = data1.xored(with: data2)

    // Then
    XCTAssertEqual([UInt8](xored), [0b11110000])
  }

  func testXorsUpToSmallerOfBothValuesRightHandSide() {
    // Given
    let data1 = Data([0b00001111])
    let data2 = Data([0b11111111, 0b00001111])

    // When
    let xored = data1.xored(with: data2)

    // Then
    XCTAssertEqual([UInt8](xored), [0b11110000])
  }
}
