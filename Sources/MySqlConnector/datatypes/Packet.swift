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

import BinaryCodable
import Foundation

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
struct Packet<T: BinaryDecodable>: BinaryDecodable {
  let payload: T
  let length: UInt32
  let sequenceNumber: UInt8

  public init(from binaryDecoder: BinaryDecoder) throws {
    var container = try binaryDecoder.container(maxLength: nil)

    // MySql documentation: https://dev.mysql.com/doc/internals/en/mysql-packet.html
    // > If a MySQL client or server wants to send data, it:
    // > - Splits the data into packets of size 2^24 − 1 bytes
    // > - Prepends to each chunk a packet header
    //
    // The packet header is composed of:
    // - 3 bytes describing the length of the packet (not including the header).
    // - 1 byte describing the packet's sequence number.

    let lengthBytes = try (0..<3).map { _ in try container.decode(UInt8.self) }
    self.length = Data(lengthBytes + [0]).withUnsafeBytes { (ptr: UnsafePointer<UInt32>) -> UInt32 in
      return ptr.pointee
    }

    self.sequenceNumber = try container.decode(UInt8.self)

    var payloadContainer = try container.nestedContainer(maxLength: Int(self.length))
    self.payload = try payloadContainer.decode(T.self)
  }
}
