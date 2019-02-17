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
 Documentation: https://dev.mysql.com/doc/internals/en/com-query-response.html#packet-ProtocolText::ResultsetRow
 */
enum Resultset: BinaryDecodable, CustomStringConvertible {
  case eof(response: GenericResponse)
  case row(values: [String?])

  init(from decoder: BinaryDecoder) throws {
    var container = decoder.container(maxLength: nil)

    var identifier = try container.peek(maxLength: 1).first
    if identifier == 0xfe {
      self = .eof(response: try container.decode(GenericResponse.self))
      return
    }

    var values: [String?] = []

    while identifier != nil {
      if identifier == 0xfb {
        values.append(nil)
        _ = try container.decode(maxLength: 1)
      } else {
        values.append(try container.decode(LengthEncodedString.self).value)
      }
      if container.isAtEnd {
        break
      }
      identifier = try container.peek(maxLength: 1).first
    }

    self = .row(values: values)
  }
}
