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
 An object that encodes instances of a type to binary data.
 */
public struct BinaryStreamEncoder {
  public init() {}

  /**
   Returns a type you specify encoded from data.

   - parameter type: The type of the instance to be encoded.
   - parameter data: The data from which the instance should be encoded.
   - returns: An instance of `type` encoded from `data`.
   */
  public func encode<T>(_ type: T) throws -> Data where T: BinaryEncodable {
    let encoder = _BinaryStreamEncoder()
    try type.encode(to: encoder)
    return encoder.storage.data
  }
}

private final class BinaryStreamEncoderStorage {
  var data = Data()
}

private struct _BinaryStreamEncoder: BinaryEncoder {
  var storage = BinaryStreamEncoderStorage()

  func container() -> BinaryEncodingContainer {
    return UnboundedDataStreamEncodingContainer(encoder: self)
  }
}

private struct UnboundedDataStreamEncodingContainer: BinaryEncodingContainer {
  let encoder: _BinaryStreamEncoder
  init(encoder: _BinaryStreamEncoder) {
    self.encoder = encoder
  }

  func encode<IntegerType: FixedWidthInteger>(_ value: IntegerType) throws {
    encoder.storage.data.append(contentsOf: value.bytes)
  }
  func encode<T>(_ value: T) throws where T: BinaryEncodable { try value.encode(to: encoder) }

  func encode(_ value: String, encoding: String.Encoding, terminator: UInt8?) throws {
    guard let data = value.data(using: encoding) else {
      throw BinaryEncodingError.incompatibleStringEncoding(.init(debugDescription:
        "The string \(value) could not be encoded as data using the encoding \(encoding)."))
    }
    encoder.storage.data.append(contentsOf: data)
    if let terminator = terminator {
      encoder.storage.data.append(terminator)
    }
  }

  func encode<S>(sequence: S) throws where S: Sequence, S.Element == UInt8 {
    encoder.storage.data.append(contentsOf: sequence)
  }
}
