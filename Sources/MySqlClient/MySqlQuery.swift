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

import Foundation

/**
 A type-safe MySql query builder.
 */
public final class MySqlQuery {
  public init() {}

  /**
   Returns a query string for inserting an Encodable object into a MySql database.
   */
  public func insert<T>(
    _ object: T,
    intoTable table: String,
    ignoredFields: [String] = [],
    duplicateKeyBehaviors: [String: QueryDuplicateKeyBehavior] = [:]
  ) throws -> String where T: Encodable {
    let encoder = InsertQueryEncoder(ignoredFields: ignoredFields, duplicateKeyBehaviors: duplicateKeyBehaviors)
    try object.encode(to: encoder)
    return "INSERT INTO \(table) \(encoder.query())"
  }
}

public enum QueryDuplicateKeyBehavior {
  case update
  case max
}

private final class InsertQueryEncoder: Encoder {
  var codingPath: [CodingKey] = []
  var userInfo: [CodingUserInfoKey: Any] = [:]

  var storage: [String: String] = [:]
  var arrayStorage: [[String: String]] = []

  let ignoredFields: Set<String>
  let duplicateKeyBehaviors: [String: QueryDuplicateKeyBehavior]
  init(ignoredFields: [String], duplicateKeyBehaviors: [String: QueryDuplicateKeyBehavior]) {
    self.ignoredFields = Set<String>(ignoredFields)
    self.duplicateKeyBehaviors = duplicateKeyBehaviors
  }

  func query() -> String {
    if !storage.isEmpty {
      arrayStorage.append(storage)
    }

    let keys = arrayStorage.map { $0.keys }.reduce(Set<String>()) { $0.union($1) }.subtracting(self.ignoredFields).sorted()

    let values = arrayStorage.map { row -> [String] in
      keys.map { row[$0] }.map {
          // http://php.net/manual/en/function.mysql-real-escape-string.php
          $0?
            .replacingOccurrences(of: "\\", with: "\\\\")
            .replacingOccurrences(of: "\n", with: "\\\n")
            .replacingOccurrences(of: "\r", with: "\\\r")
            .replacingOccurrences(of: "'", with: "\\'")
            .replacingOccurrences(of: "\"", with: "\\\"")
        }.map {
          if let string = $0 {
            return "\"\(string)\""
          } else {
            preconditionFailure("Couldn't find value")
          }
        }
      }.map { "(\($0.joined(separator: ",")))" }
    let updates: [String] = keys.map { key in
      switch duplicateKeyBehaviors[key] {
      case .some(.max):
        return "`\(key)`=GREATEST(VALUES(`\(key)`),`\(key)`)"
      default:
        return "`\(key)`=VALUES(`\(key)`)"
      }
    }
    return "(`\(keys.joined(separator: "`,`"))`) VALUES \(values.joined(separator: ",")) ON DUPLICATE KEY UPDATE \(updates.joined(separator: ","))"
  }

  func container<Key>(keyedBy type: Key.Type) -> KeyedEncodingContainer<Key> where Key: CodingKey {
    let container = InsertKeyedEncodingContainer<Key>(encoder: self)
    return KeyedEncodingContainer(container)
  }

  func unkeyedContainer() -> UnkeyedEncodingContainer {
    return InsertUnkeyedEncodingContainer(encoder: self)
  }

  func singleValueContainer() -> SingleValueEncodingContainer {
    preconditionFailure("Unimplemented.")
  }
}

private final class InsertKeyedEncodingContainer<K: CodingKey>: KeyedEncodingContainerProtocol {
  typealias Key = K

  let codingPath: [CodingKey]
  let encoder: InsertQueryEncoder
  init(encoder: InsertQueryEncoder) {
    self.encoder = encoder
    self.codingPath = encoder.codingPath
  }

  func encodeNil(forKey key: K) throws {
    encoder.storage[key.stringValue] = nil
  }

  func encode(_ value: Bool, forKey key: K) throws {
    encoder.storage[key.stringValue] = String(value)
  }

  func encode(_ value: String, forKey key: K) throws {
    encoder.storage[key.stringValue] = String(value)
  }

  func encode(_ value: Double, forKey key: K) throws {
    encoder.storage[key.stringValue] = String(value)
  }

  func encode(_ value: Float, forKey key: K) throws {
    encoder.storage[key.stringValue] = String(value)
  }

