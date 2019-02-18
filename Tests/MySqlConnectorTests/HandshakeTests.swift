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
import Socket
@testable import MySqlConnector
import XCTest

final class HandshakeTests: XCTestCase {
  var socket: Socket!
  var socketDataStream: BufferedData!
  let config = TestConfig.environment
  override func setUp() {
    super.setUp()

    do {
      socket = try Socket.create()
      try socket.connect(to: config.host, port: config.port)
    } catch {
      return
    }

    if !socket.isConnected {
      return
    }

    var buffer = Data(capacity: socket.readBufferSize)
    socketDataStream = BufferedData(reader: AnyReader(read: { recommendedAmount in
      if buffer.count == 0 {
        _ = try self.socket.read(into: &buffer)
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

  func testHandshake() throws {
    guard config.testAgainstSqlServer else {
      return
    }

    // Given
    let decoder = BinaryStreamDecoder()

    // When
    let handshake = try decoder.decode(Packet<Handshake>.self, from: socketDataStream)

    // Then
    XCTAssertEqual(handshake.sequenceNumber, 0)
    XCTAssertEqual(handshake.payload.protocolVersion, .v10)
    XCTAssertEqual(handshake.payload.authPluginName, "mysql_native_password")
    XCTAssertEqual(handshake.payload.serverCapabilityFlags, [
      .longPassword,
      .foundRows,
      .longFlag,
      .connectWithDb,
      .noSchema,
      .compress,
      .odbc,
      .localFiles,
      .ignoreSpace,
      .protocol41,
      .interactive,
//      .ssl,
      .ignoreSigpipe,
      .transactions,
      .reserved,
      .secureConnection,
      .multiStatements,
      .multiResults,
      .psMultiResults,
      .pluginAuth,
      .connectAttrs,
      .pluginAuthLenencClientData,
      .canHandleExpiredPasswords,
      .sessionTrack,
      .deprecateEof,
      .mystery
    ])
  }

  func testAuthFailsWithInvalidPassword() throws {
    guard config.testAgainstSqlServer else {
      return
    }

    // Given
    var decoder = BinaryStreamDecoder()
    let handshake = try decoder.decode(Packet<Handshake>.self, from: socketDataStream)
    let clientCapabilityFlags: CapabilityFlags = [
      .connectWithDb,
      .deprecateEof,
      .protocol41,
      .secureConnection,
      .sessionTrack,
      .pluginAuth
    ]
    let capabilityFlags = clientCapabilityFlags.intersection(handshake.payload.serverCapabilityFlags)
    decoder.userInfo[.capabilityFlags] = capabilityFlags

    // When
    let handshakeResponse = try HandshakeResponse(username: config.user,
                                                  password: config.pass + "bogus",
                                                  database: nil,
                                                  capabilityFlags: capabilityFlags,
                                                  authPluginData: handshake.payload.authPluginData,
                                                  authPluginName: handshake.payload.authPluginName)
      .encodedAsPacket(sequenceNumber: 1)
    try socket.write(from: handshakeResponse)
    let response: Packet<GenericResponse>
    do {
      response = try decoder.decode(Packet<GenericResponse>.self, from: socketDataStream)
    } catch let error {
      XCTFail(String(describing: error))
      return
    }

    // Then
    switch response.payload {
    case .ERR(let errorCode, let errorMessage):
      XCTAssertEqual(errorCode, .ER_ACCESS_DENIED_ERROR)
      XCTAssertEqual(errorMessage, "Access denied for user \'\(config.user)\'@\'\(config.host)\' (using password: YES)")
    default:
      XCTFail("Unexpected response \(response)")
    }
  }

  func testAuthSucceedsWithValidPassword() throws {
    guard config.testAgainstSqlServer else {
      return
    }

    // Given
    var decoder = BinaryStreamDecoder()
    let handshake = try decoder.decode(Packet<Handshake>.self, from: socketDataStream)
    let clientCapabilityFlags: CapabilityFlags = [
      .connectWithDb,
      .deprecateEof,
      .protocol41,
      .secureConnection,
      .sessionTrack,
      .pluginAuth
    ]
    let capabilityFlags = clientCapabilityFlags.intersection(handshake.payload.serverCapabilityFlags)
    decoder.userInfo[.capabilityFlags] = capabilityFlags

    // When
    let handshakeResponse = try HandshakeResponse(username: config.user,
                                                  password: config.pass,
                                                  database: nil,
                                                  capabilityFlags: capabilityFlags,
                                                  authPluginData: handshake.payload.authPluginData,
                                                  authPluginName: handshake.payload.authPluginName)
      .encodedAsPacket(sequenceNumber: 1)
    try socket.write(from: handshakeResponse)
    let response: Packet<GenericResponse>
    do {
      response = try decoder.decode(Packet<GenericResponse>.self, from: socketDataStream)
    } catch let error {
      XCTFail(String(describing: error))
      return
    }

    // Then
    switch response.payload {
    case .OK(let response):
      XCTAssertEqual(response.lastInsertId, 0)
      XCTAssertEqual(response.numberOfAffectedRows, 0)
      XCTAssertNil(response.info)
    default:
      XCTFail("Unexpected response \(response)")
    }
  }
}
