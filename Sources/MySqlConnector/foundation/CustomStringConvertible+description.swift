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

extension CustomStringConvertible {
  /**
   Returns a String representation of self and its child properties.
   */
  var description: String {
    var description: [String] = []
    description.append("<\(type(of: self))")

    var properties: [String] = []
    let selfMirror = Mirror(reflecting: self)
    for child in selfMirror.children {
      if let propertyName = child.label {
        properties.append("\(propertyName): \"\(String(describing: child.value))\"")
      }
    }
    if properties.count > 0 {
      description.append(" ")
      description.append(properties.joined(separator: ", "))
    }
    description.append(">")
    return description.joined()
  }
}
