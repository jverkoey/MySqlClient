import XCTest

extension MySqlConnectorTests {
    static let __allTests = [
        ("testConnectToServer", testConnectToServer),
    ]
}

extension PacketDecodingTests {
    static let __allTests = [
        ("testSuccess", testSuccess),
        ("testThrowsWithEmptyData", testThrowsWithEmptyData),
        ("testThrowsWithMissingPayload", testThrowsWithMissingPayload),
        ("testThrowsWithPartialPacketHeader", testThrowsWithPartialPacketHeader),
        ("testThrowsWithPartialPayload", testThrowsWithPartialPayload),
    ]
}

#if !os(macOS)
public func __allTests() -> [XCTestCaseEntry] {
    return [
        testCase(LengthEncodedIntegerDecodingTests.__allTests),
        testCase(LengthEncodedIntegerEncodingTests.__allTests),
        testCase(LengthEncodedStringDecodingTests.__allTests),
        testCase(MySqlConnectorTests.__allTests),
        testCase(PacketDecodingTests.__allTests),
    ]
}
#endif
