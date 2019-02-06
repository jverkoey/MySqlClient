import Foundation
import FixedWidthInteger_bytes

/**
 A MySql length-encoded integer.

 Documentation: https://dev.mysql.com/doc/internals/en/integer.html#length-encoded-integer
 */
public struct LengthEncodedInteger {

  /**
   Attempts to initialize a length-encoded integer from the provided `data`. If the data does not represent a
   length-encoded integer, then nil is returned.

   - Parameter data: The data from which the length-encoded integer should be parsed.
   - Throws: `LengthEncodedIntegerError.unexpectedEndOfData` If `data` looks like a length-encoded integer but its
   length is less than the expected amount.
   */
  public init?(data: Data) throws {
    // Empty data is not a length-encoded integer.
    if data.isEmpty {
      return nil
    }

    guard let type = LengthEncodedIntegerType(firstByte: data[0]) else {
      return nil
    }

    // The MySql documentation says to verify eight-byte integers by checking the amount of available data:
    // > The EOF packet may appear in places where a Protocol::LengthEncodedInteger may appear. You must check whether
    // > the packet length is less than 9 to make sure that it is a EOF packet.
    // > https://dev.mysql.com/doc/internals/en/packet-EOF_Packet.html
    // > https://dev.mysql.com/doc/internals/en/integer.html
    if type == .eight && data.count < type.length {
      return nil
    }

    self.type = type

    // For all other known types, missing data is a runtime error.
    if data.count < type.length {
      throw LengthEncodedIntegerDecodingError.unexpectedEndOfData(expectedAtLeast: UInt(type.length))
    }

    // Parse the data into the relevant storage.
    switch type {
    case .one:
      self.storage = .one(value: data[0])
    case .two:
      let value = data[1...2].withUnsafeBytes { (ptr: UnsafePointer<UInt16>) -> UInt16 in
        return ptr.pointee
      }
      self.storage = .two(value: value)
    case .three:
      let value = (data[1...3] + [0x00]).withUnsafeBytes { (ptr: UnsafePointer<UInt32>) -> UInt32 in
        return ptr.pointee
      }
      self.storage = .three(value: value)
    case .eight:
      let value = (data[1...7]).withUnsafeBytes { (ptr: UnsafePointer<UInt64>) -> UInt64 in
        return ptr.pointee
      }
      self.storage = .eight(value: value)
    }
  }

  /**
   Initializes the length-encoded integer with the given value.
   */
  public init(value: UInt64) {
    self.type = LengthEncodedIntegerType(value: value)
    switch type {
    case .one:
      self.storage = .one(value: UInt8(value))
    case .two:
      self.storage = .two(value: UInt16(value))
    case .three:
      self.storage = .three(value: UInt32(value))
    case .eight:
      self.storage = .eight(value: UInt64(value))
    }
  }

  /**
   Returns a Data representation of this length-encoded integer.
   */
  public func asData() -> Data {
    switch storage {
    case .one(let value):
      return Data([value])
    case .two(let value):
      return Data([0xfc] + value.bytes)
    case .three(let value):
      return Data([0xfd] + value.bytes[0...2])
    case .eight(let value):
      return Data([0xfe] + value.bytes)
    }
  }

  /**
   A 64 bit representation of this length-encoded integer's value.
   */
  public var value: UInt64 {
    switch storage {
    case .one(let value):
      return UInt64(value)
    case .two(let value):
      return UInt64(value)
    case .three(let value):
      return UInt64(value)
    case .eight(let value):
      return UInt64(value)
    }
  }

  /**
   The number of bytes required to represent this length-encoded integer.
   */
  public var length: UInt {
    return type.length
  }

  private let type: LengthEncodedIntegerType
  private let storage: LengthEncodedIntegerStorage
}
