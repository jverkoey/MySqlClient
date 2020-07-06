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
#if os(Linux) // "You must link or load module FoundationNetworking to load non-file: URL content using String(contentsOf:…), Data(contentsOf:…), etc."
import FoundationNetworking
#endif
import Socket
import XCTest

enum SqlServerType: Hashable {
  case MySql(version: String)
}

enum HostEnvironment {
  case macOS
  case linux
}

struct SqlServerTestEnvironment {
  let name: String
  let url: [HostEnvironment: URL]
  let serverPath: [HostEnvironment: String]
  let serverType: SqlServerType
}

let testEnvironments: [SqlServerTestEnvironment] = [
  SqlServerTestEnvironment(
    name: "MySQL 8.0.20",
    url: [
      .macOS: URL(string: "https://dev.mysql.com/get/Downloads/MySQL-8.0/mysql-8.0.20-macos10.15-x86_64.tar.gz")!,
      .linux: URL(string: "https://dev.mysql.com/get/Downloads/MySQL-8.0/mysql-community-server-core_8.0.20-1ubuntu18.04_i386.deb")!
    ],
    serverPath: [
      .macOS: "bin/mysqld",
      .linux: "usr/bin/mysqld_safe"
    ],
    serverType: .MySql(version: "8.0.20")
  )
]

struct TestRunner {
  struct Environment {
    let host: String = "localhost"
    let port: Int32 = 3306
    let user: String = "root"
    let pass: String = ""
    let setUp: () -> Void
    let tearDown: () -> Void
    let serverType: SqlServerType

    #if compiler(>=5.3)
    func AssertEqual<T>(
      _ arg1: T,
      _ arg2: [SqlServerType: T],
      file: StaticString = #filePath,
      line: UInt = #line
    ) where T : Equatable {
      XCTAssertEqual(arg1, arg2[serverType], file: file, line: line)
    }
    #else
    func AssertEqual<T>(
      _ arg1: T,
      _ arg2: [SqlServerType: T],
      file: StaticString = #file,
      line: UInt = #line
    ) where T : Equatable {
      XCTAssertEqual(arg1, arg2[serverType], file: file, line: line)
    }
    #endif
  }
  func test(_ test: (Environment, BufferedData) throws -> Void) throws {
    try environments.forEach { environment in
      var socket: Socket!
      var socketDataStream: BufferedData!
      environment.setUp()
      defer {
        if socket != nil {
          socket.close()
          socket = nil
        }
        socketDataStream = nil

        environment.tearDown()
      }

      for backoff in [1, 2, 4, 8] as [UInt32] {
        do {
          socket = try Socket.create()
          try socket.connect(to: environment.host, port: environment.port)
        } catch {
          sleep(backoff)
          continue
        }
        break
      }

      if !socket.isConnected {
        return
      }

      var buffer = Data(capacity: socket.readBufferSize)
      socketDataStream = BufferedData(reader: AnyBufferedDataSource(read: { recommendedAmount in
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

      try test(environment, socketDataStream)
    }
  }
  let environments: [Environment]
  init() {
    print("Hello")

    let testDirectory = URL(fileURLWithPath: #file).deletingLastPathComponent()
    print("Test directory: \(testDirectory)")
    let testCacheDirectory = testDirectory.appendingPathComponent(".cache")

    let fileManager = FileManager.default
    try! fileManager.createDirectory(at: testCacheDirectory, withIntermediateDirectories: true, attributes: nil)

    self.environments = testEnvironments.map { environment in
      #if os(Linux)
      let hostEnvironment: HostEnvironment = .linux
      #elseif os(macOS)
      let hostEnvironment: HostEnvironment = .macOS
      #endif

      let environmentUrl = environment.url[hostEnvironment]!

      #if os(Linux)
      let environmentPath = testCacheDirectory.appendingPathComponent(environmentUrl.deletingPathExtension().lastPathComponent)
      #elseif os(macOS)
      let environmentPath = testCacheDirectory.appendingPathComponent(environmentUrl.deletingPathExtension().deletingPathExtension().lastPathComponent)
      #endif
      if !fileManager.fileExists(atPath: environmentPath.path) {
        let tarPath = testCacheDirectory.appendingPathComponent(environmentUrl.lastPathComponent)
        if !fileManager.fileExists(atPath: tarPath.path) {
          print("Downloading \(environment.name) from \(environment.url)...")
          let tar = try! Data(contentsOf: environmentUrl)
          try! tar.write(to: tarPath)
        }
        let task = Process()
        task.launchPath = "/usr/bin/tar"
        task.arguments = [
          "-xf",
          tarPath.path,
          "-C",
          testCacheDirectory.path
        ]
        task.launch()
        task.waitUntilExit()

        #if os(Linux)
        let dataTask = Process()
        dataTask.launchPath = "/usr/bin/tar"
        dataTask.arguments = [
          "-xf",
          testCacheDirectory.appendingPathComponent("data.tar.xz").path,
          "-C",
          testCacheDirectory.path
        ]
        dataTask.launch()
        dataTask.waitUntilExit()
        #endif
      }

      let serverPath = environmentPath.appendingPathComponent(environment.serverPath[hostEnvironment]!)
      let dataPath = environmentPath.appendingPathComponent("data")
      let initialDataPath = environmentPath.appendingPathComponent("data_initial")
      if !fileManager.fileExists(atPath: initialDataPath.path) {
        try! fileManager.createDirectory(at: initialDataPath, withIntermediateDirectories: true, attributes: nil)

        let initializationTask = Process()
        initializationTask.launchPath = serverPath.path
        initializationTask.arguments = [
          "--basedir=\(environmentPath.path)",
          "--datadir=\(initialDataPath.path)",
          "--initialize-insecure"  // We don't require a password.
        ]
        initializationTask.launch()
        initializationTask.waitUntilExit()
      }

      let runTask = Process()
      runTask.launchPath = serverPath.path
      runTask.arguments = [
        "--basedir=\(environmentPath.path)",
        "--datadir=\(dataPath.path)",
        "--port=3306",
      ]

      return Environment(
        setUp: {
          if fileManager.fileExists(atPath: dataPath.path) {
            try! fileManager.removeItem(at: dataPath)
          }
          try! fileManager.copyItem(atPath: initialDataPath.path, toPath: dataPath.path)
          runTask.launch()
        }, tearDown: {
          runTask.terminate()
        }, serverType: environment.serverType
      )
    }
  }
}
//
//let testRunner = TestRunner()
