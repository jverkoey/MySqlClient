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
import Socket

/**
 Test environment usage of a server that runs in a separate thread has proven somewhat flaky. A hack-fix makes the
 socket iterator sleep until data is available to read while in a test environment, but ideally this would be handled by
 the Socket implementation.
 */
private let inTestEnvironment = NSClassFromString("XCTest") != nil

/**
 Enables iteration over a sequence's data as a continuous stream of bytes, pulling data from the socket as necessary.
 */
extension Socket {
  /**
   Returns an iterator representation of this socket that reads data as needed.

   Each iterator will pull data from the Socket independently, mutating the Socket's internal data storage as a result.
   As such, be careful when making multiple iterators not to overlap their use because the resulting behavior is
   undefined.
   */
  public func asIterator() -> AnyIterator<UInt8> {
    var iterator: Data.Iterator?

    return AnyIterator {
      if let next = iterator?.next() {
        return next
      }

      if !self.isConnected {
        return nil
      }

      do {
        if try !self.testEnvironmentHackFix() {
          return nil
        }

        var buffer = Data(capacity: self.readBufferSize)
        _ = try self.read(into: &buffer)
        iterator = buffer.makeIterator()
      } catch {
        return nil
      }

      return iterator?.next()
    }
  }

  private func testEnvironmentHackFix() throws -> Bool {
    if inTestEnvironment {
      var triesRemaining = 1000
      // Wait until data is available to read.
      while try !self.isReadableOrWritable(waitForever: true, timeout: 0).readable && triesRemaining > 0 {
        usleep(1000) // in microseconds
        triesRemaining -= 1
      }
      if triesRemaining == 0 {
        return false
      }
    }
    return true
  }
}
