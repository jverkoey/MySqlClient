import Foundation

/**
 Length-encoded integer type parsing.
 */
enum LengthEncodedIntegerType {
  case one
  case two
  case three
  case eight

  init?(firstByte: UInt8) {
    switch firstByte {
    case 0xff: return nil // Error packet / undefined.
    case 0xfc: self = .two
    case 0xfd: self = .three
    case 0xfe: self = .eight // May be an EOF packet. See LengthEncodedInteger implementation for details.
    default: self = .one
    }
  }

  /**
   Determines the length-encoded integer type required to represent the given value.

   https://dev.mysql.com/doc/internals/en/integer.html
   */
  init(value: UInt64) {
    if value < 0xfc {
      self = .one
    } else if value <= 0xFFFF {
      self = .two
    } else if value <= 0xFFFFFF {
      self = .three
    } else {
      self = .eight
    }
  }

  var length: UInt {
    switch self {
    case .one:
      return 1
    case .two:
      return 3
    case .three:
      return 4
    case .eight:
      return 9
    }
  }
}
