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

public typealias BinaryCodable = BinaryDecodable & BinaryEncodable

/**
 A type that can encode itself to an external binary representation.
 */
public protocol BinaryEncodable {

  /**
   Encodes this value into the given encoder.

   - parameter encoder: The encoder to write data to.
   */
  func encode(to binaryEncoder: BinaryEncoder) throws
}

/**
 A type that can encode values from a native format into in-memory representations.
 */
public protocol BinaryEncoder {
  /**
   Returns an encoding container appropriate for holding multiple values.

   - returns: A new empty container.
   */
  func container() -> BinaryEncodingContainer
}

/**
 An error that occurs during the binary encoding of a value.
 */
public enum BinaryEncodingError : Error {

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
   An indication that a string was unable to be converted to a Data representation using a given encoding.

   As an associated value, this case contains the context for debugging.
   */
  case incompatibleStringEncoding(Context)
}

/**
 A type that provides a view into an encoder's storage and is used to hold the encoded properties of a encodable type
 sequentially.
 */
public protocol BinaryEncodingContainer {

  /**
   The number of bytes encoded into the container.
   */
  var count: Int { get }

  /**
   Encodes a String value using the given encoding and with a terminator at the end.

   - parameter value: The value to encode.
   - parameter encoding: The string encoding to use when creating the data representation of the string.
   - parameter terminator: Typically 0. This will be encoded after the string has been encoded.
   */
  mutating func encode(_ value: String, encoding: String.Encoding, terminator: UInt8) throws

  /**
   Encodes a value of the given type.

   - parameter value: The value to encode.
   */
  mutating func encode(_ value: Int) throws

  /**
   Encodes a value of the given type.

   - parameter value: The value to encode.
   */
  mutating func encode(_ value: Int8) throws

  /**
   Encodes a value of the given type.

   - parameter value: The value to encode.
   */
  mutating func encode(_ value: Int16) throws

  /**
   Encodes a value of the given type.

   - parameter value: The value to encode.
   */
  mutating func encode(_ value: Int32) throws

  /**
   Encodes a value of the given type.

   - parameter value: The value to encode.
   */
  mutating func encode(_ value: Int64) throws

  /**
   Encodes a value of the given type.

   - parameter value: The value to encode.
   */
  mutating func encode(_ value: UInt) throws

  /**
   Encodes a value of the given type.

   - parameter value: The value to encode.
   */
  mutating func encode(_ value: UInt8) throws

  /**
   Encodes a value of the given type.

   - parameter value: The value to encode.
   */
  mutating func encode(_ value: UInt16) throws

  /**
   Encodes a value of the given type.

   - parameter value: The value to encode.
   */
  mutating func encode(_ value: UInt32) throws

  /**
   Encodes a value of the given type.

   - parameter value: The value to encode.
   */
  mutating func encode(_ value: UInt64) throws

  /**
   Encodes a value of the given type.

   - parameter value: The value to encode.
   */
  mutating func encode<T>(_ value: T) throws where T : BinaryEncodable

  /**
   Encodes a value of the given type.

   - parameter value: The value to encode.
   */
  mutating func encode(maxLength: Int) throws
}

// MARK: RawRepresentable extensions

extension RawRepresentable where RawValue == UInt8, Self : BinaryEncodable {
  public func encode(to binaryEncoder: BinaryEncoder) throws {
    var container = binaryEncoder.container()
    try container.encode(self.rawValue)
  }
}
