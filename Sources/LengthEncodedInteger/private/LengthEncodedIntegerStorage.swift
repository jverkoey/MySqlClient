import Foundation

/**
 Typed storage for a MySql length-encoded integer.

 Documentation: https://dev.mysql.com/doc/internals/en/integer.html#length-encoded-integer
 */
enum LengthEncodedIntegerStorage {
  case one(value: UInt8)
  case two(value: UInt16)
  case three(value: UInt32)
  case eight(value: UInt64)
}
