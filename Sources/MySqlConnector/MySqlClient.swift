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
 An instance of MySqlClient lazily creates and maintains connections to a single MySql server.
 */
public final class MySqlClient {
  /**
   Initializes a client with the given MySql server location and credentials.

   - parameter host: The MySql server's host address. E.g. "127.0.0.1".
   - parameter port: The MySql server's port. Typically 3306.
   - parameter username: The username to authenticate with.
   - parameter password: The password to authenticate with. Can be empty if no password is required.
   - parameter database: If provided, this database will be the default used database for queries.
   */
  public init(to host: String, port: Int32 = 3306, username: String, password: String?, database: String? = nil) {
    self.host = host
    self.port = port
    self.username = username
    self.password = password ?? ""
    self.database = database
  }

  /**
   Sends a MySql query to the MySql server and returns the server's response, parsing any returned rows using the
   provided Decodable `rowType`.

   - parameter rowType: A Decodable type that will be used to decode the row's response values.
   - parameter query: A single MySql query statement to be performed on the MySql server.
   - returns: `.ERR` if query MySql resulted in an error on the MySql server. `.OK` if the query did not return any rows
     but was otherwise successful. `.Results` if the query was successful and returned rows.
   - throws: `ClientError.noConnectionAvailable` if no connection could be made with the server.
   */
  @discardableResult
  public func query<T: Decodable>(_ query: String, rowType type: T.Type) throws -> QueryResponse<T> {
    guard let connection = try anyIdleConnection() else {
      throw ClientError.noConnectionAvailable
    }

    do {
      try connection.send(payload: Query(query))

      connection.isIdle = false

      let response = try connection.read(payloadType: GenericResponse.self)

      switch response {
      case .ERR(let errorCode, let errorMessage):
        connection.isIdle = true
        return .ERR(errorCode: errorCode,
                    errorMessage: errorMessage)

      case .OK(let context):
        connection.isIdle = true
        return .OK(numberOfAffectedRows: context.numberOfAffectedRows,
                   lastInsertId: context.lastInsertId,
                   info: context.info)

      case .ResultSetColumnCount(let columnCount):
        let iterator = try QueryResultDecoder<T>(columnCount: columnCount,
                                                 connection: connection)
        return .Results(iterator: AnyIterator {
          let next = iterator.next()
          if next == nil {
            connection.isIdle = true
          }
          return next
        })

      default:
        preconditionFailure("Unimplemented.")
      }
    } catch let error {
      connection.isIdle = true
      throw error
    }
  }

  /**
   A Decodable type that can be used to parse returned MySql rows as generic dictionaries.
   */
  public typealias DictionaryRow = [String: String?]

  /**
   Sends a MySql query to the MySql server and returns the server's response, parsing any returned rows as a dictionary.

   - parameter query: A single MySql query statement to be performed on the MySql server.
   - returns: `.ERR` if query MySql resulted in an error on the MySql server. `.OK` if the query did not return any rows
   but was otherwise successful. `.Results` if the query was successful and returned rows.
   - throws: `ClientError.noConnectionAvailable` if no connection could be made with the server.
   */
  @discardableResult
  public func query(_ query: String) throws -> QueryResponse<DictionaryRow> {
    return try self.query(query, rowType: DictionaryRow.self)
  }
  
  var connectionPool: [Connection] = []
  let host: String
  let port: Int32
  let username: String
  let password: String
  let database: String?
}

/**
 A representation of the response from a MySqlClient query.
 */
public enum QueryResponse<T: Decodable> {
  /**
   Indicates that the query succeeded.

   - parameter numberOfAffectedRows: The number of rows affected by the query.
   - parameter lastInsertId: The id of the last-inserted row.
   - parameter info: A human-readable status information related to the query.
   */
  case OK(numberOfAffectedRows: UInt64, lastInsertId: UInt64, info: String?)

  /**
   Indicates that the query failed.

   - parameter errorCode: The error code returned by the MySql server.
   - parameter errorMessage: A human-readable error message returned by the MySql server.
   */
  case ERR(errorCode: ErrorCode, errorMessage: String)

  /**
   Indicates that the query succeeded with a lazily-iterable list of rows.

   The provided iterator will only pull data from the server as it is enumerated.

   - parameter iterator: A lazy iterator of the query's rows.
   */
  case Results(iterator: AnyIterator<T>)
}
