import XCTest
import FixedWidthInteger_bytes
@testable import LengthEncodedInteger

class EncodingTests: XCTestCase {

  // MARK: Initializers

  func testOneByteEncoding() throws {
    for byte: UInt8 in 0x00...0xfb {
      // Given
      let value: UInt8 = byte

      // When
      let integer = LengthEncodedInteger(value: UInt64(value))

      // Then
      XCTAssertEqual(integer.value, UInt64(value))
      XCTAssertEqual(integer.length, 1)
    }
  }

  func test0xfcTwoByteEncoding() throws {
    // Given
    let value: UInt8 = 0xfc

    // When
    let integer = LengthEncodedInteger(value: UInt64(value))

    // Then
    XCTAssertEqual(integer.value, UInt64(value))
    XCTAssertEqual(integer.length, 3)
  }

  func test0xfdTwoByteEncoding() throws {
    // Given
    let value: UInt8 = 0xfd

    // When
    let integer = LengthEncodedInteger(value: UInt64(value))

    // Then
    XCTAssertEqual(integer.value, UInt64(value))
    XCTAssertEqual(integer.length, 3)
  }

  func test0xfeTwoByteEncoding() throws {
    // Given
    let value: UInt8 = 0xfe

    // When
    let integer = LengthEncodedInteger(value: UInt64(value))

    // Then
    XCTAssertEqual(integer.value, UInt64(value))
    XCTAssertEqual(integer.length, 3)
  }

  func testTwoByteEncodingMax() throws {
    // Given
    let value: UInt16 = 0x1000

    // When
    let integer = LengthEncodedInteger(value: UInt64(value))

    // Then
    XCTAssertEqual(integer.value, UInt64(value))
    XCTAssertEqual(integer.length, 3)
  }

  func testThreeByteEncodingMin() throws {
    // Given
    let value: UInt32 = 0x00010000

    // When
    let integer = LengthEncodedInteger(value: UInt64(value))

    // Then
    XCTAssertEqual(integer.value, UInt64(value))
    XCTAssertEqual(integer.length, 4)
  }

  func testThreeByteEncodingMax() throws {
    // Given
    let value: UInt32 = 0x00ffffff

    // When
    let integer = LengthEncodedInteger(value: UInt64(value))

    // Then
    XCTAssertEqual(integer.value, UInt64(value))
    XCTAssertEqual(integer.length, 4)
  }

  func testEightByteEncodingMin() throws {
    // Given
    let value: UInt32 = 0x01000000

    // When
    let integer = LengthEncodedInteger(value: UInt64(value))

    // Then
    XCTAssertEqual(integer.value, UInt64(value))
    XCTAssertEqual(integer.length, 9)
  }

  func testEightByteEncodingMax() throws {
    // Given
    let value: UInt64 = 0xffffffffffffffff

    // When
    let integer = LengthEncodedInteger(value: UInt64(value))

    // Then
    XCTAssertEqual(integer.value, UInt64(value))
    XCTAssertEqual(integer.length, 9)
  }

  // MARK: Data representation

  func testOneByteEncodingAsData() throws {
    for byte: UInt8 in 0x00...0xfb {
      // Given
      let value: UInt8 = byte
      let integer = LengthEncodedInteger(value: UInt64(value))

      // When
      let data = integer.asData()

      // Then
      XCTAssertEqual([UInt8](data), [value])
    }
  }

  func test0xfcTwoByteEncodingAsData() throws {
    // Given
    let value: UInt8 = 0xfc
    let integer = LengthEncodedInteger(value: UInt64(value))

    // When
    let data = integer.asData()

    // Then
    XCTAssertEqual([UInt8](data), [0x0fc, value, 0x00])
  }

  func test0xfdTwoByteEncodingAsData() throws {
    // Given
    let value: UInt8 = 0xfd
    let integer = LengthEncodedInteger(value: UInt64(value))

    // When
    let data = integer.asData()

    // Then
    XCTAssertEqual([UInt8](data), [0x0fc, value, 0x00])
  }

  func test0xfeTwoByteEncodingAsData() throws {
    // Given
    let value: UInt8 = 0xfe
    let integer = LengthEncodedInteger(value: UInt64(value))

    // When
    let data = integer.asData()

    // Then
    XCTAssertEqual([UInt8](data), [0x0fc, value, 0x00])
  }

  func testTwoByteEncodingMaxAsData() throws {
    // Given
    let value: UInt16 = 0x1000
    let integer = LengthEncodedInteger(value: UInt64(value))

    // When
    let data = integer.asData()

    // Then
    XCTAssertEqual([UInt8](data), [0x0fc] + value.bytes)
  }

  func testThreeByteEncodingMinAsData() throws {
    // Given
    let value: UInt32 = 0x00010000
    let integer = LengthEncodedInteger(value: UInt64(value))

    // When
    let data = integer.asData()

    // Then
    XCTAssertEqual([UInt8](data), [0x0fd] + value.bytes[0...2])
  }

  func testThreeByteEncodingMaxAsData() throws {
    // Given
    let value: UInt32 = 0x00ffffff
    let integer = LengthEncodedInteger(value: UInt64(value))

    // When
    let data = integer.asData()

    // Then
    XCTAssertEqual([UInt8](data), [0x0fd] + value.bytes[0...2])
  }

  func testEightByteEncodingMinAsData() throws {
    // Given
    let value: UInt32 = 0x01000000
    let integer = LengthEncodedInteger(value: UInt64(value))

    // When
    let data = integer.asData()

    // Then
    XCTAssertEqual([UInt8](data), [0x0fe] + value.bytes + [UInt8](repeating: 0, count: 4))
  }

  func testEightByteEncodingMaxAsData() throws {
    // Given
    let value: UInt64 = 0xffffffffffffffff
    let integer = LengthEncodedInteger(value: UInt64(value))

    // When
    let data = integer.asData()

    // Then
    XCTAssertEqual([UInt8](data), [0x0fe] + value.bytes)
  }
}
