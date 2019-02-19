import XCTest

import MySqlConnectorTests
import MySqlQueryTests

var tests = [XCTestCaseEntry]()
tests += MySqlConnectorTests.__allTests()
tests += MySqlQueryTests.__allTests()

XCTMain(tests)
