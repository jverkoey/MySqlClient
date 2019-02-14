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

struct OkResponse {
  let numberOfAffectedRows: UInt64
  let lastInsertId: UInt64
  let info: String?
}

private enum GenericResponseHeader: BinaryDecodable {
  case OK
  case EOF
  case ERR
  case ResultSet

  init(from decoder: BinaryDecoder) throws {
    var container = decoder.container(maxLength: 1)
    let decoded = try container.decode(UInt8.self)
    switch decoded {
    case 0x00:
      self = .OK
    case 0xFE:
      self = .EOF
    case 0xFF:
      self = .ERR
    default:
      self = .ResultSet
    }
  }
}

extension BinaryCodingUserInfoKey {
  static var capabilityFlags: BinaryCodingUserInfoKey = "CapabilityFlagsBinaryCodingUserInfoKey"
}

/**
 Documentation: https://dev.mysql.com/doc/internals/en/generic-response-packets.html
 */
enum GenericResponse: BinaryDecodable {
  case OK(response: OkResponse)
  case EOF(numberOfWarnings: UInt16?, statusFlags: UInt16?)
  case ERR(errorCode: ErrorCode, errorMessage: String)
  case ResultSetColumnCount(columnCount: UInt64)

  init(from decoder: BinaryDecoder) throws {
    var container = decoder.container(maxLength: nil)

    // Packet header is 1 byte.
    var packetHeader = try container.decode(GenericResponseHeader.self)
    if try packetHeader == .EOF && container.hasAtLeast(minBytes: 8) {
      packetHeader = .OK
    }

    switch packetHeader {
    case .OK:
      let numberOfAffectedRows = try container.decode(LengthEncodedInteger.self)
      let lastInsertId = try container.decode(LengthEncodedInteger.self)

      var info: String? = nil

      guard let capabilityFlags = decoder.userInfo[.capabilityFlags] as? CapabilityFlags else {
        throw BinaryDecodingError.dataCorrupted(.init(debugDescription:
          "Missing capability flags userInfo on the decoder. User info: \(decoder.userInfo)"))
      }

      if capabilityFlags.contains(.protocol41) {
        // TODO: Turn this into an enum
        // https://dev.mysql.com/doc/internals/en/status-flags.html
        let statusFlags = try container.decode(UInt16.self)

        // Number of warnings is 2 bytes.
        let _ = try container.decode(UInt16.self)

        if !container.isAtEnd {
          let sessionStateChanged = (statusFlags & UInt16(0x4000)) != 0

          if capabilityFlags.contains(.sessionTrack) {
            // Info string.
            info = try container.decode(LengthEncodedString.self).value

            if sessionStateChanged {
              // State changes
              let _ = try container.decode(LengthEncodedString.self)
            }
          }
        }
      }
      self = .OK(response: .init(numberOfAffectedRows: numberOfAffectedRows.value,
                                 lastInsertId: lastInsertId.value,
                                 info: info))

    case .EOF:
      guard let capabilityFlags = decoder.userInfo[.capabilityFlags] as? CapabilityFlags else {
        throw BinaryDecodingError.dataCorrupted(.init(debugDescription:
          "Missing capability flags userInfo on the decoder. User info: \(decoder.userInfo)"))
      }

      let numberOfWarnings: UInt16?
      let statusFlags: UInt16?
      if capabilityFlags.contains(.protocol41) {
        numberOfWarnings = try container.decode(UInt16.self)
        statusFlags = try container.decode(UInt16.self)
      } else {
        numberOfWarnings = nil
        statusFlags = nil
      }

      self = .EOF(numberOfWarnings: numberOfWarnings, statusFlags: statusFlags)

    case .ERR:
      // Error code is 2 bytes.
      let errorCode = try container.decode(ErrorCode.self)

      guard let capabilityFlags = decoder.userInfo[.capabilityFlags] as? CapabilityFlags else {
        throw BinaryDecodingError.dataCorrupted(.init(debugDescription:
          "Missing capability flags userInfo on the decoder. User info: \(decoder.userInfo)"))
      }

      if capabilityFlags.contains(.protocol41) {
        // State marker
        let _ = try container.decode(maxLength: 1)
        // State
        let _ = try container.decode(maxLength: 5)
      }
      let errorMessage = try container.decodeToEnd(String.self, encoding: .utf8)

      self = .ERR(errorCode: errorCode, errorMessage: errorMessage)

    case .ResultSet:
      let columnCount = try container.decode(LengthEncodedInteger.self)
      self = .ResultSetColumnCount(columnCount: columnCount.value)
    }
  }
}
