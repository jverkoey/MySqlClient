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

public func lazyDataStream(from data: Data) -> LazyDataStream<Data> {
  return LazyDataStream<Data>(cursor: data) { cursor, suggestedCount in
    guard cursor.count > 0 else {
      return nil
    }
    let pulledData = cursor.prefix(suggestedCount)
    cursor = cursor.dropFirst(suggestedCount)
    return pulledData
  }
}

/**
 An interface for lazily reading data.
 */
public protocol StreamableDataProvider {
  mutating func pull(maxBytes: Int) throws -> Data
  mutating func pull(until delimiter: UInt8) throws -> (data: Data, didFindDelimiter: Bool)
}

/**
 An interface for lazily reading data.
 */
public final class LazyDataStream<Cursor>: StreamableDataProvider {
  var buffer: Data
  let reader: (inout Cursor, Int) throws -> Data?
  var cursor: Cursor

  /**
   - Parameter reader: A closure that accepts a suggested number of bytes and returns Data to be added to the
   buffer. The reader may return more or less data that what is suggested. If no more data is available, then nil
   should be returned.
   */
  public init(cursor: Cursor, capacity: Int = 1024, reader: @escaping (inout Cursor, Int) throws -> Data?) {
    self.buffer = Data(capacity: capacity)
    self.cursor = cursor
    self.reader = reader
  }

  public func pull(maxBytes: Int) throws -> Data {
    while buffer.count < maxBytes, let data = try reader(&cursor, maxBytes - buffer.count) {
      buffer.append(data)
    }
    // TODO: The original buffer may never decrease in size because of how this is implemented.
    // This can likely be optimized with a ring buffer implementation.
    // Example implementation in Swift's Sequence:
    // https://github.com/apple/swift/blob/b0fbbb3342c1c2df0753a0fc9b469e9d951adf43/stdlib/public/core/Sequence.swift#L898
    let data = buffer.prefix(maxBytes)
    buffer = buffer[(buffer.startIndex + data.count)...]
    return data
  }

  public func pull(until delimiter: UInt8) throws -> (data: Data, didFindDelimiter: Bool) {
    var indexOfDelimiter = buffer.firstIndex(of: delimiter)
    // TODO: Explore strategies for optimizing page fetching when we're not sure how far ahead a value is.
    let pageSize = 1024
    while indexOfDelimiter == nil {
      guard let data = try reader(&cursor, pageSize) else {
        break
      }
      if let subIndex = data.firstIndex(of: delimiter) {
        indexOfDelimiter = buffer.count + (subIndex - data.startIndex)
      }
      buffer.append(data)
    }
    if let indexOfDelimiter = indexOfDelimiter {
      let data = buffer.prefix(indexOfDelimiter)
      buffer = buffer[(buffer.startIndex + data.count + 1)...]
      return (data: data, didFindDelimiter: true)
    } else {
      let data = buffer
      buffer = buffer[(buffer.startIndex + data.count)...]
      return (data: data, didFindDelimiter: false)
    }
  }
}
