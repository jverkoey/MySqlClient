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
  func testHandshake() throws {
    try testRunner.test(testCase: self) { environment, socketDataStream, socket in
      // Given
      let decoder = BinaryDataDecoder()

      // When
      let handshake = try decoder.decode(Packet<Handshake>.self, from: socketDataStream)

      // Then
      XCTAssertTrue(socketDataStream.isAtEnd)
      XCTAssertEqual(handshake.sequenceNumber, 0)
      XCTAssertEqual(handshake.payload.protocolVersion, .v10)
      environment.AssertEqual(handshake.payload.authPluginName, [
        .MySql(version: "8.0.11"): "caching_sha2_password",
        .MySql(version: "8.0.15"): "caching_sha2_password",
        .MySql(version: "8.0.20"): "caching_sha2_password"
      ])
      let mySql8CapabilityFlags: CapabilityFlags = [
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
        .ssl,
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
        .mystery02000000,
        .mystery40000000,
        .mystery80000000
      ]
      environment.AssertEqual(handshake.payload.serverCapabilityFlags, [
        .MySql(version: "8.0.11"): mySql8CapabilityFlags,
        .MySql(version: "8.0.15"): mySql8CapabilityFlags,
        .MySql(version: "8.0.20"): mySql8CapabilityFlags.union(.mystery04000000)
      ])
    }
  }

  func testAuthFailsWithInvalidPassword() throws {
    try testRunner.test(testCase: self) { environment, socketDataStream, socket in
      // Given
      var decoder = BinaryDataDecoder()
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
      let handshakeResponse = try HandshakeResponse(username: "root",
                                                    password: "bogus",
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
        XCTAssertEqual(errorMessage, "Access denied for user 'root'@'localhost' (using password: YES)")
      default:
        XCTFail("Unexpected response \(response)")
      }
    }
  }

  func testAuthSucceedsWithValidPassword() throws {
    try testRunner.test(testCase: self) { environment, socketDataStream, socket in
      // Given
      var decoder = BinaryDataDecoder()
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
      let handshakeResponse = try HandshakeResponse(username: "root",
                                                    password: "",
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
}
