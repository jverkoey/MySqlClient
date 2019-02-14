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

/**
 A MySql length-encoded string.

 This implementation is limited to the maximum length of Foundation's String implementation, i.e. Int.max.

 Documentation: https://dev.mysql.com/doc/internals/en/string.html#packet-Protocol::LengthEncodedString
 */
struct LengthEncodedString: BinaryDecodable {

  /**
   Attempts to initialize a length-encoded string from the provided `data`. If the data does not represent a
   length-encoded string, then nil is returned.

   - Parameter data: The data from which the length-encoded string should be parsed.
   - Throws: `LengthEncodedStringError.unexpectedEndOfData` If `data` looks like a length-encoded string but its
   length is less than the expected amount.
   - Throws: `LengthEncodedStringError.unableToCreateStringWithEncoding` If a String was not able to be initialized from
   `data` with the given `encoding`.
   */
  init(from decoder: BinaryDecoder) throws {
    var container = decoder.container(maxLength: nil)

    let length = try container.decode(LengthEncodedInteger.self)
    self.length = UInt64(length.length) + UInt64(length.value)

    let stringData = try container.decode(maxLength: Int(length.value))
    guard let string = String(data: Data(stringData), encoding: .utf8) else {
      throw BinaryDecodingError.dataCorrupted(.init(debugDescription:
        "Unable to create String representation of data"))
    }
    self.value = string
  }

  init(value: String, encoding: String.Encoding) {
    self.value = value

    let stringLength = UInt64(value.lengthOfBytes(using: encoding))
    let length = LengthEncodedInteger(value: stringLength)
    self.length = UInt64(length.length) + stringLength
  }

  let value: String

  /**
   The number of bytes required to represent this length-encoded string.
   */
  let length: UInt64
}
