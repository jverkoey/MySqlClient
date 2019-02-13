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
 A representation of a MySql packet + payload.

 Documentation: https://dev.mysql.com/doc/internals/en/mysql-packet.html
 */
struct Packet<T: BinaryDecodable>: BinaryDecodable {
  let payload: T
  let length: UInt32
  let sequenceNumber: UInt8

  init(from binaryDecoder: BinaryDecoder) throws {
    var container = binaryDecoder.container(maxLength: nil)

    // From the MySql documentation:
    // > If a MySQL client or server wants to send data, it prepends to each chunk a packet header.
    // > - https://dev.mysql.com/doc/internals/en/mysql-packet.html
    //
    // The packet header is composed of:
    // - 3 bytes describing the length of the packet (not including the header).
    // - 1 byte describing the packet's sequence number.

    let lengthBytes = try container.decode(maxLength: 3)
    self.length = Data(lengthBytes + [0]).withUnsafeBytes { (ptr: UnsafePointer<UInt32>) -> UInt32 in
      return ptr.pointee
    }

    self.sequenceNumber = try container.decode(UInt8.self)

    var payloadContainer = container.nestedContainer(maxLength: Int(self.length))
    self.payload = try payloadContainer.decode(T.self)

    // Sanity-check to ensure that the payload consumed all of its content.
    assert(payloadContainer.isAtEnd, "Payload \(T.self) did not parse all of its content.")
  }
}

extension BinaryEncodable {
  /**
   Encodes a binary encodable type as a MySql packet.
   */
  func encodedAsPacket(sequenceNumber: UInt8) throws -> Data {
    let encoder = BinaryStreamEncoder()
    let payloadData = try encoder.encode(self)
    let packetLength = UInt32(payloadData.count)
    return Data(packetLength.bytes[0...2] + [sequenceNumber]) + payloadData
  }
}
