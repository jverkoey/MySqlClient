import XCTest

import MySqlConnectorTests
import BinaryCodableTests
import MySqlQueryTests

var tests = [XCTestCaseEntry]()
tests += MySqlConnectorTests.__allTests()
tests += BinaryCodableTests.__allTests()
tests += MySqlQueryTests.__allTests()

XCTMain(tests)
