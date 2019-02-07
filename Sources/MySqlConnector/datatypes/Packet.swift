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
import CustomStringConvertible_description

/**
 Errors that may be thrown by a PayloadReader.
 */
public enum PacketError: Error {

  /**
   Indicates that the packet's end was unexpectedly reached.
   */
  case unexpectedEndOfPacket(payloadType: PayloadReader.Type)
}

/**
 A representation of a single MySql packet.

 Documentation: https://dev.mysql.com/doc/internals/en/mysql-packet.html
 */
public final class Packet<T: PayloadReader>: CustomStringConvertible {
  /**
   The packet's size in bytes, including its header.
   */
  public let size: Int

  /**
   The packet's sequence identifier.

   MySql documentation: https://dev.mysql.com/doc/internals/en/sequence-id.html
   > The sequence-id is incremented with each packet and may wrap around. It starts at 0 and is
   > reset to 0 when a new command begins in the Command Phase.
   */
  public let sequenceNumber: UInt8

  /**
   A typed representation of content within the packet.
   */
  public let content: T

  /**
   Initializes a single packet instance from the first packet in the given data.

   - Parameter data: The contents of a MySql packet.
   - Parameter capabilityFlags: The capabilities of the client.
   */
  public init<I: IteratorProtocol>(iterator: I, capabilityFlags: CapabilityFlags) throws where I.Element == UInt8 {
    precondition(0x12345678.littleEndian == 0x12345678,
                 "Only little endian architectures are currently supported.")

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
    // Docs: https://dev.mysql.com/doc/internals/en/mysql-packet.html
    let lengthData = iter.next(maxLength: 3)
    guard lengthData.count == 3 else {
      throw PacketError.unexpectedEndOfPacket(payloadType: T.self)
    }
    let length = Data(lengthData + [0]).withUnsafeBytes { (ptr: UnsafePointer<UInt32>) -> UInt32 in
      return ptr.pointee
    }

    // Sequence number is 1 byte.
    // Docs: https://dev.mysql.com/doc/internals/en/mysql-packet.html
    guard let sequenceNumber = iter.next() else {
      throw PacketError.unexpectedEndOfPacket(payloadType: T.self)
    }
    self.sequenceNumber = sequenceNumber

    // The header is always 4 bytes long.
    let headerSize: UInt32 = 4
    self.size = Int(headerSize + length)
    self.content = try T(payloadData: Data(iter.next(maxLength: Int(length))), capabilityFlags: capabilityFlags)
  }
}
