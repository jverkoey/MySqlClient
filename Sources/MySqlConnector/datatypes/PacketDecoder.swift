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
import IteratorProtocol_next

/**
 An object that decodes instances of a data type from a byte stream.

 For a type to be decodable with this instance it must override the default `init(from decoder:)` implementation and
 use the decoder's unkeyedContainer. For example:

     init(from decoder: Decoder) throws {
       var container = try decoder.unkeyedContainer()
       self.unsignedValue = try container.decode(type(of: unsignedValue))
       self.enumValue = try container.decode(type(of: enumValue))
       self.signedValue = try container.decode(type(of: signedValue))
     }

 Documentation: https://dev.mysql.com/doc/internals/en/mysql-packet.html
 */
public struct PacketDecoder {
  public init() {}

  /**
   Returns a MySql packet payload type you specify, decoded from a byte iterator.

   If the iterator does not represent a well-formed MySql packet, then an error will be thrown.

   - Parameter type: The payload type of the instance to be decoded.
   - Parameter iterator: A stream of bytes to decode the instance from.
   - Returns: An instance of `type` decoded from the iterator's byte stream.
   */
  public func decode<T, I>(_ type: T.Type, from iterator: I) throws -> T where T: Decodable, I: IteratorProtocol, I.Element == UInt8 {
    return try T.init(from: _PacketDecoder(iterator: iterator))
  }
}

/**
 A shared representation of the remaining payload data for a given packet.

 This type is intentionally a class type so that its storage is shared across references.
 */
private final class PayloadStorage {
  /**
   The remaining bytes to be decoded of the payload.

   Modified as values are decoded.
   */
  private var bytes: ArraySlice<UInt8>

  /**
   Initializes this storage instance with the packet's payload bytes.

   - Parameter bytes: The payload's byte representation.
   */
  init(payload bytes: [UInt8]) {
    self.bytes = bytes[0...]
  }

  var isAtEnd: Bool {
    return bytes.count == 0
  }
  var currentIndex: Int {
    return bytes.startIndex
  }

  // Common decoding methods

  func decodeNullTerminatedString() throws -> String {
    guard let length = bytes.firstIndex(of: 0) else {
      throw DecodingError.dataCorrupted(.init(codingPath: [],
                                              debugDescription: "Unable to find null terminator for string."))
    }
    let encoding = String.Encoding.utf8
    guard let string = String(data: Data(bytes[..<length]), encoding: encoding) else {
      throw DecodingError.dataCorrupted(.init(codingPath: [],
                                              debugDescription: "Unable to parse string from data using \(encoding) encoding."))
    }
    bytes = bytes[(length + 1)...]
    return string
  }

  func decodeFixedWidthInteger<T>(_ type: T.Type) throws -> T where T : FixedWidthInteger {
    let byteWidth = type.bitWidth / 8
    if bytes.count < byteWidth {
      throw DecodingError.dataCorrupted(.init(codingPath: [], debugDescription: "Not enough data to parse a \(type)"))
    }
    let index = (bytes.startIndex + byteWidth)
    let value = Data(bytes[..<index]).withUnsafeBytes { (ptr: UnsafePointer<T>) -> T in
      return ptr.pointee
    }
    bytes = bytes[index...]
    return value
  }
}

private final class _PacketDecoder<I>: Decoder where I: IteratorProtocol, I.Element == UInt8 {
  let storage: PayloadStorage
  let codingPath: [CodingKey] = []
  let userInfo: [CodingUserInfoKey: Any] = [:]

  /**
   Reads the packet's header and payload data in preparation for decoding.
   */
  init(iterator: I) throws {
    var iter = iterator

    // MySql documentation: https://dev.mysql.com/doc/internals/en/mysql-packet.html
    // > If a MySQL client or server wants to send data, it:
    // > - Splits the data into packets of size 2^24 − 1 bytes
    // > - Prepends to each chunk a packet header
    //
    // The packet header is composed of:
    // - 3 bytes describing the length of the packet (not including the header).
    // - 1 byte describing the packet's sequence number.

    let lengthData = iter.next(maxLength: 3)
    guard lengthData.count == 3 else {
      throw DecodingError.dataCorrupted(.init(codingPath: [],
                                              debugDescription: "Unable to read packet length."))
    }
    let length = Data(lengthData + [0]).withUnsafeBytes { (ptr: UnsafePointer<UInt32>) -> UInt32 in
      return ptr.pointee
    }

    // Sequence number
    guard iter.next() != nil else {
      throw DecodingError.dataCorrupted(.init(codingPath: [],
                                              debugDescription: "Unable to read packet sequence number."))
    }

    let payloadBytes = iter.next(maxLength: Int(length))
    if payloadBytes.count < length {
      throw DecodingError.dataCorrupted(.init(codingPath: [],
                                              debugDescription: "Packet is missing payload data."))
    }
    self.storage = PayloadStorage(payload: payloadBytes)
  }

  // MARK: Decoder

  func unkeyedContainer() throws -> UnkeyedDecodingContainer {
    return PacketUnkeyedDecodingContainer(storage: storage)
  }

