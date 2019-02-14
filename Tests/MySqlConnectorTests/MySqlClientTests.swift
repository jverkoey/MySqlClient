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

final class MySqlClientTests: XCTestCase {
  var client: MySqlClient!
  override func setUp() {
    super.setUp()

    guard let host = getEnvironmentVariable(named: "MYSQL_SERVER_HOST"),
      let mySqlServerPortString = getEnvironmentVariable(named: "MYSQL_SERVER_PORT"),
      let mySqlServerPort = Int32(mySqlServerPortString),
      let username = getEnvironmentVariable(named: "MYSQL_SERVER_USER"),
      let password = getEnvironmentVariable(named: "MYSQL_SERVER_PASSWORD") else {
      return
    }
    client = MySqlClient(to: host, port: mySqlServerPort, username: username, password: password, database: nil)
  }

  override func tearDown() {
    client = nil

    super.tearDown()
  }

  func testConnects() throws {
    guard client != nil else {
      return
    }

    // When
    let connection = try client.anyIdleConnection()

    // Then
    XCTAssertNotNil(connection)
    XCTAssertEqual(client.connectionPool.count, 1)
  }

  func testReusesIdleConnection() throws {
    guard client != nil else {
      return
    }

    // When
    let connection1 = try client.anyIdleConnection()
    let connection2 = try client.anyIdleConnection()

    // Then
    XCTAssertNotNil(connection1)
    XCTAssertNotNil(connection2)
    XCTAssertEqual(client.connectionPool.count, 1)
  }
}
