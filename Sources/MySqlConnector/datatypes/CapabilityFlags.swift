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
public struct CapabilityFlags: OptionSet {
  public init(rawValue: UInt32) {
    self.rawValue = rawValue
  }
  public let rawValue: UInt32
  public static let longPassword               = CapabilityFlags(rawValue: 0x00000001)
  public static let foundRows                  = CapabilityFlags(rawValue: 0x00000002)
  public static let longFlag                   = CapabilityFlags(rawValue: 0x00000004)
  public static let connectWithDb              = CapabilityFlags(rawValue: 0x00000008)
  public static let noSchema                   = CapabilityFlags(rawValue: 0x00000010)
  public static let compress                   = CapabilityFlags(rawValue: 0x00000020)
  public static let odbc                       = CapabilityFlags(rawValue: 0x00000040)
  public static let localFiles                 = CapabilityFlags(rawValue: 0x00000080)
  public static let ignoreSpace                = CapabilityFlags(rawValue: 0x00000100)
  public static let protocol41                 = CapabilityFlags(rawValue: 0x00000200)
  public static let interactive                = CapabilityFlags(rawValue: 0x00000400)
  public static let ssl                        = CapabilityFlags(rawValue: 0x00000800)
  public static let ignoreSigpipe              = CapabilityFlags(rawValue: 0x00001000)
  public static let transactions               = CapabilityFlags(rawValue: 0x00002000)
  public static let reserved                   = CapabilityFlags(rawValue: 0x00004000)
  public static let secureConnection           = CapabilityFlags(rawValue: 0x00008000)
  public static let multiStatements            = CapabilityFlags(rawValue: 0x00010000)
  public static let multiResults               = CapabilityFlags(rawValue: 0x00020000)
  public static let psMultiResults             = CapabilityFlags(rawValue: 0x00040000)
  public static let pluginAuth                 = CapabilityFlags(rawValue: 0x00080000)
  public static let connectAttrs               = CapabilityFlags(rawValue: 0x00100000)
  public static let pluginAuthLenencClientData = CapabilityFlags(rawValue: 0x00200000)
  public static let canHandleExpiredPasswords  = CapabilityFlags(rawValue: 0x00400000)
  public static let sessionTrack               = CapabilityFlags(rawValue: 0x00800000)
  public static let deprecateEof               = CapabilityFlags(rawValue: 0x01000000)
}
