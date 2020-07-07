// Copyright 2020-present the MySqlConnector authors. All Rights Reserved.
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

class MySqlClientTests: BaseMySqlClientTests {
  func testConnects() throws {
    // When
    let connection = try client.anyIdleConnection()

    // Then
    XCTAssertNotNil(connection)
  }

  func testReusesIdleConnection() throws {
    // When
    let connection1 = try client.anyIdleConnection()
    let connection2 = try client.anyIdleConnection()

    // Then
    XCTAssertNotNil(connection1)
    XCTAssertNotNil(connection2)
  }
}