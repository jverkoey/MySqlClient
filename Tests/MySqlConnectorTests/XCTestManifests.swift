import XCTest

extension LengthEncodedIntegerDecodingTests {
    static let __allTests = [
        ("test0x00Through0xfbIsOneByteInteger", test0x00Through0xfbIsOneByteInteger),
        ("test0xfcIsTwoByteInteger", test0xfcIsTwoByteInteger),
        ("test0xfdIsThreeByteInteger", test0xfdIsThreeByteInteger),
        ("test0xfeIsEightByteInteger", test0xfeIsEightByteInteger),
        ("test0xfeIsNilWithLessThanNineBytesOfData", test0xfeIsNilWithLessThanNineBytesOfData),
        ("test0xffIsNil", test0xffIsNil),
        ("testNilWithEmptyData", testNilWithEmptyData),
    ]
}

extension LengthEncodedIntegerEncodingTests {
    static let __allTests = [
        ("test0xfcTwoByteEncoding", test0xfcTwoByteEncoding),
        ("test0xfcTwoByteEncodingAsData", test0xfcTwoByteEncodingAsData),
        ("test0xfdTwoByteEncoding", test0xfdTwoByteEncoding),
        ("test0xfdTwoByteEncodingAsData", test0xfdTwoByteEncodingAsData),
        ("test0xfeTwoByteEncoding", test0xfeTwoByteEncoding),
        ("test0xfeTwoByteEncodingAsData", test0xfeTwoByteEncodingAsData),
        ("testEightByteEncodingMax", testEightByteEncodingMax),
        ("testEightByteEncodingMaxAsData", testEightByteEncodingMaxAsData),
        ("testEightByteEncodingMin", testEightByteEncodingMin),
        ("testEightByteEncodingMinAsData", testEightByteEncodingMinAsData),
        ("testOneByteEncoding", testOneByteEncoding),
        ("testOneByteEncodingAsData", testOneByteEncodingAsData),
        ("testThreeByteEncodingMax", testThreeByteEncodingMax),
        ("testThreeByteEncodingMaxAsData", testThreeByteEncodingMaxAsData),
        ("testThreeByteEncodingMin", testThreeByteEncodingMin),
        ("testThreeByteEncodingMinAsData", testThreeByteEncodingMinAsData),
        ("testTwoByteEncodingMax", testTwoByteEncodingMax),
        ("testTwoByteEncodingMaxAsData", testTwoByteEncodingMaxAsData),
    ]
}

extension LengthEncodedStringDecodingTests {
    static let __allTests = [
        ("testEightByteStringMin", testEightByteStringMin),
        ("testEmptyString", testEmptyString),
        ("testNilWithEmptyData", testNilWithEmptyData),
        ("testOneByteString", testOneByteString),
        ("testThreeByteStringMax", testThreeByteStringMax),
        ("testThreeByteStringMin", testThreeByteStringMin),
        ("testTwoByteStringMax", testTwoByteStringMax),
        ("testTwoByteStringMin", testTwoByteStringMin),
    ]
}

extension MySqlConnectorTests {
    static let __allTests = [
        ("testConnectToServer", testConnectToServer),
    ]
}

extension PacketTests {
    static let __allTests = [
        ("testSucceedsWithFullPayload", testSucceedsWithFullPayload),
        ("testThrowsPacketErrorWithEmptyPacket", testThrowsPacketErrorWithEmptyPacket),
        ("testThrowsPacketErrorWithPartialPacketHeader", testThrowsPacketErrorWithPartialPacketHeader),
        ("testThrowsPayloadErrorWithEmptyPayload", testThrowsPayloadErrorWithEmptyPayload),
        ("testThrowsPayloadErrorWithPartialPayload", testThrowsPayloadErrorWithPartialPayload),
    ]
}

#if !os(macOS)
public func __allTests() -> [XCTestCaseEntry] {
    return [
        testCase(LengthEncodedIntegerDecodingTests.__allTests),
        testCase(LengthEncodedIntegerEncodingTests.__allTests),
        testCase(LengthEncodedStringDecodingTests.__allTests),
        testCase(MySqlConnectorTests.__allTests),
        testCase(PacketTests.__allTests),
    ]
}
#endif
