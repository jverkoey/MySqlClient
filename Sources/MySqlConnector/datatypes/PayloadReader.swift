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
 Errors that may be thrown by a PayloadReader.
 */
enum PayloadReaderError: Error {

  /**
   Indicates that the packet's payload was unexpectedly empty.
   */
  case unexpectedEmptyPayload(kind: PayloadReader.Type)

  /**
   Indicates that the packet payload's end was unexpectedly reached.
   */
  case unexpectedEndOfPayload(kind: PayloadReader.Type, context: String)

  /**
   Indicates that a length-encoded integer was expected but something unexpected was found instead.
   */
  case expectedLengthEncodedInteger

  /**
   Indicates that a length-encoded string was expected but something unexpected was found instead.
   */
  case expectedLengthEncodedString

  /**
   Indicates that a length encoded string's string portion did not match its length.
   */
  case expectedStringContent(kind: PayloadReader.Type, context: String)
}

/**
 A PayloadReader is able to create a structured representation of the payload data contained within a MySql packet.
 */
protocol PayloadReader {

  /**
   Initializes the instance with the given payload data and capability flags.

   The implementation is expected to throw an error if the packet is not parseable. The PayloadReaderError type includes
   a variety of relevant errors that may be thrown.

   - Parameter payloadData: The payload's data representation. This will not include the MySql packet header.
   - Parameter capabilityFlags: The capabitility flags that should be used to parse the payload data.
   */
  init(payloadData data: Data, capabilityFlags: CapabilityFlags) throws
}
