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
 Length-encoded integer type parsing.
 */
enum LengthEncodedIntegerType {
  case one
  case two
  case three
  case eight

  init?(firstByte: UInt8) {
    switch firstByte {
    case 0xff: return nil // Error packet / undefined.
    case 0xfc: self = .two
    case 0xfd: self = .three
    case 0xfe: self = .eight // May be an EOF packet. See LengthEncodedInteger implementation for details.
    default: self = .one
    }
  }

  /**
   Determines the length-encoded integer type required to represent the given value.

   https://dev.mysql.com/doc/internals/en/integer.html
   */
  init(value: UInt64) {
    if value < 0xfc {
      self = .one
    } else if value <= 0xFFFF {
      self = .two
    } else if value <= 0xFFFFFF {
      self = .three
    } else {
      self = .eight
    }
  }

  var length: UInt {
    switch self {
    case .one:
      return 1
    case .two:
      return 3
    case .three:
      return 4
    case .eight:
      return 9
    }
  }
}
