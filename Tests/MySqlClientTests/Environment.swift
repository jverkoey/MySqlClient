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

import Foundation

private func getEnvironmentVariable(named name: String) -> String? {
  if let environmentValue = getenv(name) {
    return String(cString: environmentValue)
  } else {
    return nil
  }
}

struct Environment {
  let port: Int32
  let host: String
  let hostIp: String

  init() {
    if let portEnvVar = getEnvironmentVariable(named: "PORT") {
      self.port = Int32(portEnvVar)!
    } else {
      self.port = 3306
    }
    if let hostEnvVar = getEnvironmentVariable(named: "HOST") {
      self.host = hostEnvVar
    } else {
      self.host = "localhost"
    }
    self.hostIp = Host(name: self.host).addresses.first { $0.contains(".") }!
  }
}

let environment = Environment()
