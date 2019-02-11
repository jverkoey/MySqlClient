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
import Foundation
import CustomStringConvertible_description

/**
 Documentation: https://dev.mysql.com/doc/internals/en/capability-flags.html#packet-Protocol::CapabilityFlags
 */
enum ProtocolVersion: UInt8, BinaryDecodable {
  case v10 = 0x0a
  case v9  = 0x09

  init(from binaryDecoder: BinaryDecoder) throws {
    var container = binaryDecoder.container(maxLength: nil)
    let rawValue = try container.decode(ProtocolVersion.RawValue.self)
    guard let value = ProtocolVersion(rawValue: rawValue) else {
      throw BinaryDecodingError.dataCorrupted(.init(debugDescription:
        "Raw value \(rawValue) is not a valid case for \(type(of: self))."))
    }
    self = value
  }
}

enum HandshakeError: Error {
  case unsupportedProtocol
}

/**
 Documentation: https://dev.mysql.com/doc/internals/en/connection-phase-packets.html
 */
final class Handshake: BinaryDecodable, CustomStringConvertible {
  let protocolVersion: ProtocolVersion
  let authPluginData: Data
  let plugin: Data?
  let serverCapabilityFlags: CapabilityFlags
  let characterSet: CharacterSet?

  init(from binaryDecoder: BinaryDecoder) throws {
    var container = binaryDecoder.container(maxLength: nil)

    self.protocolVersion = try container.decode(ProtocolVersion.self)

    if protocolVersion != .v10 {
      throw HandshakeError.unsupportedProtocol
    }

    // Human-readable server version
    _ = try container.decode(String.self, encoding: .utf8, terminator: 0)

    // Connection identifier
    _ = try container.decode(UInt32.self)

    let firstAuthPluginData = try (0..<8).map { _ in try container.decode(UInt8.self) }

    // Filler
    _ = try container.decode(UInt8.self)

    // Lower capability flags are 2 bytes.
    let lowerCapabilityFlags = UInt32(try container.decode(UInt16.self))

    guard CapabilityFlags(rawValue: lowerCapabilityFlags).contains(.protocol41) else {
      throw HandshakeError.unsupportedProtocol
    }

    if container.isAtEnd {
      self.characterSet = nil
      self.authPluginData = Data(firstAuthPluginData)
      self.serverCapabilityFlags = CapabilityFlags(rawValue: lowerCapabilityFlags)
      self.plugin = nil
      return
    }

    self.characterSet = try container.decode(CharacterSet.self)

    // Status flags
    _ = try container.decode(UInt16.self)

    let upperCapabilityFlags = UInt32(try container.decode(UInt16.self)) << 16
    self.serverCapabilityFlags = CapabilityFlags(rawValue: upperCapabilityFlags | lowerCapabilityFlags)

    // Auth plugin data length (ignored; is always 20)
    _ = try container.decode(UInt8.self)

    // Reserved
    _ = try (0..<10).map { _ in try container.decode(UInt8.self) }

    // From https://github.com/go-sql-driver/mysql/blob/master/packets.go
    //
    // > second part of the password cipher [mininum 13 bytes],
    // > where len=MAX(13, length of auth-plugin-data - 8)
    // >
    // > The web documentation is ambiguous about the length. However,
    // > according to mysql-5.7/sql/auth/sql_authentication.cc line 538,
    // > the 13th byte is "\0 byte, terminating the second part of
    // > a scramble". So the second part of the password cipher is
    // > a NULL terminated string that's at least 13 bytes with the
    // > last byte being NULL.
    // >
    // > The official Python library uses the fixed length 12
    // > which seems to work but technically could have a hidden bug.
    let secondAuthPluginData = try (0..<12).map { _ in try container.decode(UInt8.self) }

    self.authPluginData = Data(firstAuthPluginData + secondAuthPluginData)

    let plugin = try container.decode(String.self, encoding: .utf8, terminator: 0)
    self.plugin = plugin.data(using: .utf8)
  }
}
