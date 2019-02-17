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

@testable import MySqlConnector
import XCTest

private struct Object: Codable {
  let name: String
  let age: Int
}

final class MySqlQueryTests: XCTestCase {

  func testInsertSingleObject() throws {
    // Given
    let encoder = MySqlQueryEncoder()
    let object = Object(name: "tests", age: 123)
    let table = "some_table"

    // When
    let query = try encoder.insert(object, intoTable: table)

    // Then
    XCTAssertEqual(query, """
INSERT INTO some_table (`name`,`age`) VALUES (\"tests\",\"123\") ON DUPLICATE KEY UPDATE `name`=VALUES(`name`),`age`=VALUES(`age`)
""")
  }

  func testInsertMultipleObjects() throws {
    // Given
    let encoder = MySqlQueryEncoder()
    let objects = [Object(name: "object1", age: 123), Object(name: "object2", age: 456)]
    let table = "some_table"

    // When
    let query = try encoder.insert(objects, intoTable: table)

    // Then
    XCTAssertEqual(query, """
INSERT INTO some_table (`age`,`name`) VALUES (\"123\",\"object1\"),(\"456\",\"object2\") ON DUPLICATE KEY UPDATE `age`=VALUES(`age`),`name`=VALUES(`name`)
""")
  }

  func testInsertWithMaxDuplicateKeyBehavior() throws {
    // Given
    let encoder = MySqlQueryEncoder()
    let objects = [Object(name: "object1", age: 123), Object(name: "object2", age: 456)]
    let table = "some_table"

    // When
    let query = try encoder.insert(objects, intoTable: table, duplicateKeyBehaviors: ["age": .max])

    // Then
    XCTAssertEqual(query, """
INSERT INTO some_table (`age`,`name`) VALUES ("123","object1"),("456","object2") ON DUPLICATE KEY UPDATE `age`=GREATEST(VALUES(`age`),`age`),`name`=VALUES(`name`)
""")
  }

  func testInsertIgnoresFields() throws {
    // Given
    let encoder = MySqlQueryEncoder()
    let objects = [Object(name: "object1", age: 123), Object(name: "object2", age: 456)]
    let table = "some_table"

    // When
    let query = try encoder.insert(objects, intoTable: table, ignoredFields: ["name"])

    // Then
    XCTAssertEqual(query, """
INSERT INTO some_table (`age`) VALUES ("123"),("456") ON DUPLICATE KEY UPDATE `age`=VALUES(`age`)
""")
  }
}
