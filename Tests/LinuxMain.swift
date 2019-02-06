import XCTest

import MySqlConnectorTests
import FixedWidthInteger_bytesTests

var tests = [XCTestCaseEntry]()
tests += MySqlConnectorTests.__allTests()
tests += FixedWidthInteger_bytesTests.__allTests()

XCTMain(tests)
