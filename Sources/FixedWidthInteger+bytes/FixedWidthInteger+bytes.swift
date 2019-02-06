import Foundation

extension FixedWidthInteger {
  /**
   Returns a byte array representation of a fixed-width integer in little endian format.
   */
  public var bytes: [UInt8] {
    let bitWidth = type(of: self).bitWidth
    return stride(from: 0, to: bitWidth, by: 8).map { UInt8((self >> $0) & 0xFF) }
  }
}
