import XCTest

import LengthEncodedIntegerTests
import MySqlConnectorTests
import FixedWidthInteger_bytesTests

var tests = [XCTestCaseEntry]()
tests += LengthEncodedIntegerTests.__allTests()
tests += MySqlConnectorTests.__allTests()
tests += FixedWidthInteger_bytesTests.__allTests()

XCTMain(tests)
