import XCTest

import MySqlConnectorTests
import BinaryCodableTests
import Data_xoredTests
import FixedWidthInteger_bytesTests
import CustomStringConvertible_descriptionTests

var tests = [XCTestCaseEntry]()
tests += MySqlConnectorTests.__allTests()
tests += BinaryCodableTests.__allTests()
tests += Data_xoredTests.__allTests()
tests += FixedWidthInteger_bytesTests.__allTests()
tests += CustomStringConvertible_descriptionTests.__allTests()

XCTMain(tests)
