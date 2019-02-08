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
 An object that decodes instances of a data type from a byte stream.

 For a type to be decodable with this instance it must override the default `init(from decoder:)` implementation and
 use the decoder's unkeyedContainer.

 Documentation: https://dev.mysql.com/doc/internals/en/mysql-packet.html
 */
public struct BinaryStreamDecoder {
  public init() {}

  /**
   Returns a type you specify, decoded from a byte iterator.

   If the iterator does not represent a well-formed MySql packet, then an error will be thrown.

   - Parameter type: The payload type of the instance to be decoded.
   - Parameter iterator: A stream of bytes to decode the instance from.
   - Returns: An instance of `type` decoded from the iterator's byte stream.
   */
  public func decode<T, I>(_ type: T.Type, from iterator: I) throws -> T where T: Decodable, I: IteratorProtocol, I.Element == UInt8 {
    let storage = BinaryStorage(iterator: iterator)
    return try T.init(from: _BinaryStreamDecoder(storage: storage))
  }

  public func decode<T>(_ type: T.Type, from data: Data) throws -> T where T: Decodable {
    return try decode(type, from: data.makeIterator())
  }

  public func decode<T>(_ type: T.Type, from bytes: [UInt8]) throws -> T where T: Decodable {
    return try decode(type, from: bytes.makeIterator())
  }
}

extension CodingUserInfoKey {
  static let binaryStreamDecoderContext = CodingUserInfoKey(rawValue: "BinaryStreamDecoder.context")!
}

public class BinaryStreamDecoderContext {
  public var remainingBytes: UInt64? = nil
}

/**
 A shared representation of the remaining payload data for a given packet.

 This type is intentionally a class type so that its storage is shared across references.
 */
private final class BinaryStorage<I> where I: IteratorProtocol, I.Element == UInt8 {
  /**
   The remaining bytes to be decoded of the payload.

   Modified as values are decoded.
   */
  private var iterator: AnyIterator<UInt8>

  let context = BinaryStreamDecoderContext()

  /**
   Initializes this storage instance with the packet's payload bytes.

   - Parameter bytes: The payload's byte representation.
   */
  init(iterator: I) {
    var iter = iterator
    let context = self.context
    self.iterator = AnyIterator<UInt8> {
      if let remainingBytes = context.remainingBytes {
        if remainingBytes == 0 {
          return nil
        }
        context.remainingBytes = remainingBytes - 1
      }
      return iter.next()
    }
  }

  // Common decoding methods

  func decodeNullTerminatedString() throws -> String {
    let result = iterator.next(until: { $0 == 0 })
    if result.didReachEnd {
      throw DecodingError.dataCorrupted(.init(codingPath: [], debugDescription: "Did not find null terminator for string."))
    }
    let encoding = String.Encoding.utf8
    guard let string = String(data: Data(result.values), encoding: encoding) else {
      throw DecodingError.dataCorrupted(.init(codingPath: [],
                                              debugDescription: "Unable to parse string from data using \(encoding) encoding."))
    }
    return string
  }

  func decodeByte() throws -> UInt8 {
    guard let byte = iterator.next() else {
      throw DecodingError.dataCorrupted(.init(codingPath: [], debugDescription: "Not enough data to read a byte."))
    }
    return byte
  }

  func decodeFixedWidthInteger<T>(_ type: T.Type) throws -> T where T: FixedWidthInteger {
    let byteWidth = type.bitWidth / 8
    let bytes = iterator.next(maxLength: byteWidth)
    if bytes.count < byteWidth {
      throw DecodingError.dataCorrupted(.init(codingPath: [], debugDescription: "Not enough data to parse a \(type)."))
    }
    let value = Data(bytes).withUnsafeBytes { (ptr: UnsafePointer<T>) -> T in
      return ptr.pointee
    }
    return value
  }
}

private struct _BinaryStreamDecoder<I>: Decoder where I: IteratorProtocol, I.Element == UInt8 {
  private let storage: BinaryStorage<I>

  init(storage: BinaryStorage<I>) throws {
    self.storage = storage
    self.userInfo = [.binaryStreamDecoderContext: storage.context]
  }

  var codingPath: [CodingKey] = []
  var userInfo: [CodingUserInfoKey: Any]

  func unkeyedContainer() throws -> UnkeyedDecodingContainer {
    return BinaryStreamUnkeyedDecodingContainer(storage: storage)
  }

  func container<Key>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key> where Key: CodingKey {
    throw DecodingError.typeMismatch(type, .init(codingPath: codingPath,
                                                 debugDescription: "Keyed decoding is unsupported."))
  }

  func singleValueContainer() throws -> SingleValueDecodingContainer {
    return BinaryStreamSingleValueDecodingContainer(storage: storage)
  }
}

private struct BinaryStreamUnkeyedDecodingContainer<I>: UnkeyedDecodingContainer where I: IteratorProtocol, I.Element == UInt8 {
  private let storage: BinaryStorage<I>

