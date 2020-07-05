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

struct TestConfig {
  var testAgainstSqlServer = true
  var host: String = "localhost"
  var port: Int32 = 3306
  var user: String = "root"
  var pass: String = ""

  static var environment: TestConfig {
    var config = TestConfig()
    if let host = getEnvironmentVariable(named: "MYSQL_SERVER_HOST") {
      config.host = host
    }
    if let mySqlServerPortString = getEnvironmentVariable(named: "MYSQL_SERVER_PORT"),
      let mySqlServerPort = Int32(mySqlServerPortString) {
      config.port = mySqlServerPort
    }
    if let username = getEnvironmentVariable(named: "MYSQL_SERVER_USER") {
      config.user = username
    }
    if let password = getEnvironmentVariable(named: "MYSQL_SERVER_PASSWORD") {
      config.pass = password
    }
    return config
  }
}

private func getEnvironmentVariable(named name: String) -> String? {
  if let environmentValue = getenv(name) {
    return String(cString: environmentValue)
  } else {
    return nil
  }
}
