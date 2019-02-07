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

public final class PacketDecoder {
  func decode<T, I>(_ type: T.Type, from iterator: I) throws -> T where T : Decodable, I: IteratorProtocol, I.Element == UInt8 {
    let decoder = try _PacketDecoder(iterator: iterator)
    return try T.init(from: decoder)
  }
}

private final class _PacketDecoder<IteratorType: IteratorProtocol>: Decoder where IteratorType.Element == UInt8 {
  var iter: IteratorType
  let length: UInt32
  let sequenceNumber: UInt8
  let payloadBytes: [UInt8]

  /**
   Reads the packet's header and payload data in preparation for decoding.
   */
  init(iterator: IteratorType) throws {
    self.iter = iterator

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

    self.payloadBytes = [UInt8](iter.next(maxLength: Int(length)))
    if self.payloadBytes.count != self.length {
      throw DecodingError.dataCorrupted(.init(codingPath: [], debugDescription: "Unable to read packet payload."))
    }
  }

  // MARK: Decoder

  var codingPath: [CodingKey] = []
  var userInfo: [CodingUserInfoKey: Any] = [:]

  func unkeyedContainer() throws -> UnkeyedDecodingContainer {
    return PacketDecodingContainer(bytes: payloadBytes)
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

private struct PacketDecodingContainer: UnkeyedDecodingContainer {
  let bytes: [UInt8]
  init(bytes: [UInt8]) {
    self.bytes = bytes
  }

  var codingPath: [CodingKey] = []
  var count: Int? = nil
  var isAtEnd: Bool {
    return currentIndex == bytes.count
  }
  var currentIndex: Int = 0

  mutating func decodeNil() throws -> Bool {
    preconditionFailure("Unimplemented.")
  }

  mutating func decode(_ type: Bool.Type) throws -> Bool {
    preconditionFailure("Unimplemented.")
  }

  mutating func decode(_ type: String.Type) throws -> String {
    preconditionFailure("Unimplemented.")
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
    preconditionFailure("Unimplemented.")
  }

  mutating func decodeFixedWidthInteger<T>(_ type: T.Type) throws -> T where T : FixedWidthInteger {
    let byteWidth = type.bitWidth / 8
    return Data(bytes[0..<byteWidth]).withUnsafeBytes { (ptr: UnsafePointer<T>) -> T in
      return ptr.pointee
    }
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
