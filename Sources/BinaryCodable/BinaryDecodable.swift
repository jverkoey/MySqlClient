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

// Note: the types described below are based off - but distinct from - Swift's Codable family of APIs.

/**
 A type that can decode itself from an external binary representation.
 */
public protocol BinaryDecodable {

  /**
   Creates a new instance by decoding from the given binary decoder.

   - parameter decoder: The binary decoder to decode the type from.
   - throws: if reading from the binary decoder fails, or if the data read is corrupted or otherwise invalid.
   */
  init(from decoder: BinaryDecoder) throws
}

public typealias BinaryCodingUserInfoKey = String

/**
 A type that can decode values from a native format into in-memory representations.
 */
public protocol BinaryDecoder {
  /**
   Any contextual information set by the user for encoding.
   */
  var userInfo: [BinaryCodingUserInfoKey : Any] { get }

  /**
   Returns the data stored in this decoder as represented in a container with an optional maximum length.

   Providing a non-nil maxLength reduces the likelihood of a decoder reading past the edge of a block of memory. When
   possible, provide a max length.

   - parameter maxLength: The maximum number of bytes that this container is allowed to decode up to. If nil, then
   this container is able to read an infinite number of bytes.
   - returns: A container view into this decoder.
   */
  func container(maxLength: Int?) -> BinaryDecodingContainer
}

/**
 An error that occurs during the binary decoding of a value.
 */
public enum BinaryDecodingError : Error {

  /**
   The context in which the error occurred.
   */
  public struct Context {

    /**
     A description of what went wrong, for debugging purposes.
     */
    public let debugDescription: String

    /**
     The underlying error which caused this error, if any.
     */
    public let underlyingError: Error?

    /**
     Creates a new context with the given description of what went wrong.

     - parameter debugDescription: A description of what went wrong, for debugging purposes.
     - parameter underlyingError: The underlying error which caused this error, if any.
     */
    public init(debugDescription: String, underlyingError: Error? = nil) {
      self.debugDescription = debugDescription
      self.underlyingError = underlyingError
    }
  }

  /**
   An indication that the data is corrupted or otherwise invalid.

   As an associated value, this case contains the context for debugging.
   */
  case dataCorrupted(Context)
}

/**
 A type that provides a view into a decoder's storage and is used to hold the encoded properties of a decodable type
 sequentially.
 */
public protocol BinaryDecodingContainer {

  /**
   A Boolean value indicating whether there are no more elements left to be decoded in the container.
   */
  var isAtEnd: Bool { get }

  /**
   Returns a Boolean value indicating whether there are at least `minBytes` remaining to be decoded.
   */
  func hasAtLeast(minBytes: Int) throws -> Bool

  /**
   Decodes a String value using the given encoding up until a given delimiter is encountered.

   - parameter type: The type of value to decode.
   - parameter encoding: The string encoding to use when creating the string representation from data.
   - parameter terminator: Typically 0. The string will stop being decoded once the terminator is encountered.
   - returns: A value of the requested type.
   */
  mutating func decode(_ type: String.Type, encoding: String.Encoding, terminator: UInt8) throws -> String

  /**
   Decodes a String value using the given encoding up until the end of the available data.

   - parameter type: The type of value to decode.
   - parameter encoding: The string encoding to use when creating the string representation from data.
   - returns: A value of the requested type.
   */
  mutating func decodeToEnd(_ type: String.Type, encoding: String.Encoding) throws -> String

  /**
   Decodes a value of the given type.

   - parameter type: The type of value to decode.
   - returns: A value of the requested type.
   */
  mutating func decode(_ type: Int.Type) throws -> Int

  /**
   Decodes a value of the given type.

   - parameter type: The type of value to decode.
   - returns: A value of the requested type.
   */
  mutating func decode(_ type: Int8.Type) throws -> Int8

  /**
   Decodes a value of the given type.

   - parameter type: The type of value to decode.
   - returns: A value of the requested type.
   */
  mutating func decode(_ type: Int16.Type) throws -> Int16

  /**
   Decodes a value of the given type.

   - parameter type: The type of value to decode.
   - returns: A value of the requested type.
   */
  mutating func decode(_ type: Int32.Type) throws -> Int32

  /**
   Decodes a value of the given type.

   - parameter type: The type of value to decode.
   - returns: A value of the requested type.
   */
  mutating func decode(_ type: Int64.Type) throws -> Int64

  /**
   Decodes a value of the given type.

   - parameter type: The type of value to decode.
   - returns: A value of the requested type.
   */
  mutating func decode(_ type: UInt.Type) throws -> UInt

  /**
   Decodes a value of the given type.

   - parameter type: The type of value to decode.
   - returns: A value of the requested type.
   */
  mutating func decode(_ type: UInt8.Type) throws -> UInt8

  /**
   Decodes a value of the given type.

   - parameter type: The type of value to decode.
   - returns: A value of the requested type.
   */
  mutating func decode(_ type: UInt16.Type) throws -> UInt16

  /**
   Decodes a value of the given type.

   - parameter type: The type of value to decode.
   - returns: A value of the requested type.
   */
  mutating func decode(_ type: UInt32.Type) throws -> UInt32

  /**
   Decodes a value of the given type.

   - parameter type: The type of value to decode.
   - returns: A value of the requested type.
   */
  mutating func decode(_ type: UInt64.Type) throws -> UInt64

  /**
   Decodes a value of the given type.

   - parameter type: The type of value to decode.
   - returns: A value of the requested type.
   */
  mutating func decode<T>(_ type: T.Type) throws -> T where T : BinaryDecodable

  /**
   Decodes a value of the given type.

   - parameter type: The type of value to decode.
   - returns: A value of the requested type.
   */
  mutating func decode(maxLength: Int) throws -> Data

  /**
   Reads up the maxLength values without affecting the decoder's `decode` cursor.

   - parameter maxLength: The maximum number of bytes to read.
   - returns: A preview of the bytes that will be read from the `decode` cursor position.
   */
  mutating func peek(maxLength: Int) throws -> Data

  /**
   Decodes a nested container, optionally with a maximum number of bytes that can be decoded.

   - parameter maxLength: The maximum number of bytes that this container is allowed to decode. If nil, then this
   container is able to read an infinite number of bytes.
   - returns: A decoding container view into `self`.
   */
  mutating func nestedContainer(maxLength: Int?) -> BinaryDecodingContainer
}

// MARK: RawRepresentable extensions

extension RawRepresentable where RawValue == UInt8, Self : BinaryDecodable {
  public init(from decoder: BinaryDecoder) throws {
    let byteWidth = RawValue.bitWidth / 8
    var container = decoder.container(maxLength: byteWidth)
    let decoded = try container.decode(RawValue.self)
    guard let value = Self(rawValue: decoded) else {
      throw BinaryDecodingError.dataCorrupted(.init(debugDescription:
        "Cannot initialize \(Self.self) from invalid \(RawValue.self) value \(decoded)"))
    }
    self = value
  }
}

extension RawRepresentable where RawValue == UInt16, Self : BinaryDecodable {
  public init(from decoder: BinaryDecoder) throws {
    let byteWidth = RawValue.bitWidth / 8
    var container = decoder.container(maxLength: byteWidth)
    let decoded = try container.decode(RawValue.self)
    guard let value = Self(rawValue: decoded) else {
      throw BinaryDecodingError.dataCorrupted(.init(debugDescription:
        "Cannot initialize \(Self.self) from invalid \(RawValue.self) value \(decoded)"))
    }
    self = value
  }
}
