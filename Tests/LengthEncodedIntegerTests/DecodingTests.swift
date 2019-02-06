import XCTest
import FixedWidthInteger_bytes
@testable import LengthEncodedInteger

class DecodingTests: XCTestCase {

  func testNilWithEmptyData() throws {
    // Given
    let data = Data()

    // Then
    XCTAssertNil(try LengthEncodedInteger(data: data))
  }

  func test0x00Through0xfbIsOneByteInteger() throws {
    for byte: UInt8 in 0x00...0xfb {
      // Given
      let data = Data([byte])

      // When
      let integerOrNil = try LengthEncodedInteger(data: data)

      // Then
      XCTAssertNotNil(integerOrNil)
      guard let integer = integerOrNil else {
        return
      }
      XCTAssertEqual(integer.value, UInt64(byte))
      XCTAssertEqual(integer.length, 1)
    }
  }

  func test0xfcIsTwoByteInteger() throws {
    for bit in 0..<16 {
      // Given
      let value = UInt16(1) << bit
      let data = Data([0xfc] + value.bytes)

      // When
      let integerOrNil = try LengthEncodedInteger(data: data)

      // Then
      XCTAssertNotNil(integerOrNil)
      guard let integer = integerOrNil else {
        return
      }
      XCTAssertEqual(integer.value, UInt64(value))
      XCTAssertEqual(integer.length, 3)
    }
  }

  func test0xfdIsThreeByteInteger() throws {
    for bit in 0..<24 {
      // Given
      let value = UInt32(1) << bit
      let data = Data([0xfd] + value.bytes[0...2])

      // When
      let integerOrNil = try LengthEncodedInteger(data: data)

      // Then
      XCTAssertNotNil(integerOrNil)
      guard let integer = integerOrNil else {
        return
      }
      XCTAssertEqual(integer.value, UInt64(value))
      XCTAssertEqual(integer.length, 4)
    }
  }

  func test0xfeIsEightByteInteger() throws {
    for bit in 0..<64 {
      // Given
      let value = UInt64(1) << bit
      let data = Data([0xfe] + value.bytes)

      // When
      let integerOrNil = try LengthEncodedInteger(data: data)

      // Then
      XCTAssertNotNil(integerOrNil)
      guard let integer = integerOrNil else {
        return
      }
      XCTAssertEqual(integer.value, value)
      XCTAssertEqual(integer.length, 9)
    }
  }

  // MARK: Values that look like length-encoded integers, but aren't

  func test0xffIsNil() throws {
    // Given
    let data = Data([0xff])

    // When
    let integerOrNil = try LengthEncodedInteger(data: data)

    // Then
    // Is more likely an error packet
    // https://dev.mysql.com/doc/internals/en/integer.html#packet-Protocol::LengthEncodedInteger
    XCTAssertNil(integerOrNil)
  }

  func test0xfeIsNilWithLessThanNineBytesOfData() throws {
    for extraBytes in 0...7 {
      // Given
      let data = Data([0xfe] + [UInt8](repeating: 0, count: extraBytes))

      // When
      let integerOrNil = try LengthEncodedInteger(data: data)

      // Then
      // Is more likely an EOF packet.
      // https://dev.mysql.com/doc/internals/en/integer.html#packet-Protocol::LengthEncodedInteger
      XCTAssertNil(integerOrNil, "Expected an eight byte integer with \(extraBytes) extra bytes to be nil.")
    }
  }
}
