// Copyright 2019-present the MySqlClient authors. All Rights Reserved.
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

/**
 Capability flags are used by the client and server to indicate which features they support and want to use.

 Documentation: https://dev.mysql.com/doc/internals/en/capability-flags.html#packet-Protocol::CapabilityFlags
 */
struct CapabilityFlags: OptionSet, BinaryEncodable {
  init(rawValue: UInt32) {
    self.rawValue = rawValue
  }
  let rawValue: UInt32
  static let longPassword               = CapabilityFlags(rawValue: 0x00_00_00_01)
  static let foundRows                  = CapabilityFlags(rawValue: 0x00_00_00_02)
  static let longFlag                   = CapabilityFlags(rawValue: 0x00_00_00_04)
  static let connectWithDb              = CapabilityFlags(rawValue: 0x00_00_00_08)
  static let noSchema                   = CapabilityFlags(rawValue: 0x00_00_00_10)
  static let compress                   = CapabilityFlags(rawValue: 0x00_00_00_20)
  static let odbc                       = CapabilityFlags(rawValue: 0x00_00_00_40)
  static let localFiles                 = CapabilityFlags(rawValue: 0x00_00_00_80)

  static let ignoreSpace                = CapabilityFlags(rawValue: 0x00_00_01_00)
  static let protocol41                 = CapabilityFlags(rawValue: 0x00_00_02_00)
  static let interactive                = CapabilityFlags(rawValue: 0x00_00_04_00)
  static let ssl                        = CapabilityFlags(rawValue: 0x00_00_08_00)
  static let ignoreSigpipe              = CapabilityFlags(rawValue: 0x00_00_10_00)
  static let transactions               = CapabilityFlags(rawValue: 0x00_00_20_00)
  static let reserved                   = CapabilityFlags(rawValue: 0x00_00_40_00)
  static let secureConnection           = CapabilityFlags(rawValue: 0x00_00_80_00)

  static let multiStatements            = CapabilityFlags(rawValue: 0x00_01_00_00)
  static let multiResults               = CapabilityFlags(rawValue: 0x00_02_00_00)
  static let psMultiResults             = CapabilityFlags(rawValue: 0x00_04_00_00)
  static let pluginAuth                 = CapabilityFlags(rawValue: 0x00_08_00_00)
  static let connectAttrs               = CapabilityFlags(rawValue: 0x00_10_00_00)
  static let pluginAuthLenencClientData = CapabilityFlags(rawValue: 0x00_20_00_00)
  static let canHandleExpiredPasswords  = CapabilityFlags(rawValue: 0x00_40_00_00)
  static let sessionTrack               = CapabilityFlags(rawValue: 0x00_80_00_00)

  static let deprecateEof               = CapabilityFlags(rawValue: 0x01_00_00_00)
  static let mystery02000000            = CapabilityFlags(rawValue: 0x02_00_00_00)
  static let mystery04000000            = CapabilityFlags(rawValue: 0x04_00_00_00)
  static let mystery40000000            = CapabilityFlags(rawValue: 0x40_00_00_00)
  static let mystery80000000            = CapabilityFlags(rawValue: 0x80_00_00_00)
}
