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

public struct PacketDecoder {
  public init() {}

  public func decode<T, I>(_ type: T.Type, from iterator: I) throws -> T where T : Decodable, I: IteratorProtocol, I.Element == UInt8 {
    let decoder = try _PacketDecoder(iterator: iterator)
    return try T.init(from: decoder)
  }
}

private final class PayloadStorage {
  var bytes: ArraySlice<UInt8>
  init(bytes: [UInt8]) {
    self.bytes = bytes[0...]
  }

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
  let length: UInt32
  let sequenceNumber: UInt8
  let storage: PayloadStorage

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

    // Packet length is 3 bytes.
    let lengthData = iter.next(maxLength: 3)
    guard lengthData.count == 3 else {
      throw DecodingError.dataCorrupted(.init(codingPath: [], debugDescription: "Unable to read packet length."))
    }
    self.length = Data(lengthData + [0]).withUnsafeBytes { (ptr: UnsafePointer<UInt32>) -> UInt32 in
      return ptr.pointee
    }

    // Sequence number is 1 byte.
    guard let sequenceNumber = iter.next() else {
      throw DecodingError.dataCorrupted(.init(codingPath: [], debugDescription: "Unable to read packet sequence number."))
    }
    self.sequenceNumber = sequenceNumber

    self.storage = PayloadStorage(bytes: iter.next(maxLength: Int(length)))
    if self.storage.bytes.count != self.length {
      throw DecodingError.dataCorrupted(.init(codingPath: [], debugDescription: "Unable to read packet payload."))
    }
  }

  // MARK: Decoder

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
    throw DecodingError.typeMismatch(type(of: self), .init(codingPath: codingPath,
                                                           debugDescription: "Single value decoding is unsupported."))
  }
}

private final class _PayloadDecoder: Decoder {
  let storage: PayloadStorage

  init(storage: PayloadStorage) throws {
    self.storage = storage
  }

  // MARK: Decoder

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

  var codingPath: [CodingKey] = []
  var count: Int? = nil
  var isAtEnd: Bool {
    return storage.bytes.count == 0
  }
  var currentIndex: Int {
    return storage.bytes.startIndex
  }

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
