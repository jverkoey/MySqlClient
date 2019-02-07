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
import Socket
@testable import MySqlConnector

func getEnvironmentVariable(named name: String) -> String? {
  if let environmentValue = getenv(name) {
    return String(cString: environmentValue)
  } else {
    return nil
  }
}

final class MySqlConnectorTests: XCTestCase {
  var socket: Socket!
  override func setUp() {
    super.setUp()

    guard let mySqlServerHost = getEnvironmentVariable(named: "MYSQL_SERVER_HOST"),
      let mySqlServerPortString = getEnvironmentVariable(named: "MYSQL_SERVER_PORT"),
      let mySqlServerPort = Int32(mySqlServerPortString),
      let _ = getEnvironmentVariable(named: "MYSQL_SERVER_USER"),
      let _ = getEnvironmentVariable(named: "MYSQL_SERVER_PASSWORD") else {
        return
    }

    do {
      socket = try Socket.create()
      try socket.connect(to: mySqlServerHost, port: mySqlServerPort)
      guard socket.isConnected else {
        preconditionFailure("Unable to connect to server.")
      }
    } catch let error {
      preconditionFailure("Unable to connect to server: \(String(describing: error))")
    }
  }

  override func tearDown() {
    if socket != nil {
      socket.close()
      socket = nil
    }

    super.tearDown()
  }

  func testConnectToServer() throws {
    guard let socket = socket else {
      return
    }

    var buffer = Data(capacity: socket.readBufferSize)
    _ = try socket.read(into: &buffer)
    XCTAssertGreaterThan(buffer.count, 0, "Did not receive any data from the server.")
  }
}
