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

final class DatabaseManagementTests: XCTestCase {
  var client: MySqlClient!
  let config = TestConfig.environment
  override func setUp() {
    super.setUp()

    client = MySqlClient(to: config.host, port: config.port, username: config.user, password: config.pass, database: nil)
  }

  override func tearDown() {
    client = nil

    super.tearDown()
  }

  func testCreatesAndDeletesDatabase() throws {
    guard client.isConnected else {
      return
    }

    // Given
    let name = "MySqlConnectorUnitTests"

    // When
    let creationResponse = try client.query("create database \(name)")
    let dropResponse = try client.query("drop database \(name)")

    // Then
    switch creationResponse {
    case .OK(let numberOfAffectedRows, let lastInsertId, let info):
      XCTAssertEqual(numberOfAffectedRows, 1)
      XCTAssertEqual(lastInsertId, 0)
      XCTAssertNil(info)
    default:
      XCTFail("Unexpected response \(creationResponse)")
    }
    switch dropResponse {
    case .OK(let numberOfAffectedRows, let lastInsertId, let info):
      XCTAssertEqual(numberOfAffectedRows, 0)
      XCTAssertEqual(lastInsertId, 0)
      XCTAssertNil(info)
    default:
      XCTFail("Unexpected response \(dropResponse)")
    }
  }
}
