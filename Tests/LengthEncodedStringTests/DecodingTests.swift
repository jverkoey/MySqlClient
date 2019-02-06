import XCTest
import LengthEncodedInteger
@testable import LengthEncodedString

class DecodingTests: XCTestCase {

  func testNilWithEmptyData() throws {
    // Given
    let data = Data()

    // Then
    XCTAssertNil(try LengthEncodedString(data: data, encoding: .utf8))
  }

  func testEmptyString() throws {
    // Given
    let data = Data([0x00])

    // When
    let lengthEncodedString = try LengthEncodedString(data: data, encoding: .utf8)

    // Then
    XCTAssertEqual(lengthEncodedString?.value, "")
  }

  func testOneByteString() throws {
    // Given
    let string = String(repeating: "A", count: 0xfb)
    let data = LengthEncodedInteger(value: UInt64(string.lengthOfBytes(using: .utf8))).asData() + string.utf8

    // When
    let lengthEncodedString = try LengthEncodedString(data: data, encoding: .utf8)

    // Then
    XCTAssertEqual(lengthEncodedString?.value, string)
    XCTAssertEqual(lengthEncodedString!.length, UInt64(string.lengthOfBytes(using: .utf8)) + 1)
  }

  func testTwoByteStringMin() throws {
    // Given
    let string = String(repeating: "A", count: 0xfc)
    let data = LengthEncodedInteger(value: UInt64(string.lengthOfBytes(using: .utf8))).asData() + string.utf8

    // When
    let lengthEncodedString = try LengthEncodedString(data: data, encoding: .utf8)

    // Then
    XCTAssertEqual(lengthEncodedString?.value, string)
    XCTAssertEqual(lengthEncodedString!.length, UInt64(string.lengthOfBytes(using: .utf8)) + 3)
  }

  func testTwoByteStringMax() throws {
    // Given
    let string = String(repeating: "A", count: 0xFFFF)
    let data = LengthEncodedInteger(value: UInt64(string.lengthOfBytes(using: .utf8))).asData() + string.utf8

    // When
    let lengthEncodedString = try LengthEncodedString(data: data, encoding: .utf8)

    // Then
    XCTAssertEqual(lengthEncodedString?.value, string)
    XCTAssertEqual(lengthEncodedString!.length, UInt64(string.lengthOfBytes(using: .utf8)) + 3)
  }

  func testThreeByteStringMin() throws {
    // Given
    let string = String(repeating: "A", count: 0x10000)
    let data = LengthEncodedInteger(value: UInt64(string.lengthOfBytes(using: .utf8))).asData() + string.utf8

    // When
    let lengthEncodedString = try LengthEncodedString(data: data, encoding: .utf8)

    // Then
    XCTAssertEqual(lengthEncodedString?.value, string)
    XCTAssertEqual(lengthEncodedString!.length, UInt64(string.lengthOfBytes(using: .utf8)) + 4)
  }

  func testThreeByteStringMax() throws {
    // Given
    let string = String(repeating: "A", count: 0xFFFFFF)
    let data = LengthEncodedInteger(value: UInt64(string.lengthOfBytes(using: .utf8))).asData() + string.utf8

    // When
    let lengthEncodedString = try LengthEncodedString(data: data, encoding: .utf8)

    // Then
    XCTAssertEqual(lengthEncodedString?.value, string)
    XCTAssertEqual(lengthEncodedString!.length, UInt64(string.lengthOfBytes(using: .utf8)) + 4)
  }

  func testEightByteStringMin() throws {
    // Given
    let string = String(repeating: "A", count: 0x1000000)
    let data = LengthEncodedInteger(value: UInt64(string.lengthOfBytes(using: .utf8))).asData() + string.utf8

    // When
    let lengthEncodedString = try LengthEncodedString(data: data, encoding: .utf8)

    // Then
    XCTAssertEqual(lengthEncodedString?.value, string)
    XCTAssertEqual(lengthEncodedString!.length, UInt64(string.lengthOfBytes(using: .utf8)) + 9)
  }
}
