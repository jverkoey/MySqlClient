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
 A MySql length-encoded integer.

 Documentation: https://dev.mysql.com/doc/internals/en/integer.html#length-encoded-integer
 */
struct LengthEncodedInteger: BinaryDecodable {

  /**
   Initializes a length-encoded integer from the provided binary decoder.

   - throws: `BinaryDecodingError.dataCorrupted` if the decoded representation is not a valid length-encoded integer.
   */
  init(from decoder: BinaryDecoder) throws {
    // The largest possible length-encoded integer is 1 byte for the identifier + 8 bytes for the 64 bit number.
    var container = decoder.container(maxLength: 9)

    let firstByte = try container.decode(UInt8.self)
    guard let type = LengthEncodedIntegerType(firstByte: firstByte) else {
      throw BinaryDecodingError.dataCorrupted(.init(debugDescription: "Not a length-encoded integer."))
    }

    // Parse the data into the relevant storage.
    switch type {
    case .one:
      self.storage = .one(value: firstByte)
    case .two:
      self.storage = try .two(value: container.decode(UInt16.self))
    case .three:
      let data = try container.decode(length: 3)
      self.storage = .three(value: Data(data + [0x00]).withUnsafeBytes { (ptr: UnsafePointer<UInt32>) -> UInt32 in
        return ptr.pointee
      })
    case .eight:
      self.storage = try .eight(value: container.decode(UInt64.self))
    }
  }

  /**
   Initializes a length-encoded integer with the given value.
   */
  init(value: UInt64) {
    let type = LengthEncodedIntegerType(value: value)
    switch type {
    case .one:
      self.storage = .one(value: UInt8(value))
    case .two:
      self.storage = .two(value: UInt16(value))
    case .three:
      self.storage = .three(value: UInt32(value))
    case .eight:
      self.storage = .eight(value: UInt64(value))
    }
  }

  /**
   A 64 bit representation of this length-encoded integer's value.
   */
  var value: UInt64 {
    switch storage {
    case .one(let value):
      return UInt64(value)
    case .two(let value):
      return UInt64(value)
    case .three(let value):
      return UInt64(value)
    case .eight(let value):
      return UInt64(value)
    }
  }

  /**
   The number of bytes required to represent this length-encoded integer.
   */
  var length: UInt {
    switch storage {
    case .one: return 1
    case .two: return 3
    case .three: return 4
    case .eight: return 9
    }
  }

  private let storage: LengthEncodedIntegerStorage

  private enum LengthEncodedIntegerStorage {
    case one(value: UInt8)
    case two(value: UInt16)
    case three(value: UInt32)
    case eight(value: UInt64)
  }

  private enum LengthEncodedIntegerType {
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
      case .one: return 1
      case .two: return 3
      case .three: return 4
      case .eight: return 9
      }
    }
  }

}
