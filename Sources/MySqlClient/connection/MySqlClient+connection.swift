// Copyright 2020-present the MySqlClient authors. All Rights Reserved.
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
import Socket

extension MySqlClient {
  func anyIdleConnection() throws -> Connection? {
    connectionPool.removeAll { !$0.socket.isConnected }
    if let connection = connectionPool.first(where: { $0.isIdle }) {
      return connection
    }
    guard let connection = try MySqlClient.connect(
      to: host,
      port: port,
      username: username,
      password: password,
      database: database
    ) else {
      return nil
    }
    connectionPool.append(connection)
    return connection
  }

  /**
   Creates a new connection to the given MySql server.
   */
  private static func connect(
    to host: String,
    port: Int32,
    username: String,
    password: String,
    database: String? = nil
  ) throws -> Connection? {
    let socket = try Socket.create()
    try socket.connect(to: host, port: port)
    guard socket.isConnected else {
      return nil
    }

    let socketDataStream = createDataStream(socket: socket)
    var decoder = BinaryDataDecoder()

    let handshake = try decoder.decode(Packet<Handshake>.self, from: socketDataStream)

    // From https://dev.mysql.com/doc/internals/en/capability-negotiation.html
    // "The client should only announce the capabilities in the Handshake Response Packet"
    // that it has in common with the server."
    let capabilityFlags = clientCapabilityFlags.intersection(handshake.payload.serverCapabilityFlags)

    // Subsequent decodings on this data stream may require access to the intersected capability flags, so we make them
    // available through `userInfo`.
    decoder.userInfo[.capabilityFlags] = capabilityFlags

    let handshakeResponse = try HandshakeResponse(
      username: username,
      password: password,
      database: database,
      capabilityFlags: capabilityFlags,
      authPluginData: handshake.payload.authPluginData,
      authPluginName: handshake.payload.authPluginName
    ).encodedAsPacket(sequenceNumber: 1)
    try socket.write(from: handshakeResponse)

    let response = try decoder.decode(Packet<GenericResponse>.self, from: socketDataStream)
    if case .OK = response.payload {
      return Connection(decoder: decoder, socket: socket, socketDataStream: socketDataStream)
    } else if case .ERR(let errorCode, _) = response.payload {
      throw ClientError.handshakeError(errorCode: errorCode)
    }
    return nil
  }

  private static func createDataStream(socket: Socket) -> BufferedData {
    var buffer = Data(capacity: socket.readBufferSize)
    return BufferedData(reader: AnyBufferedDataSource(read: { length in
      if buffer.count == 0 {
        _ = try socket.read(into: &buffer)
      }
      let pulledData = buffer.prefix(length)
      buffer = buffer.dropFirst(length)
      return pulledData
    }, isAtEnd: {
      do {
        return try buffer.isEmpty && !socket.isReadableOrWritable(waitForever: false, timeout: 0).readable
      } catch {
        return true
      }
    }))
  }
}

private let clientCapabilityFlags: CapabilityFlags = [
  .connectWithDb,
  .deprecateEof,
  .protocol41,
  .secureConnection,
  .sessionTrack,
  .pluginAuth,
  .multiStatements,
  .multiResults
]

final class Connection {
  let decoder: BinaryDataDecoder
  let socket: Socket
  let socketDataStream: BufferedData

  init(decoder: BinaryDataDecoder, socket: Socket, socketDataStream: BufferedData) {
    self.decoder = decoder
    self.socket = socket
    self.socketDataStream = socketDataStream
  }

  // Indicates whether or not this connection is able to send data.
  var isIdle = true

  func terminate() {
    self.socket.close()
  }

  func send<Payload: BinaryEncodable>(payload: Payload) throws {
    precondition(isIdle, "A connection is being reused even though it is not yet idle.")
    isIdle = false
    try socket.write(from: payload.encodedAsPacket(sequenceNumber: 0))
  }

  func read<Payload: BinaryDecodable>(payloadType: Payload.Type) throws -> Payload {
    return try decoder.decode(Packet<Payload>.self, from: socketDataStream).payload
  }
}
