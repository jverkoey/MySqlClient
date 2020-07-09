// Copyright 2020-present the MySqlClient authors. All Rights Reserved.
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

class ConnectionTests: MySqlClientHarnessTestCase {
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
    XCTAssertTrue(connection1 === connection2)
  }

  // MARK: - Number of connections

  func testOneQueryCreatesOneConnectionButClosesItWhenReleased() throws {
    // When
    try client.query("SELECT \"pizza\" AS food")

    // Then
    XCTAssertEqual(client.connectionPool.count, 1)
    let idleConnections = client.connectionPool.filter { $0.isIdle }
    XCTAssertEqual(idleConnections.count, 0)
    let closedConnections = client.connectionPool.filter { !$0.socket.isConnected }
    XCTAssertEqual(closedConnections.count, 1)
  }

  func testTwoQueriesHeldStronglyCreatesTwoConnections() throws {
    // When
    let response1 = try client.query("SELECT \"pizza\" AS food")
    let response2 = try client.query("SELECT \"salmon\" AS food")

    // Then
    XCTAssertEqual(client.connectionPool.count, 2)
    let idleConnections = client.connectionPool.filter { $0.isIdle }
    XCTAssertEqual(idleConnections.count, 0)
    let closedConnections = client.connectionPool.filter { !$0.socket.isConnected }
    XCTAssertEqual(closedConnections.count, 0)
    switch response1 {
    case .Results:
      break
    default:
      XCTFail("Unhandled case.")
    }
    switch response2 {
    case .Results:
      break
    default:
      XCTFail("Unhandled case.")
    }
  }

  func testTwoQueriesReleasedReusesOneConnection() throws {
    // When
    try client.query("SELECT \"pizza\" AS food")
    try client.query("SELECT \"salmon\" AS food")

    // Then
    XCTAssertEqual(client.connectionPool.count, 1)
    let closedConnections = client.connectionPool.filter { !$0.socket.isConnected }
    XCTAssertEqual(closedConnections.count, 1)
  }

  // MARK: - Connection idling behavior

  func testQueryDoesNotIdleAfterOneIteration() throws {
    // Given
    let response = try client.query("SELECT \"pizza\" AS food")

    // When
    switch response {
    case .Results(let iterator):
      XCTAssertNotNil(iterator.next())
    default:
      XCTFail("Unhandled case.")
    }

    // Then
    let idleConnectionsAfterIteration = client.connectionPool.filter { $0.isIdle }
    XCTAssertEqual(idleConnectionsAfterIteration.count, 0)
    let closedConnections = client.connectionPool.filter { !$0.socket.isConnected }
    XCTAssertEqual(closedConnections.count, 0)
  }

  func testQueryIdlesAfterIterationExhaustion() throws {
    // Given
    let response = try client.query("SELECT \"pizza\" AS food")

    // When
    switch response {
    case .Results(let iterator):
      let results = Array(iterator) // Exhaust the iterator.
      XCTAssertEqual(results.count, 1)
    default:
      XCTFail("Unhandled case.")
    }

    // Then
    let idleConnectionsAfterIteration = client.connectionPool.filter { $0.isIdle }
    XCTAssertEqual(idleConnectionsAfterIteration.count, 1)
    let closedConnections = client.connectionPool.filter { !$0.socket.isConnected }
    XCTAssertEqual(closedConnections.count, 0)
  }
}
