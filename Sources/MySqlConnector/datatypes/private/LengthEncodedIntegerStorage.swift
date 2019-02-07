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
 Typed storage for a MySql length-encoded integer.

 Documentation: https://dev.mysql.com/doc/internals/en/integer.html#length-encoded-integer
 */
enum LengthEncodedIntegerStorage {
  case one(value: UInt8)
  case two(value: UInt16)
  case three(value: UInt32)
  case eight(value: UInt64)
}
