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
//    try testRunner.test { environment, socketDataStream in
//      // Given
//      let decoder = BinaryDataDecoder()
//
//      // When
//      let handshake = try decoder.decode(Packet<Handshake>.self, from: socketDataStream)
//
//      // Then
//      XCTAssertEqual(handshake.sequenceNumber, 0)
//      XCTAssertEqual(handshake.payload.protocolVersion, .v10)
//      environment.AssertEqual(handshake.payload.authPluginName, [
//        .MySql(version: "8.0.20"): "caching_sha2_password"
//      ])
//      environment.AssertEqual(handshake.payload.serverCapabilityFlags, [
//        .MySql(version: "8.0.20"): [
//          .longPassword,
//          .foundRows,
//          .longFlag,
//          .connectWithDb,
//          .noSchema,
//          .compress,
//          .odbc,
//          .localFiles,
//          .ignoreSpace,
//          .protocol41,
//          .interactive,
//          .ssl,
//          .ignoreSigpipe,
//          .transactions,
//          .reserved,
//          .secureConnection,
//          .multiStatements,
//          .multiResults,
//          .psMultiResults,
//          .pluginAuth,
//          .connectAttrs,
//          .pluginAuthLenencClientData,
//          .canHandleExpiredPasswords,
//          .sessionTrack,
//          .deprecateEof,
//          .mystery02000000,
//          .mystery04000000,
//          .mystery40000000,
//          .mystery80000000
//        ]
//      ])
//    }
  }
}
