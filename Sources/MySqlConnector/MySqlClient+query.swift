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

public enum QueryResponse<T: Decodable> {
  case OK(numberOfAffectedRows: UInt64, lastInsertId: UInt64, info: String?)
  case ERR(errorCode: ErrorCode, errorMessage: String)
  case Results(iterator: AnyIterator<T>)
}

public enum QueryError: Error {
  case unexpectedEofResponse
}

extension MySqlClient {
  @discardableResult
  public func query<T: Decodable>(rowType type: T.Type, query: String) throws -> QueryResponse<T> {
    guard let connection = try anyIdleConnection() else {
      throw ClientError.noConnectionAvailable
    }

    do {
      // Step 1: Send the query to the server.
      try connection.send(payload: Query(query))

      connection.isIdle = false

      // Step 2: Parse the response.
      let response: GenericResponse = try connection.read()

      switch response {
      case .ERR(let context):
        connection.isIdle = true
        return .ERR(errorCode: context.errorCode, errorMessage: context.errorMessage)

      case .OK(let context):
        connection.isIdle = true
        return .OK(numberOfAffectedRows: context.numberOfAffectedRows, lastInsertId: context.lastInsertId, info: context.info)

      case .ResultSetColumnCount(let columnCount):
        let iterator = try QueryResultDecoder<T>(columnCount: columnCount, connection: connection)
        return .Results(iterator: AnyIterator {
          let next = iterator.next()
          if next == nil {
            connection.isIdle = true
          }
          return next
        })

      case .EOF:
        throw QueryError.unexpectedEofResponse
      }
    } catch let error {
      connection.isIdle = true
      throw error
    }
  }

  public typealias DictionaryRow = [String: String?]
  @discardableResult
  public func query(_ queryString: String) throws -> QueryResponse<DictionaryRow> {
    return try query(rowType: DictionaryRow.self, query: queryString)
  }
}

final class RowDecoder: Decoder {
  let columnDefinitions: [ColumnDefinition]
  let storage: [String: String?]
  init(columnDefinitions: [ColumnDefinition], values: [String?]) {
    self.columnDefinitions = columnDefinitions
    self.storage = Dictionary(uniqueKeysWithValues: zip(columnDefinitions.map { $0.name }, values))
  }

  var codingPath: [CodingKey] = []
  var userInfo: [CodingUserInfoKey: Any] = [:]

  func container<Key>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key> where Key: CodingKey {
    let container = RowKeyedDecodingContainer<Key>(decoder: self)
    return KeyedDecodingContainer(container)
  }

  func unkeyedContainer() throws -> UnkeyedDecodingContainer {
    preconditionFailure("Unimplemented")
  }

  func singleValueContainer() throws -> SingleValueDecodingContainer {
    precondition(storage.count == 1, "Only single-value responses are supported when converting to an array")
    return RowSingleValueDecodingContainer(decoder: self)
  }
}

private final class RowKeyedDecodingContainer<K: CodingKey>: KeyedDecodingContainerProtocol {
  typealias Key = K

  let codingPath: [CodingKey]
  var allKeys: [K] {
    return decoder.columnDefinitions.compactMap { Key(stringValue: $0.name) }
  }

  let decoder: RowDecoder
  init(decoder: RowDecoder) {
    self.decoder = decoder
    self.codingPath = decoder.codingPath
  }

  func contains(_ key: K) -> Bool {
    return decoder.storage[key.stringValue] != nil
  }

  func decodeNil(forKey key: K) throws -> Bool {
    guard let value = decoder.storage[key.stringValue] else {
      return true
    }
    return value == nil
  }

  func decode(_ type: String.Type, forKey key: K) throws -> String {
    return try decodeLossless(type, forKey: key)
  }

  func decode(_ type: Bool.Type, forKey key: K) throws -> Bool {
    return try decodeLossless(type, forKey: key)
  }

  func decode(_ type: Double.Type, forKey key: K) throws -> Double {
    return try decodeLossless(type, forKey: key)
  }

  func decode(_ type: Float.Type, forKey key: K) throws -> Float {
    return try decodeLossless(type, forKey: key)
  }

  func decode(_ type: Int.Type, forKey key: K) throws -> Int {
    return try decodeLossless(type, forKey: key)
  }

  func decode(_ type: Int8.Type, forKey key: K) throws -> Int8 {
    return try decodeLossless(type, forKey: key)
  }

  func decode(_ type: Int16.Type, forKey key: K) throws -> Int16 {
    return try decodeLossless(type, forKey: key)
  }

  func decode(_ type: Int32.Type, forKey key: K) throws -> Int32 {
    return try decodeLossless(type, forKey: key)
  }

  func decode(_ type: Int64.Type, forKey key: K) throws -> Int64 {
    return try decodeLossless(type, forKey: key)
  }

  func decode(_ type: UInt.Type, forKey key: K) throws -> UInt {
    return try decodeLossless(type, forKey: key)
  }

  func decode(_ type: UInt8.Type, forKey key: K) throws -> UInt8 {
    return try decodeLossless(type, forKey: key)
  }

