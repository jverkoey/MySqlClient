import XCTest

import MySqlConnectorTests

var tests = [XCTestCaseEntry]()
tests += MySqlConnectorTests.__allTests()

XCTMain(tests)
