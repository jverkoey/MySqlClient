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
import Socket
@testable import MySqlConnector
import XCTest

func getEnvironmentVariable(named name: String) -> String? {
  if let environmentValue = getenv(name) {
    return String(cString: environmentValue)
  } else {
    return nil
  }
}

final class StandardErrorOutputStream: TextOutputStream {
  func write(_ string: String) {
    FileHandle.standardError.write(Data(string.utf8))
  }
}

class BaseServerTestCase: XCTestCase {
  var socket: Socket!
  var socketDataStream: BufferedData!

  override func setUp() {
    super.setUp()

    socket = try! Socket.create()

    let port: Int32
    if let portEnvVar = getEnvironmentVariable(named: "PORT") {
      port = Int32(portEnvVar)!
    } else {
      port = 3306
    }
    let host: String
    if let hostEnvVar = getEnvironmentVariable(named: "HOST") {
      host = hostEnvVar
    } else {
      host = "localhost"
    }

    var stderrOut = StandardErrorOutputStream()
    print("Connecting to port \(port) on \(host)...", to: &stderrOut)

    try! socket.connect(to: host, port: port)

    if !socket.isConnected {
      return
    }

    var buffer = Data(capacity: socket.readBufferSize)
    socketDataStream = BufferedData(reader: AnyBufferedDataSource(read: { recommendedAmount in
      if buffer.count == 0 {
        _ = try! self.socket.read(into: &buffer)
      }
      let pulledData = buffer.prefix(recommendedAmount)
      buffer = buffer.dropFirst(recommendedAmount)
      return pulledData
    }, isAtEnd: {
      do {
        return try buffer.isEmpty && !self.socket.isReadableOrWritable(waitForever: false, timeout: 0).readable
      } catch {
        return true
      }
    }))
  }

  override func tearDown() {
    if socket != nil {
      socket.close()
      socket = nil
    }
    socketDataStream = nil

    super.tearDown()
  }
}