  func container<Key>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key> where Key: CodingKey {
    throw DecodingError.typeMismatch(type, .init(codingPath: codingPath,
                                                 debugDescription: "Keyed decoding is unsupported."))
  }

  func singleValueContainer() throws -> SingleValueDecodingContainer {
    throw DecodingError.typeMismatch(type(of: self), .init(codingPath: codingPath,
                                                           debugDescription: "Single value decoding is unsupported."))
  }
}

private final class _PayloadDecoder: Decoder {
  let storage: PayloadStorage

  init(storage: PayloadStorage) throws {
    self.storage = storage
  }

  var codingPath: [CodingKey] = []
  var userInfo: [CodingUserInfoKey: Any] = [:]

  func unkeyedContainer() throws -> UnkeyedDecodingContainer {
    return PacketUnkeyedDecodingContainer(storage: storage)
  }

  func container<Key>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key> where Key: CodingKey {
    throw DecodingError.typeMismatch(type, .init(codingPath: codingPath,
                                                 debugDescription: "Keyed decoding is unsupported."))
  }

  func singleValueContainer() throws -> SingleValueDecodingContainer {
    return PacketSingleValueDecodingContainer(storage: storage)
  }
}

private struct PacketUnkeyedDecodingContainer: UnkeyedDecodingContainer {
  private let storage: PayloadStorage
  init(storage: PayloadStorage) {
    self.storage = storage
  }

  let codingPath: [CodingKey] = []
  let count: Int? = nil
  var isAtEnd: Bool { return storage.isAtEnd }
  var currentIndex: Int { return storage.currentIndex }

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
    return try decodeFixedWidthInteger(type)
  }

  mutating func decode(_ type: Int8.Type) throws -> Int8 {
    return try decodeFixedWidthInteger(type)
  }

  mutating func decode(_ type: Int16.Type) throws -> Int16 {
    return try decodeFixedWidthInteger(type)
  }

  mutating func decode(_ type: Int32.Type) throws -> Int32 {
    return try decodeFixedWidthInteger(type)
  }

  mutating func decode(_ type: Int64.Type) throws -> Int64 {
    return try decodeFixedWidthInteger(type)
  }

  mutating func decode(_ type: UInt.Type) throws -> UInt {
    return try decodeFixedWidthInteger(type)
  }

  mutating func decode(_ type: UInt8.Type) throws -> UInt8 {
    return try decodeFixedWidthInteger(type)
  }

  mutating func decode(_ type: UInt16.Type) throws -> UInt16 {
    return try decodeFixedWidthInteger(type)
  }

  mutating func decode(_ type: UInt32.Type) throws -> UInt32 {
    return try decodeFixedWidthInteger(type)
  }

  mutating func decode(_ type: UInt64.Type) throws -> UInt64 {
    return try decodeFixedWidthInteger(type)
  }

  mutating func decode<T>(_ type: T.Type) throws -> T where T : Decodable {
    return try T.init(from: _PayloadDecoder(storage: storage))
  }

  mutating func decodeFixedWidthInteger<T>(_ type: T.Type) throws -> T where T : FixedWidthInteger {
    return try storage.decodeFixedWidthInteger(type)
  }

  mutating func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type) throws -> KeyedDecodingContainer<NestedKey> where NestedKey : CodingKey {
    preconditionFailure("Unimplemented.")
  }

  mutating func nestedUnkeyedContainer() throws -> UnkeyedDecodingContainer {
    preconditionFailure("Unimplemented.")
  }

  mutating func superDecoder() throws -> Decoder {
    preconditionFailure("Unimplemented.")
  }
}

private struct PacketSingleValueDecodingContainer: SingleValueDecodingContainer {
  private var storage: PayloadStorage
  init(storage: PayloadStorage) {
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
    return try decodeFixedWidthInteger(type)
  }

  func decode(_ type: Int8.Type) throws -> Int8 {
    return try decodeFixedWidthInteger(type)
  }

  func decode(_ type: Int16.Type) throws -> Int16 {
    return try decodeFixedWidthInteger(type)
  }

  func decode(_ type: Int32.Type) throws -> Int32 {
    return try decodeFixedWidthInteger(type)
  }

  func decode(_ type: Int64.Type) throws -> Int64 {
    return try decodeFixedWidthInteger(type)
  }

  func decode(_ type: UInt.Type) throws -> UInt {
    return try decodeFixedWidthInteger(type)
  }

  func decode(_ type: UInt8.Type) throws -> UInt8 {
    return try decodeFixedWidthInteger(type)
  }

  func decode(_ type: UInt16.Type) throws -> UInt16 {
    return try decodeFixedWidthInteger(type)
  }

  func decode(_ type: UInt32.Type) throws -> UInt32 {
    return try decodeFixedWidthInteger(type)
  }

  func decode(_ type: UInt64.Type) throws -> UInt64 {
    return try decodeFixedWidthInteger(type)
  }

  func decode<T>(_ type: T.Type) throws -> T where T : Decodable {
    preconditionFailure("Unimplemented.")
  }

  func decodeFixedWidthInteger<T>(_ type: T.Type) throws -> T where T : FixedWidthInteger {
    return try storage.decodeFixedWidthInteger(type)
  }
}
