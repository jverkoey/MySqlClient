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
 Documentation: https://dev.mysql.com/doc/internals/en/com-query-response.html#packet-Protocol::ColumnDefinition
 */
struct ColumnDefinition: BinaryDecodable, CustomStringConvertible {
  let schema: String
  let table: String
  let name: String
  let lengthOfFixedLengthFields: UInt64
  let characterSet: UInt16
  let columnLength: UInt32
  let columnType: UInt8
  let flags: UInt16
  let maxShownDecimals: UInt8

  /**
   - Throws: `PayloadReaderError.unexpectedEndOfPayload` if the packet's end was unexpectedly reached.
   */
  init(from decoder: BinaryDecoder) throws {
    var container = decoder.container(maxLength: nil)

    let catalog = try container.decode(LengthEncodedString.self).value
    assert(catalog == "def", "Unexpected catalog value.")

    schema = try container.decode(LengthEncodedString.self).value
    table = try container.decode(LengthEncodedString.self).value
    _ = try container.decode(LengthEncodedString.self).value
    name = try container.decode(LengthEncodedString.self).value
    _ = try container.decode(LengthEncodedString.self).value

    lengthOfFixedLengthFields = try container.decode(LengthEncodedInteger.self).value
    characterSet = try container.decode(UInt16.self)
    columnLength = try container.decode(UInt32.self)
    columnType = try container.decode(UInt8.self)
    flags = try container.decode(UInt16.self)
    maxShownDecimals = try container.decode(UInt8.self)

    // Filler
    _ = try container.decode(maxLength: 2)
  }
}
