import XCTest

import LengthEncodedStringTests
import LengthEncodedIntegerTests
import MySqlConnectorTests
import IteratorProtocol_nextTests
import Data_xoredTests
import FixedWidthInteger_bytesTests

var tests = [XCTestCaseEntry]()
tests += LengthEncodedStringTests.__allTests()
tests += LengthEncodedIntegerTests.__allTests()
tests += MySqlConnectorTests.__allTests()
tests += IteratorProtocol_nextTests.__allTests()
tests += Data_xoredTests.__allTests()
tests += FixedWidthInteger_bytesTests.__allTests()

XCTMain(tests)
