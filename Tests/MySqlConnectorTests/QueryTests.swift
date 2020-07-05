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
@testable import MySqlConnector
import XCTest

struct Variable: Codable {
  let Variable_name: String
  let Value: String
}

final class QueryTests: XCTestCase {
  var client: MySqlClient!
  let config = TestConfig.environment
  override func setUp() {
    super.setUp()

    client = MySqlClient(to: config.host,
                         port: config.port,
                         username: config.user,
                         password: config.pass,
                         database: nil)
  }

  override func tearDown() {
    client = nil

    super.tearDown()
  }

  func testShowVariablesAsDictionaries() throws {
    guard config.testAgainstSqlServer else {
      return
    }

    // Given
    let query = "SHOW VARIABLES;"

    // When
    let response = try client.query(query)

    // Then
    switch response {
    case .Results(let iterator):
      let keyValues = Array(iterator)
      XCTAssertGreaterThan(keyValues.count, 0)

    default:
      XCTFail("Unexpected response \(response)")
    }
  }

  func testShowVariablesAsObjects() throws {
    guard config.testAgainstSqlServer else {
      return
    }

    // Given
    let query = "SHOW VARIABLES;"

    // When
    let response = try client.query(query, rowType: Variable.self)

    // Then
    switch response {
    case .Results(let iterator):
      let keyValues = Array(iterator)
      XCTAssertGreaterThan(keyValues.count, 0)

    default:
      XCTFail("Unexpected response \(response)")
    }
  }

  func testMySqlTestcase() throws {
    guard config.testAgainstSqlServer else {
      return
    }

    try client.query("create database \(type(of: self))")
    try client.query("use \(type(of: self))")

    // Given
    let query = #"""
DROP TABLE IF EXISTS t1;
CREATE TABLE t1(c1 CHAR(100) NULL, c2 CHAR(100) NULL);
INSERT INTO t1 VALUES('abc','ABCDEFG');
INSERT INTO t1 VALUES('123','1234567890');
ANALYZE TABLE t1;
DROP TABLE t1;
CREATE TABLE t1(c1 VARCHAR(100) NULL, c2 VARCHAR(100) NULL);
INSERT INTO t1 VALUES('abc','ABCDEFG');
INSERT INTO t1 VALUES('123','1234567890');
ANALYZE TABLE t1;
DROP TABLE t1;
CREATE TABLE t1(c1 BINARY(100) NULL, c2 BINARY(100) NULL);
INSERT INTO t1 VALUES('abc','ABCDEFG');
INSERT INTO t1 VALUES('123','1234567890');
ANALYZE TABLE t1;
DROP TABLE t1;
CREATE TABLE t1(c1 VARBINARY(100) NULL, c2 VARBINARY(100) NULL);
INSERT INTO t1 VALUES('abc','ABCDEFG');
INSERT INTO t1 VALUES('123','1234567890');
ANALYZE TABLE t1;
DROP TABLE t1;
CREATE TABLE t1(c1 BLOB(100) NULL, c2 BLOB(100) NULL);
INSERT INTO t1 VALUES('abc','ABCDEFG');
INSERT INTO t1 VALUES('123','1234567890');
ANALYZE TABLE t1;
DROP TABLE t1;
CREATE TABLE t1(c1 TEXT(100) NULL, c2 TEXT(100) NULL);
INSERT INTO t1 VALUES('abc','ABCDEFG');
INSERT INTO t1 VALUES('123','1234567890');
ANALYZE TABLE t1;
DROP TABLE t1;
"""#

    // When
     let response = try client.query(query)

    // Then
    switch response {
    case .OK(let numberOfAffectedRows, _, _):
      XCTAssertEqual(numberOfAffectedRows, 0)

    default:
      XCTFail("Unexpected response \(response)")
    }
  }

}
