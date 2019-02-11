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

import Foundation

/**
 Capability flags are used by the client and server to indicate which features they support and want to use.

 Documentation: https://dev.mysql.com/doc/internals/en/capability-flags.html#packet-Protocol::CapabilityFlags
 */
struct CapabilityFlags: OptionSet {
  init(rawValue: UInt32) {
    self.rawValue = rawValue
  }
  let rawValue: UInt32
  static let longPassword               = CapabilityFlags(rawValue: 0x00000001)
  static let foundRows                  = CapabilityFlags(rawValue: 0x00000002)
  static let longFlag                   = CapabilityFlags(rawValue: 0x00000004)
  static let connectWithDb              = CapabilityFlags(rawValue: 0x00000008)
  static let noSchema                   = CapabilityFlags(rawValue: 0x00000010)
  static let compress                   = CapabilityFlags(rawValue: 0x00000020)
  static let odbc                       = CapabilityFlags(rawValue: 0x00000040)
  static let localFiles                 = CapabilityFlags(rawValue: 0x00000080)
  static let ignoreSpace                = CapabilityFlags(rawValue: 0x00000100)
  static let protocol41                 = CapabilityFlags(rawValue: 0x00000200)
  static let interactive                = CapabilityFlags(rawValue: 0x00000400)
  static let ssl                        = CapabilityFlags(rawValue: 0x00000800)
  static let ignoreSigpipe              = CapabilityFlags(rawValue: 0x00001000)
  static let transactions               = CapabilityFlags(rawValue: 0x00002000)
  static let reserved                   = CapabilityFlags(rawValue: 0x00004000)
  static let secureConnection           = CapabilityFlags(rawValue: 0x00008000)
  static let multiStatements            = CapabilityFlags(rawValue: 0x00010000)
  static let multiResults               = CapabilityFlags(rawValue: 0x00020000)
  static let psMultiResults             = CapabilityFlags(rawValue: 0x00040000)
  static let pluginAuth                 = CapabilityFlags(rawValue: 0x00080000)
  static let connectAttrs               = CapabilityFlags(rawValue: 0x00100000)
  static let pluginAuthLenencClientData = CapabilityFlags(rawValue: 0x00200000)
  static let canHandleExpiredPasswords  = CapabilityFlags(rawValue: 0x00400000)
  static let sessionTrack               = CapabilityFlags(rawValue: 0x00800000)
  static let deprecateEof               = CapabilityFlags(rawValue: 0x01000000)
}
