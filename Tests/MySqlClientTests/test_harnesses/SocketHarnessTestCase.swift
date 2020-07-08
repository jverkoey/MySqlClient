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
import Socket
@testable import MySqlClient
import XCTest

class SocketHarnessTestCase: XCTestCase {
  var socket: Socket!
  var socketDataStream: BufferedData!

  override func setUp() {
    super.setUp()

    socket = try! Socket.create()
    try! socket.connect(to: environment.host, port: environment.port)
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
