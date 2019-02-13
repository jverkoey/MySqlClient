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

public func lazyDataStream(from data: Data) -> LazyDataStream {
  return LazyDataStream(reader: DataReader(data: data))
}

/**
 An interface for lazily reading data.
 */
public protocol StreamableDataProvider {
  var isAtEnd: Bool { get }
  func hasAtLeast(minBytes: Int) throws -> Bool
  mutating func pull(maxBytes: Int) throws -> Data
  mutating func pull(until delimiter: UInt8) throws -> (data: Data, didFindDelimiter: Bool)
}

public protocol Reader {
  func read(recommendedAmount: Int) throws -> Data?
  var isAtEnd: Bool { get }
}

public final class AnyReader: Reader {
  let readCallback: (Int) throws -> Data?
  let isAtEndCallback: () -> Bool
  public init(read: @escaping (Int) throws -> Data?, isAtEnd: @escaping () -> Bool) {
    self.readCallback = read
    self.isAtEndCallback = isAtEnd
  }

  public func read(recommendedAmount: Int) throws -> Data? {
    return try readCallback(recommendedAmount)
  }

  public var isAtEnd: Bool { return isAtEndCallback() }
}

public final class DataReader: Reader {
  var data: Data
  init(data: Data) {
    self.data = data
  }

  public func read(recommendedAmount: Int) throws -> Data? {
    guard !isAtEnd else {
      return nil
    }
    let pulledData = data.prefix(recommendedAmount)
    data = data.dropFirst(recommendedAmount)
    return pulledData
  }

  public var isAtEnd: Bool { return data.isEmpty }
}

/**
 An interface for lazily reading data.
 */
public final class LazyDataStream: StreamableDataProvider {
  public var isAtEnd: Bool = false

  var buffer: Data
  let reader: Reader

  /**
   - Parameter reader: A closure that accepts a suggested number of bytes and returns Data to be added to the
   buffer. The reader may return more or less data that what is suggested. If no more data is available, then nil
   should be returned.
   */
  public init(reader: Reader, bufferCapacity: Int = 1024) {
    self.buffer = Data(capacity: bufferCapacity)
    self.reader = reader
  }

  public func pull() throws -> Data {
    if buffer.isEmpty {
      if let data = try reader.read(recommendedAmount: .max) {
        buffer.append(data)
      } else {
        isAtEnd = true
      }
    }
    let data = buffer
    buffer = buffer[(buffer.startIndex + data.count)...]
    return data
  }

  public func hasAtLeast(minBytes: Int) throws -> Bool {
    while buffer.count < minBytes {
      guard let data = try reader.read(recommendedAmount: minBytes - buffer.count) else {
        isAtEnd = true
        break
      }
      buffer.append(data)
    }
    return buffer.count >= minBytes
  }

  public func pull(maxBytes: Int) throws -> Data {
    while buffer.count < maxBytes {
      guard let data = try reader.read(recommendedAmount: maxBytes - buffer.count) else {
        isAtEnd = true
        break
      }
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
    while indexOfDelimiter == nil {
      guard let data = try reader.read(recommendedAmount: 1) else {
        isAtEnd = true
        break
      }
      if let subIndex = data.firstIndex(of: delimiter) {
        indexOfDelimiter = buffer.startIndex + buffer.count + (subIndex - data.startIndex)
      }
      buffer.append(data)
    }
    if let indexOfDelimiter = indexOfDelimiter {
      let data = buffer.prefix(indexOfDelimiter - buffer.startIndex)
      buffer = buffer[(buffer.startIndex + data.count + 1)...]
      return (data: data, didFindDelimiter: true)
    } else {
      let data = buffer
      buffer = buffer[(buffer.startIndex + data.count)...]
      return (data: data, didFindDelimiter: false)
    }
  }
}
