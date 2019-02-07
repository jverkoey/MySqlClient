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
 A PayloadWriter is able to create a Data representation of a MySql payload.
 */
protocol PayloadWriter {
  /**
   Returns a MySql data representation of the payload.
   */
  func payloadData() -> Data
}

extension PayloadWriter {
  /**
   Wraps the payload in a MySql packet header.

   - Parameter lastSequenceNumber: If nil, the packet's sequence number will be 0. Otherwise, the packet's sequence
   number will be `lastSequenceNumber` + 1.
   */
  func packetData(lastSequenceNumber: UInt8?) throws -> Data {
    let payload = payloadData()

    precondition(payload.count <= 0xffffff, "Payloads larger than \(0xffffff) are not presently supported.")

    let packetLength = UInt32(payload.count)

    // We intentially allow the sequence number to overflow.
    let sequenceNumber: UInt8
    if let lastSequenceNumber = lastSequenceNumber {
      sequenceNumber = lastSequenceNumber &+ 1
    } else {
      sequenceNumber = 0
    }

    return Data(packetLength.bytes[0...2] + [sequenceNumber]) + payload
  }
}
