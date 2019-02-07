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
@testable import IteratorProtocol_next

final class Tests: XCTestCase {

  func testMaxLength0ReturnsNothing() {
    // Given
    var iterator = [UInt8](repeating: 0xfa, count: 100).makeIterator()

    // When
    let bytes = iterator.next(maxLength: 0)

    // Then
    XCTAssertEqual([UInt8](bytes), [])
  }

  func testMaxLength1ReturnsOne() {
    // Given
    var iterator = [UInt8](repeating: 0xfa, count: 100).makeIterator()

    // When
    let bytes = iterator.next(maxLength: 1)

    // Then
    XCTAssertEqual([UInt8](bytes), [0xfa])
  }

  func testMaxLengthExceedingIteratorDataReturnsAll() {
    // Given
    var iterator = [UInt8](repeating: 0xfa, count: 100).makeIterator()

    // When
    let bytes = iterator.next(maxLength: 500)

    // Then
    XCTAssertEqual([UInt8](bytes), [UInt8](repeating: 0xfa, count: 100))
  }
}