  func encode(_ value: Int, forKey key: K) throws {
    encoder.storage[key.stringValue] = String(value)
  }

  func encode(_ value: Int8, forKey key: K) throws {
    encoder.storage[key.stringValue] = String(value)
  }

  func encode(_ value: Int16, forKey key: K) throws {
    encoder.storage[key.stringValue] = String(value)
  }

  func encode(_ value: Int32, forKey key: K) throws {
    encoder.storage[key.stringValue] = String(value)
  }

  func encode(_ value: Int64, forKey key: K) throws {
    encoder.storage[key.stringValue] = String(value)
  }

  func encode(_ value: UInt, forKey key: K) throws {
    encoder.storage[key.stringValue] = String(value)
  }

  func encode(_ value: UInt8, forKey key: K) throws {
    encoder.storage[key.stringValue] = String(value)
  }

  func encode(_ value: UInt16, forKey key: K) throws {
    encoder.storage[key.stringValue] = String(value)
  }

  func encode(_ value: UInt32, forKey key: K) throws {
    encoder.storage[key.stringValue] = String(value)
  }

  func encode(_ value: UInt64, forKey key: K) throws {
    encoder.storage[key.stringValue] = String(value)
  }

  func encode<T>(_ value: T, forKey key: K) throws where T: Encodable {
    preconditionFailure("Unimplemented.")
  }

  func nestedContainer<NestedKey>(keyedBy keyType: NestedKey.Type, forKey key: K) -> KeyedEncodingContainer<NestedKey> where NestedKey: CodingKey {
    preconditionFailure("Unimplemented.")
  }

  func nestedUnkeyedContainer(forKey key: K) -> UnkeyedEncodingContainer {
    preconditionFailure("Unimplemented.")
  }

  func superEncoder() -> Encoder {
    preconditionFailure("Unimplemented.")
  }

  func superEncoder(forKey key: K) -> Encoder {
    preconditionFailure("Unimplemented.")
  }
}

private final class InsertUnkeyedEncodingContainer: UnkeyedEncodingContainer {
  let codingPath: [CodingKey]
  let encoder: InsertQueryEncoder
  init(encoder: InsertQueryEncoder) {
    self.encoder = encoder
    self.codingPath = encoder.codingPath
  }

  var count: Int = 0

  func encode(_ value: Bool) throws {
    preconditionFailure("Unimplemented.")
  }

  func encodeNil() throws {
    preconditionFailure("Unimplemented.")
  }

  func encode(_ value: String) throws {
    preconditionFailure("Unimplemented.")
  }

  func encode(_ value: Double) throws {
    preconditionFailure("Unimplemented.")
  }

  func encode(_ value: Float) throws {
    preconditionFailure("Unimplemented.")
  }

  func encode(_ value: Int) throws {
    preconditionFailure("Unimplemented.")
  }

  func encode(_ value: Int8) throws {
    preconditionFailure("Unimplemented.")
  }

  func encode(_ value: Int16) throws {
    preconditionFailure("Unimplemented.")
  }

  func encode(_ value: Int32) throws {
    preconditionFailure("Unimplemented.")
  }

  func encode(_ value: Int64) throws {
    preconditionFailure("Unimplemented.")
  }

  func encode(_ value: UInt) throws {
    preconditionFailure("Unimplemented.")
  }

  func encode(_ value: UInt8) throws {
    preconditionFailure("Unimplemented.")
  }

  func encode(_ value: UInt16) throws {
    preconditionFailure("Unimplemented.")
  }

  func encode(_ value: UInt32) throws {
    preconditionFailure("Unimplemented.")
  }

  func encode(_ value: UInt64) throws {
    preconditionFailure("Unimplemented.")
  }

  func encode<T>(_ value: T) throws where T: Encodable {
    count += 1
    try value.encode(to: self.encoder)
    self.encoder.arrayStorage.append(self.encoder.storage)
    self.encoder.storage.removeAll()
  }

  func nestedContainer<NestedKey>(keyedBy keyType: NestedKey.Type) -> KeyedEncodingContainer<NestedKey> where NestedKey: CodingKey {
    preconditionFailure("Unimplemented.")
  }

  func nestedUnkeyedContainer() -> UnkeyedEncodingContainer {
    preconditionFailure("Unimplemented.")
  }

  func superEncoder() -> Encoder {
    preconditionFailure("Unimplemented.")
  }

}