  func decode(_ type: UInt16.Type, forKey key: K) throws -> UInt16 {
    return try decodeLossless(type, forKey: key)
  }

  func decode(_ type: UInt32.Type, forKey key: K) throws -> UInt32 {
    return try decodeLossless(type, forKey: key)
  }

  func decode(_ type: UInt64.Type, forKey key: K) throws -> UInt64 {
    return try decodeLossless(type, forKey: key)
  }

  func decode<T>(_ type: T.Type, forKey key: K) throws -> T where T: Decodable {
    // Special-case handling of Optional<String> decoding for [String: String?] support.
    if type is Optional<String>.Type {
      guard let valueOrNil = decoder.storage[key.stringValue] else {
        throw DecodingError.valueNotFound(type, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "\(key) was not found."))
      }
      return valueOrNil as! T
    }

    self.decoder.codingPath.append(key)
    defer { self.decoder.codingPath.removeLast() }
    return try T(from: decoder)
  }

  func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type, forKey key: K) throws -> KeyedDecodingContainer<NestedKey> where NestedKey: CodingKey {
    throw DecodingError.typeMismatch(type, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "\(key) was not convertible to \(type)."))
  }

  func nestedUnkeyedContainer(forKey key: K) throws -> UnkeyedDecodingContainer {
    throw NSError(domain: "libMySqlClient", code: -105, userInfo: nil)
  }

  func superDecoder() throws -> Decoder {
    throw NSError(domain: "libMySqlClient", code: -104, userInfo: nil)
  }

  func superDecoder(forKey key: K) throws -> Decoder {
    throw NSError(domain: "libMySqlClient", code: -103, userInfo: nil)
  }

  private func decodeLossless<T: LosslessStringConvertible>(_ type: T.Type, forKey key: K) throws -> T {
    guard let valueOrNil = decoder.storage[key.stringValue],
      let value = valueOrNil else {
        throw DecodingError.valueNotFound(type,
                                          DecodingError.Context(codingPath: decoder.codingPath,
                                                                debugDescription: "\(key) was not found."))
    }
    guard let typedValue = type.init(value) else {
      throw DecodingError.typeMismatch(type,
                                       DecodingError.Context(codingPath: decoder.codingPath,
                                                             debugDescription: "\(key.stringValue) was not convertible to \(type)."))
    }
    return typedValue
  }
}

private final class RowSingleValueDecodingContainer: SingleValueDecodingContainer {
  let codingPath: [CodingKey]

  let decoder: RowDecoder
  init(decoder: RowDecoder) {
    self.decoder = decoder
    self.codingPath = decoder.codingPath
  }

  func decodeNil() -> Bool {
    guard let element = decoder.storage.first else {
      return true
    }
    return element.value == nil
  }

  func decode(_ type: Bool.Type) throws -> Bool {
    return try decodeLossless(type)
  }

  func decode(_ type: String.Type) throws -> String {
    return try decodeLossless(type)
  }

  func decode(_ type: Double.Type) throws -> Double {
    return try decodeLossless(type)
  }

  func decode(_ type: Float.Type) throws -> Float {
    return try decodeLossless(type)
  }

  func decode(_ type: Int.Type) throws -> Int {
    return try decodeLossless(type)
  }

  func decode(_ type: Int8.Type) throws -> Int8 {
    return try decodeLossless(type)
  }

  func decode(_ type: Int16.Type) throws -> Int16 {
    return try decodeLossless(type)
  }

  func decode(_ type: Int32.Type) throws -> Int32 {
    return try decodeLossless(type)
  }

  func decode(_ type: Int64.Type) throws -> Int64 {
    return try decodeLossless(type)
  }

  func decode(_ type: UInt.Type) throws -> UInt {
    return try decodeLossless(type)
  }

  func decode(_ type: UInt8.Type) throws -> UInt8 {
    return try decodeLossless(type)
  }

  func decode(_ type: UInt16.Type) throws -> UInt16 {
    return try decodeLossless(type)
  }

  func decode(_ type: UInt32.Type) throws -> UInt32 {
    return try decodeLossless(type)
  }

  func decode(_ type: UInt64.Type) throws -> UInt64 {
    return try decodeLossless(type)
  }

  func decode<T>(_ type: T.Type) throws -> T where T: Decodable {
    // Special-case handling of Optional<String> decoding for [String: String?] support.
    if type is Optional<String>.Type {
      guard let element = decoder.storage.first else {
        throw DecodingError.valueNotFound(type, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "value was not found."))
      }
      return element.value as! T
    }

    return try T(from: decoder)
  }

  private func decodeLossless<T: LosslessStringConvertible>(_ type: T.Type) throws -> T {
    guard let element = decoder.storage.first,
      let value = element.value else {
        throw DecodingError.valueNotFound(type, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Value was not found."))
    }
    guard let typedValue = type.init(value) else {
      throw DecodingError.typeMismatch(type, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "\(value) was not convertible to \(type)."))
    }
    return typedValue
  }
}
