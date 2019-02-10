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
 A type that can decode itself from an external binary representation.
 */
public protocol BinaryDecodable {

  /**
   Creates a new instance by decoding from the given binary decoder.

   - Parameter decoder: The binary decoder to read data from.
   - Throws: if reading from the binary decoder fails, or if the data read is corrupted or otherwise invalid.
   */
  init(from binaryDecoder: BinaryDecoder) throws
}

/// A type that can decode values from a native format into in-memory
/// representations.
public protocol BinaryDecoder {
  /**
   Returns the data stored in this decoder as represented in a container
   appropriate for holding values with no keys.

   - parameter maxLength: The maximum number of bytes that this container is allowed to decode up to. If nil, then
   this container is able to read an infinite number of bytes.
   - returns: An unkeyed container view into this decoder.
   - throws: `DecodingError.typeMismatch` if the encountered stored value is
   not an unkeyed container.
   */
  func container(maxLength: Int?) throws -> BinaryDecodingContainer
}

/// A type that provides a view into a decoder's storage and is used to hold
/// the encoded properties of a decodable type sequentially, without keys.
///
/// Decoders should provide types conforming to `UnkeyedDecodingContainer` for
/// their format.
public protocol BinaryDecodingContainer {

  /// A Boolean value indicating whether there are no more elements left to be
  /// decoded in the container.
  var isAtEnd: Bool { get }

  /// Decodes a null value.
  ///
  /// If the value is not null, does not increment currentIndex.
  ///
  /// - returns: Whether the encountered value was null.
  /// - throws: `DecodingError.valueNotFound` if there are no more values to
  ///   decode.
  mutating func decodeNil() throws -> Bool

  /// Decodes a value of the given type.
  ///
  /// - parameter type: The type of value to decode.
  /// - returns: A value of the requested type, if present for the given key
  ///   and convertible to the requested type.
  /// - throws: `DecodingError.typeMismatch` if the encountered encoded value
  ///   is not convertible to the requested type.
  /// - throws: `DecodingError.valueNotFound` if the encountered encoded value
  ///   is null, or of there are no more values to decode.
  mutating func decode(_ type: Bool.Type) throws -> Bool

  /// Decodes a value of the given type.
  ///
  /// - parameter type: The type of value to decode.
  /// - returns: A value of the requested type, if present for the given key
  ///   and convertible to the requested type.
  /// - throws: `DecodingError.typeMismatch` if the encountered encoded value
  ///   is not convertible to the requested type.
  /// - throws: `DecodingError.valueNotFound` if the encountered encoded value
  ///   is null, or of there are no more values to decode.
  mutating func decode(_ type: String.Type) throws -> String

  /// Decodes a value of the given type.
  ///
  /// - parameter type: The type of value to decode.
  /// - returns: A value of the requested type, if present for the given key
  ///   and convertible to the requested type.
  /// - throws: `DecodingError.typeMismatch` if the encountered encoded value
  ///   is not convertible to the requested type.
  /// - throws: `DecodingError.valueNotFound` if the encountered encoded value
  ///   is null, or of there are no more values to decode.
  mutating func decode(_ type: Double.Type) throws -> Double

  /// Decodes a value of the given type.
  ///
  /// - parameter type: The type of value to decode.
  /// - returns: A value of the requested type, if present for the given key
  ///   and convertible to the requested type.
  /// - throws: `DecodingError.typeMismatch` if the encountered encoded value
  ///   is not convertible to the requested type.
  /// - throws: `DecodingError.valueNotFound` if the encountered encoded value
  ///   is null, or of there are no more values to decode.
  mutating func decode(_ type: Float.Type) throws -> Float

  /// Decodes a value of the given type.
  ///
  /// - parameter type: The type of value to decode.
  /// - returns: A value of the requested type, if present for the given key
  ///   and convertible to the requested type.
  /// - throws: `DecodingError.typeMismatch` if the encountered encoded value
  ///   is not convertible to the requested type.
  /// - throws: `DecodingError.valueNotFound` if the encountered encoded value
  ///   is null, or of there are no more values to decode.
  mutating func decode(_ type: Int.Type) throws -> Int

  /// Decodes a value of the given type.
  ///
  /// - parameter type: The type of value to decode.
  /// - returns: A value of the requested type, if present for the given key
  ///   and convertible to the requested type.
  /// - throws: `DecodingError.typeMismatch` if the encountered encoded value
  ///   is not convertible to the requested type.
  /// - throws: `DecodingError.valueNotFound` if the encountered encoded value
  ///   is null, or of there are no more values to decode.
  mutating func decode(_ type: Int8.Type) throws -> Int8

  /// Decodes a value of the given type.
  ///
  /// - parameter type: The type of value to decode.
  /// - returns: A value of the requested type, if present for the given key
  ///   and convertible to the requested type.
  /// - throws: `DecodingError.typeMismatch` if the encountered encoded value
  ///   is not convertible to the requested type.
  /// - throws: `DecodingError.valueNotFound` if the encountered encoded value
  ///   is null, or of there are no more values to decode.
  mutating func decode(_ type: Int16.Type) throws -> Int16

