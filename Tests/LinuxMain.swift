import XCTest

import MySqlConnectorTests
import BinaryCodableTests

var tests = [XCTestCaseEntry]()
tests += MySqlConnectorTests.__allTests()
tests += BinaryCodableTests.__allTests()

XCTMain(tests)
