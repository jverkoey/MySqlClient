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
  let serverVersion: String
  let connectionIdentifier: UInt32
  let authPluginData: Data
  let authPluginName: String?
  let serverCapabilityFlags: CapabilityFlags
  let characterSet: CharacterSet?
  let statusFlags: UInt16?

  init(from binaryDecoder: BinaryDecoder) throws {
    var container = binaryDecoder.container(maxLength: nil)

    self.protocolVersion = try container.decode(ProtocolVersion.self)

    if protocolVersion != .v10 {
      throw HandshakeError.unsupportedProtocol
    }

    self.serverVersion = try container.decode(String.self, encoding: .utf8, terminator: 0)
    self.connectionIdentifier = try container.decode(UInt32.self)
    let firstAuthPluginData = try container.decode(maxLength: 8)

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
      self.authPluginName = nil
      self.statusFlags = nil
      return
    }

    self.characterSet = try container.decode(CharacterSet.self)
    self.statusFlags = try container.decode(UInt16.self)

    let upperCapabilityFlags = UInt32(try container.decode(UInt16.self)) << 16
    self.serverCapabilityFlags = CapabilityFlags(rawValue: upperCapabilityFlags | lowerCapabilityFlags)

    let pluginDataLength: UInt8
    if self.serverCapabilityFlags.contains(.pluginAuth) {
      pluginDataLength = try container.decode(UInt8.self)
    } else {
      pluginDataLength = 0
      // Filler
      _ = try container.decode(UInt8.self)
    }

    // Reserved
    _ = try container.decode(maxLength: 10)

    if self.serverCapabilityFlags.contains(.secureConnection) {
      let secondAuthPluginData = try container.decode(maxLength: Int(max(13, pluginDataLength - 8)) + -1)
      self.authPluginData = Data(firstAuthPluginData + secondAuthPluginData)
    } else {
      self.authPluginData = firstAuthPluginData
    }

    if self.serverCapabilityFlags.contains(.pluginAuth) {
      self.authPluginName = try container.decode(String.self, encoding: .utf8, terminator: 0)
    } else {
      self.authPluginName = nil
    }
  }
}
