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
import MySqlConnector

let string = String(repeating: "A", count: 0x1000000)
let data = [0xfe] + UInt64(string.lengthOfBytes(using: .utf8)).bytes + string.utf8
let decoder = BinaryDataDecoder()

// When
let lengthEncodedString = try decoder.decode(LengthEncodedString.self, from: data)

print(lengthEncodedString.length)
