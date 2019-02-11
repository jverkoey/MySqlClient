import XCTest

import MySqlConnectorTests
import Data_xoredTests
import FixedWidthInteger_bytesTests
import IteratorProtocol_nextTests
import LazyDataStreamTests
import CustomStringConvertible_descriptionTests

var tests = [XCTestCaseEntry]()
tests += MySqlConnectorTests.__allTests()
tests += Data_xoredTests.__allTests()
tests += FixedWidthInteger_bytesTests.__allTests()
tests += IteratorProtocol_nextTests.__allTests()
tests += LazyDataStreamTests.__allTests()
tests += CustomStringConvertible_descriptionTests.__allTests()

XCTMain(tests)
