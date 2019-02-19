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

import MySqlConnector
import XCTest

struct TableColumnDescription: Decodable, Equatable {
  let field: String
  let fieldType: String
  let isNullable: Bool
  let key: String
  let defaultValue: String?
  let extraInformation: String

  private enum CodingKeys : String, CodingKey {
    case field = "Field"
    case fieldType = "Type"
    case isNullable = "Null"
    case key = "Key"
    case defaultValue = "Default"
    case extraInformation = "Extra"
  }
}

final class TableTests: XCTestCase {
  var client: MySqlClient!
  let config = TestConfig.environment
  override func setUp() {
    super.setUp()

    client = MySqlClient(to: config.host, port: config.port, username: config.user, password: config.pass, database: nil)

    if config.testAgainstSqlServer {
      try! client.query("create database \(type(of: self))")
      try! client.query("use \(type(of: self))")
      try! client.query("create table \(type(of: self)) (name VARCHAR(20), owner VARCHAR(20), species VARCHAR(20), sex CHAR(1), birth DATE, death DATE)")
    }
  }

  override func tearDown() {
    if config.testAgainstSqlServer {
      try! client.query("drop database \(type(of: self))")
    }

    client = nil

    super.tearDown()
  }

  func testDescribesTable() throws {
    guard config.testAgainstSqlServer else {
      return
    }

    // When
    let response = try client.query("describe \(type(of: self))", rowType: TableColumnDescription.self)

    // Then
    switch response {
    case .Results(let iterator):
      let descriptions = Array(iterator)
      XCTAssertEqual(descriptions, [
        TableColumnDescription(field: "name", fieldType: "varchar(20)", isNullable: true, key: "", defaultValue: nil, extraInformation: ""),
        TableColumnDescription(field: "owner", fieldType: "varchar(20)", isNullable: true, key: "", defaultValue: nil, extraInformation: ""),
        TableColumnDescription(field: "species", fieldType: "varchar(20)", isNullable: true, key: "", defaultValue: nil, extraInformation: ""),
        TableColumnDescription(field: "sex", fieldType: "char(1)", isNullable: true, key: "", defaultValue: nil, extraInformation: ""),
        TableColumnDescription(field: "birth", fieldType: "date", isNullable: true, key: "", defaultValue: nil, extraInformation: ""),
        TableColumnDescription(field: "death", fieldType: "date", isNullable: true, key: "", defaultValue: nil, extraInformation: ""),
      ])
    default:
      XCTFail("Unexpected response \(response)")
    }
  }
}
