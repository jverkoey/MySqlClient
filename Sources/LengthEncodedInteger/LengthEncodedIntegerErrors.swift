import Foundation

/**
 A throwable length-encoded integer decoding error.
 */
public enum LengthEncodedIntegerDecodingError: Error, Equatable {

  /**
   The length-encoded integer expected an amount of data that was not available.

   - Parameter expectedAtLeast: The number of expected bytes.
   */
  case unexpectedEndOfData(expectedAtLeast: UInt)
}
