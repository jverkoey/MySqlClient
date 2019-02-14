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
import Socket

public final class MySqlClient {
  var connectionPool: [Connection] = []

  private let host: String
  private let port: Int32
  private let username: String
  private let password: String
  private let database: String?

  public init(to host: String, port: Int32 = 3306, username: String, password: String, database: String? = nil) {
    self.host = host
    self.port = port
    self.username = username
    self.password = password
    self.database = database
  }

  func anyIdleConnection() throws -> Connection? {
    if let connection = connectionPool.first(where: { $0.isIdle }) {
      return connection
    }
    guard let connection = try MySqlClient.connect(to: host, port: port, username: username, password: password, database: database) else {
      return nil
    }
    connectionPool.append(connection)
    return connection
  }

  private static func connect(to host: String,
                              port: Int32 = 3306,
                              username: String,
                              password: String,
                              database: String? = nil) throws -> Connection? {
    let socket = try Socket.create()
    try socket.connect(to: host, port: port)
    guard socket.isConnected else {
      return nil
    }

    var buffer = Data(capacity: socket.readBufferSize)
    let socketDataStream = LazyDataStream(reader: AnyReader(read: { recommendedAmount in
      if buffer.count == 0 {
        _ = try socket.read(into: &buffer)
      }
      let pulledData = buffer.prefix(recommendedAmount)
      buffer = buffer.dropFirst(recommendedAmount)
      return pulledData
    }, isAtEnd: {
      do {
        return try buffer.isEmpty && !socket.isReadableOrWritable(waitForever: false, timeout: 0).readable
      } catch {
        return true
      }
    }))

    var decoder = BinaryStreamDecoder()

    // Step 1: Receive Handshake from server.
    let handshake = try decoder.decode(Packet<Handshake>.self, from: socketDataStream)

    // > The client should only announce the capabilities in the Handshake
    // > Response Packet that it has in common with the server.
    // https://dev.mysql.com/doc/internals/en/capability-negotiation.html

    let capabilityFlags = MySqlClient.capabilityFlags.intersection(handshake.payload.serverCapabilityFlags)
    decoder.userInfo[.capabilityFlags] = capabilityFlags

    // Step 2: Send HandshakeResponse to server.
    let handshakeResponse = try HandshakeResponse(username: username,
                                                  password: password,
                                                  database: nil,
                                                  capabilityFlags: capabilityFlags,
                                                  authPluginData: handshake.payload.authPluginData,
                                                  authPluginName: handshake.payload.authPluginName)
      .encodedAsPacket(sequenceNumber: 1)
    try socket.write(from: handshakeResponse)

    // Step 3: Confirm that an OK response was received.

    let response = try decoder.decode(Packet<GenericResponse>.self, from: socketDataStream)

    if case .OK = response.payload {
      return Connection(decoder: decoder, socket: socket, socketDataStream: socketDataStream)
    } else if case .ERR(let errorCode, _) = response.payload {
      throw ClientError.handshakeError(errorCode: errorCode)
    }
    return nil
  }

  static let capabilityFlags: CapabilityFlags = [
    .connectWithDb,
    .deprecateEof,
    .protocol41,
    .secureConnection,
    .sessionTrack,
    .pluginAuth
  ]
}

public enum ClientError: Error, Equatable {
  case noConnectionAvailable

  case handshakeError(errorCode: ErrorCode)

  case connectionIsNotIdle
}

struct Connection {
  let decoder: BinaryStreamDecoder
  let socket: Socket
  let socketDataStream: LazyDataStream

  init(decoder: BinaryStreamDecoder, socket: Socket, socketDataStream: LazyDataStream) {
    self.decoder = decoder
    self.socket = socket
    self.socketDataStream = socketDataStream
  }

  // Whether or not this connection is able to send data.
  var isIdle = true

  func send<Payload: BinaryEncodable>(payload: Payload) throws {
    guard isIdle else {
      throw ClientError.connectionIsNotIdle
    }
    try socket.write(from: payload.encodedAsPacket(sequenceNumber: 0))
  }

  func read<Payload: BinaryDecodable>() throws -> Payload {
    return try decoder.decode(Packet<Payload>.self, from: socketDataStream).payload
  }
}
