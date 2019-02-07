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
import FixedWidthInteger_bytes
import LengthEncodedInteger

/**
 A throwable length-encoded string decoding error.
 */
public enum LengthEncodedStringDecodingError: Error, Equatable {

  /**
   The length-encoded string expected an amount of data that was not available.

   - Parameter expectedAtLeast: The number of expected bytes.
   */
  case unexpectedEndOfData(expectedAtLeast: UInt)

  /**
   The length-encoded string expected an amount of data that was not available.

   - Parameter expectedAtLeast: The number of expected bytes.
   */
  case unableToCreateStringWithEncoding(_ encoding: String.Encoding)
}

/**
 A MySql length-encoded string.

 This implementation is limited to the maximum length of Foundation's String implementation, i.e. Int.max.

 Documentation: https://dev.mysql.com/doc/internals/en/string.html#packet-Protocol::LengthEncodedString
 */
public struct LengthEncodedString {

  /**
   Attempts to initialize a length-encoded string from the provided `data`. If the data does not represent a
   length-encoded string, then nil is returned.

   - Parameter data: The data from which the length-encoded string should be parsed.
   - Throws: `LengthEncodedStringError.unexpectedEndOfData` If `data` looks like a length-encoded string but its
   length is less than the expected amount.
   - Throws: `LengthEncodedStringError.unableToCreateStringWithEncoding` If a String was not able to be initialized from
   `data` with the given `encoding`.
   */
  public init?(data: Data, encoding: String.Encoding) throws {
    // Empty data is not a length-encoded string.
    if data.isEmpty {
      return nil
    }

    let integer: LengthEncodedInteger
    do {
      guard let integerOrNil = try LengthEncodedInteger(data: data) else {
        return nil
      }
      integer = integerOrNil
    } catch let error {
      if let lengthEncodedError = error as? LengthEncodedIntegerDecodingError {
        switch lengthEncodedError {
        case .unexpectedEndOfData(let expectedAtLeast):
          throw LengthEncodedStringDecodingError.unexpectedEndOfData(expectedAtLeast: expectedAtLeast)
        }
      }
      throw error
    }

    self.length = UInt64(integer.length) + UInt64(integer.value)

    let remainingData = data[integer.length..<(integer.length + UInt(integer.value))]
    if remainingData.count < integer.value {
      throw LengthEncodedStringDecodingError.unexpectedEndOfData(expectedAtLeast: UInt(integer.value))
    }

    guard let string = String(data: remainingData, encoding: encoding) else {
      throw LengthEncodedStringDecodingError.unableToCreateStringWithEncoding(encoding)
    }
    self.value = string
  }

  public init(value: String, encoding: String.Encoding) {
    self.value = value

    let stringLength = UInt64(value.lengthOfBytes(using: encoding))
    let length = LengthEncodedInteger(value: stringLength)
    self.length = UInt64(length.length) + stringLength
  }

  public func asData(encoding: String.Encoding) -> Data {
    let stringLength = UInt(value.lengthOfBytes(using: encoding))
    let length = LengthEncodedInteger(value: UInt64(stringLength))
    return length.asData() + value.utf8
  }

  public let value: String

  /**
   The number of bytes required to represent this length-encoded string.
   */
  public let length: UInt64
}