  init(storage: BinaryStorage<I>) {
    self.storage = storage
  }

  let codingPath: [CodingKey] = []
  var count: Int? { return nil }
  var isAtEnd: Bool { return false }
  var currentIndex: Int { return 0 }

  mutating func decodeNil() throws -> Bool {
    preconditionFailure("Unimplemented.")
  }

  mutating func decode(_ type: Bool.Type) throws -> Bool {
    preconditionFailure("Unimplemented.")
  }

  mutating func decode(_ type: String.Type) throws -> String {
    return try storage.decodeNullTerminatedString()
  }

  mutating func decode(_ type: Double.Type) throws -> Double {
    preconditionFailure("Unimplemented.")
  }

  mutating func decode(_ type: Float.Type) throws -> Float {
    preconditionFailure("Unimplemented.")
  }

  mutating func decode(_ type: Int.Type) throws -> Int {
    return try storage.decodeFixedWidthInteger(type)
  }

  mutating func decode(_ type: Int8.Type) throws -> Int8 {
    return try storage.decodeFixedWidthInteger(type)
  }

  mutating func decode(_ type: Int16.Type) throws -> Int16 {
    return try storage.decodeFixedWidthInteger(type)
  }

  mutating func decode(_ type: Int32.Type) throws -> Int32 {
    return try storage.decodeFixedWidthInteger(type)
  }

  mutating func decode(_ type: Int64.Type) throws -> Int64 {
    return try storage.decodeFixedWidthInteger(type)
  }

  mutating func decode(_ type: UInt.Type) throws -> UInt {
    return try storage.decodeFixedWidthInteger(type)
  }

  mutating func decode(_ type: UInt8.Type) throws -> UInt8 {
    return try storage.decodeByte()
  }

  mutating func decode(_ type: UInt16.Type) throws -> UInt16 {
    return try storage.decodeFixedWidthInteger(type)
  }

  mutating func decode(_ type: UInt32.Type) throws -> UInt32 {
    return try storage.decodeFixedWidthInteger(type)
  }

  mutating func decode(_ type: UInt64.Type) throws -> UInt64 {
    return try storage.decodeFixedWidthInteger(type)
  }

  mutating func decode<T>(_ type: T.Type) throws -> T where T: Decodable {
    return try T.init(from: _BinaryStreamDecoder(storage: storage))
  }

  mutating func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type) throws -> KeyedDecodingContainer<NestedKey> where NestedKey: CodingKey {
    preconditionFailure("Unimplemented.")
  }

  mutating func nestedUnkeyedContainer() throws -> UnkeyedDecodingContainer {
    preconditionFailure("Unimplemented.")
  }

  mutating func superDecoder() throws -> Decoder {
    preconditionFailure("Unimplemented.")
  }
}

private struct BinaryStreamSingleValueDecodingContainer<I>: SingleValueDecodingContainer where I: IteratorProtocol, I.Element == UInt8 {
  private var storage: BinaryStorage<I>
  init(storage: BinaryStorage<I>) {
    self.storage = storage
  }

  var codingPath: [CodingKey] = []

  func decodeNil() -> Bool {
    preconditionFailure("Unimplemented.")
  }

  func decode(_ type: Bool.Type) throws -> Bool {
    preconditionFailure("Unimplemented.")
  }

  func decode(_ type: String.Type) throws -> String {
    preconditionFailure("Unimplemented.")
  }

  func decode(_ type: Double.Type) throws -> Double {
    preconditionFailure("Unimplemented.")
  }

  func decode(_ type: Float.Type) throws -> Float {
    preconditionFailure("Unimplemented.")
  }

  func decode(_ type: Int.Type) throws -> Int {
    return try storage.decodeFixedWidthInteger(type)
  }

  func decode(_ type: Int8.Type) throws -> Int8 {
    return try storage.decodeFixedWidthInteger(type)
  }

  func decode(_ type: Int16.Type) throws -> Int16 {
    return try storage.decodeFixedWidthInteger(type)
  }

  func decode(_ type: Int32.Type) throws -> Int32 {
    return try storage.decodeFixedWidthInteger(type)
  }

  func decode(_ type: Int64.Type) throws -> Int64 {
    return try storage.decodeFixedWidthInteger(type)
  }

  func decode(_ type: UInt.Type) throws -> UInt {
    return try storage.decodeFixedWidthInteger(type)
  }

  func decode(_ type: UInt8.Type) throws -> UInt8 {
    return try storage.decodeByte()
  }

  func decode(_ type: UInt16.Type) throws -> UInt16 {
    return try storage.decodeFixedWidthInteger(type)
  }

  func decode(_ type: UInt32.Type) throws -> UInt32 {
    return try storage.decodeFixedWidthInteger(type)
  }

  func decode(_ type: UInt64.Type) throws -> UInt64 {
    return try storage.decodeFixedWidthInteger(type)
  }

  func decode<T>(_ type: T.Type) throws -> T where T: Decodable {
    preconditionFailure("Unimplemented.")
  }
}

