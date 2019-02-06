import Foundation

/**
 A throwable length-encoded string decoding error.
 */
public enum LengthEncodedStringDecodingError: Error, Equatable {

  /**
   The length-encoded string expected an amount of data that was not available.

   - Parameter expectedAtLeast: The number of expected bytes.
   */
  case unexpectedEndOfData(expectedAtLeast: UInt)

  /**
   The length-encoded string expected an amount of data that was not available.

   - Parameter expectedAtLeast: The number of expected bytes.
   */
  case unableToCreateStringWithEncoding(_ encoding: String.Encoding)
}
