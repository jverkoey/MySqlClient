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

struct Query: BinaryEncodable {
  let query: String
  init(_ query: String) {
    self.query = query
  }

  func encode(to encoder: BinaryEncoder) throws {
    var container = encoder.container()
    try container.encode(UInt8(0x03))
    try container.encode(query, encoding: .utf8, terminator: 0)
  }
}

final class QueryResultDecoder<T: Decodable>: IteratorProtocol {
  let connection: Connection
  let columnDefinitions: [ColumnDefinition]

  init(columnCount: UInt64, connection: Connection) throws {
    self.connection = connection

    columnDefinitions = try (0..<columnCount).map { _ in
      return try connection.read()
    }
  }

  func next() -> T? {
    do {
      let resultsetRow: Resultset = try connection.read()
      switch resultsetRow {
      case .eof:
        return nil
      case .row(let values):
        let decoder = RowDecoder(columnDefinitions: columnDefinitions, values: values)
        return try T(from: decoder)
      }
    } catch let error {
      assertionFailure(String(describing: error))
      return nil
    }
  }
}
