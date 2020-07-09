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

struct Variable: Codable {
  let Variable_name: String
  let Value: String
}

final class QueryTests: MySqlClientHarnessTestCase {
  func testFood() throws {
    // When
    let response = try client.query("SELECT 'pizza' as food")

    // Then
    if case let .Results(iterator) = response {
      let keyValues = Array(iterator)
      XCTAssertGreaterThan(keyValues.count, 0)
    }
  }

  func testShowVariablesAsDictionaries() throws {
    // Given
    let query = "SHOW VARIABLES;"

    // When
    let response = try client.query(query)

    // Then
    switch response {
    case .Results(let iterator):
      let keyValues = Array(iterator)
      XCTAssertGreaterThan(keyValues.count, 0)

    default:
      XCTFail("Unexpected response \(response)")
    }
  }

  func testShowVariablesAsObjects() throws {
    // Given
    let query = "SHOW VARIABLES;"

    // When
    let response = try client.query(query, rowType: Variable.self)

    // Then
    switch response {
    case .Results(let iterator):
      let keyValues = Array(iterator)
      XCTAssertGreaterThan(keyValues.count, 0)

    default:
      XCTFail("Unexpected response \(response)")
    }
  }
}
