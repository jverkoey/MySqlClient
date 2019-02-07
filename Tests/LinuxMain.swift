import XCTest

import MySqlConnectorTests
import IteratorProtocol_nextTests
import CustomStringConvertible_descriptionTests
import Data_xoredTests
import FixedWidthInteger_bytesTests

var tests = [XCTestCaseEntry]()
tests += MySqlConnectorTests.__allTests()
tests += IteratorProtocol_nextTests.__allTests()
tests += CustomStringConvertible_descriptionTests.__allTests()
tests += Data_xoredTests.__allTests()
tests += FixedWidthInteger_bytesTests.__allTests()

XCTMain(tests)