  /// Decodes a value of the given type.
  ///
  /// - parameter type: The type of value to decode.
  /// - returns: A value of the requested type, if present for the given key
  ///   and convertible to the requested type.
  /// - throws: `DecodingError.typeMismatch` if the encountered encoded value
  ///   is not convertible to the requested type.
  /// - throws: `DecodingError.valueNotFound` if the encountered encoded value
  ///   is null, or of there are no more values to decode.
  mutating func decode(_ type: Int32.Type) throws -> Int32

  /// Decodes a value of the given type.
  ///
  /// - parameter type: The type of value to decode.
  /// - returns: A value of the requested type, if present for the given key
  ///   and convertible to the requested type.
  /// - throws: `DecodingError.typeMismatch` if the encountered encoded value
  ///   is not convertible to the requested type.
  /// - throws: `DecodingError.valueNotFound` if the encountered encoded value
  ///   is null, or of there are no more values to decode.
  mutating func decode(_ type: Int64.Type) throws -> Int64

  /// Decodes a value of the given type.
  ///
  /// - parameter type: The type of value to decode.
  /// - returns: A value of the requested type, if present for the given key
  ///   and convertible to the requested type.
  /// - throws: `DecodingError.typeMismatch` if the encountered encoded value
  ///   is not convertible to the requested type.
  /// - throws: `DecodingError.valueNotFound` if the encountered encoded value
  ///   is null, or of there are no more values to decode.
  mutating func decode(_ type: UInt.Type) throws -> UInt

  /// Decodes a value of the given type.
  ///
  /// - parameter type: The type of value to decode.
  /// - returns: A value of the requested type, if present for the given key
  ///   and convertible to the requested type.
  /// - throws: `DecodingError.typeMismatch` if the encountered encoded value
  ///   is not convertible to the requested type.
  /// - throws: `DecodingError.valueNotFound` if the encountered encoded value
  ///   is null, or of there are no more values to decode.
  mutating func decode(_ type: UInt8.Type) throws -> UInt8

  /// Decodes a value of the given type.
  ///
  /// - parameter type: The type of value to decode.
  /// - returns: A value of the requested type, if present for the given key
  ///   and convertible to the requested type.
  /// - throws: `DecodingError.typeMismatch` if the encountered encoded value
  ///   is not convertible to the requested type.
  /// - throws: `DecodingError.valueNotFound` if the encountered encoded value
  ///   is null, or of there are no more values to decode.
  mutating func decode(_ type: UInt16.Type) throws -> UInt16

  /// Decodes a value of the given type.
  ///
  /// - parameter type: The type of value to decode.
  /// - returns: A value of the requested type, if present for the given key
  ///   and convertible to the requested type.
  /// - throws: `DecodingError.typeMismatch` if the encountered encoded value
  ///   is not convertible to the requested type.
  /// - throws: `DecodingError.valueNotFound` if the encountered encoded value
  ///   is null, or of there are no more values to decode.
  mutating func decode(_ type: UInt32.Type) throws -> UInt32

  /// Decodes a value of the given type.
  ///
  /// - parameter type: The type of value to decode.
  /// - returns: A value of the requested type, if present for the given key
  ///   and convertible to the requested type.
  /// - throws: `DecodingError.typeMismatch` if the encountered encoded value
  ///   is not convertible to the requested type.
  /// - throws: `DecodingError.valueNotFound` if the encountered encoded value
  ///   is null, or of there are no more values to decode.
  mutating func decode(_ type: UInt64.Type) throws -> UInt64

  /// Decodes a value of the given type.
  ///
  /// - parameter type: The type of value to decode.
  /// - returns: A value of the requested type, if present for the given key
  ///   and convertible to the requested type.
  /// - throws: `DecodingError.typeMismatch` if the encountered encoded value
  ///   is not convertible to the requested type.
  /// - throws: `DecodingError.valueNotFound` if the encountered encoded value
  ///   is null, or of there are no more values to decode.
  mutating func decode<T>(_ type: T.Type) throws -> T where T : BinaryDecodable

  /// Decodes a value of the given type.
  ///
  /// - parameter type: The type of value to decode.
  /// - returns: A value of the requested type, if present for the given key
  ///   and convertible to the requested type.
  /// - throws: `DecodingError.typeMismatch` if the encountered encoded value
  ///   is not convertible to the requested type.
  /// - throws: `DecodingError.valueNotFound` if the encountered encoded value
  ///   is null, or of there are no more values to decode.
  mutating func decode(maxLength: Int) throws -> Data

  /**
   Decodes a nested container.

   - parameter maxLength: The maximum number of bytes that this container is allowed to decode up to. If nil, then
   this container is able to read an infinite number of bytes.
   - returns: A decoding container view into `self`.
   */
  mutating func nestedContainer(maxLength: Int?) throws -> BinaryDecodingContainer
}
