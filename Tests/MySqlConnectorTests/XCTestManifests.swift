import XCTest

extension CustomStringConvertibleDescriptionTests {
    static let __allTests = [
        ("testObject", testObject),
        ("testObjectWithNestedObjects", testObjectWithNestedObjects),
        ("testObjectWithProperties", testObjectWithProperties),
    ]
}

extension DataXoredTests {
    static let __allTests = [
        ("testXorsEmptyData", testXorsEmptyData),
        ("testXorsMultipleBytes", testXorsMultipleBytes),
        ("testXorsOneByte", testXorsOneByte),
        ("testXorsUpToSmallerOfBothValuesLeftHandSide", testXorsUpToSmallerOfBothValuesLeftHandSide),
        ("testXorsUpToSmallerOfBothValuesRightHandSide", testXorsUpToSmallerOfBothValuesRightHandSide),
    ]
}

extension DatabaseManagementTests {
    static let __allTests = [
        ("testCreatesAndDeletesDatabase", testCreatesAndDeletesDatabase),
    ]
}

extension HandshakeDecodingTests {
    static let __allTests = [
        ("testShortv10HandshakeSucceeds", testShortv10HandshakeSucceeds),
        ("testThrowsWithEmptyData", testThrowsWithEmptyData),
        ("testThrowsWithUnsupportedProtocol", testThrowsWithUnsupportedProtocol),
    ]
}

extension HandshakeResponseEncodingTests {
    static let __allTests = [
        ("testSucceedsWithAllCapabilities", testSucceedsWithAllCapabilities),
        ("testSucceedsWithNoCapabilities", testSucceedsWithNoCapabilities),
    ]
}

extension HandshakeTests {
    static let __allTests = [
        ("testAuthFailsWithInvalidPassword", testAuthFailsWithInvalidPassword),
        ("testAuthSucceedsWithValidPassword", testAuthSucceedsWithValidPassword),
        ("testHandshake", testHandshake),
    ]
}

extension LengthEncodedIntegerDecodingTests {
    static let __allTests = [
        ("test0x00Through0xfbIsOneByteInteger", test0x00Through0xfbIsOneByteInteger),
        ("test0xfcIsTwoByteInteger", test0xfcIsTwoByteInteger),
        ("test0xfdIsThreeByteInteger", test0xfdIsThreeByteInteger),
        ("test0xfeIsEightByteInteger", test0xfeIsEightByteInteger),
        ("test0xfeThrowsWithLessThanNineBytesOfData", test0xfeThrowsWithLessThanNineBytesOfData),
        ("test0xffThrows", test0xffThrows),
        ("testThrowsWithEmptyData", testThrowsWithEmptyData),
    ]
}

extension LengthEncodedIntegerEncodingTests {
    static let __allTests = [
        ("testNothing", testNothing),
    ]
}

extension LengthEncodedIntegerInitializationTests {
    static let __allTests = [
        ("test0xfcTwoByteEncoding", test0xfcTwoByteEncoding),
        ("test0xfdTwoByteEncoding", test0xfdTwoByteEncoding),
        ("test0xfeTwoByteEncoding", test0xfeTwoByteEncoding),
        ("testEightByteEncodingMax", testEightByteEncodingMax),
        ("testEightByteEncodingMin", testEightByteEncodingMin),
        ("testOneByteEncoding", testOneByteEncoding),
        ("testThreeByteEncodingMax", testThreeByteEncodingMax),
        ("testThreeByteEncodingMin", testThreeByteEncodingMin),
        ("testTwoByteEncodingMax", testTwoByteEncodingMax),
    ]
}

extension LengthEncodedStringDecodingTests {
    static let __allTests = [
        ("testEightByteStringMin", testEightByteStringMin),
        ("testEightByteStringPerformance", testEightByteStringPerformance),
        ("testEmptyString", testEmptyString),
        ("testNilWithEmptyData", testNilWithEmptyData),
        ("testOneByteString", testOneByteString),
        ("testThreeByteStringMax", testThreeByteStringMax),
        ("testThreeByteStringMin", testThreeByteStringMin),
        ("testTwoByteStringMax", testTwoByteStringMax),
        ("testTwoByteStringMin", testTwoByteStringMin),
    ]
}

extension MySqlClientTests {
    static let __allTests = [
        ("testConnects", testConnects),
        ("testReusesIdleConnection", testReusesIdleConnection),
    ]
}

extension PacketDecodingTests {
    static let __allTests = [
        ("testSuccess", testSuccess),
        ("testThrowsWithDataMissingFromPayload", testThrowsWithDataMissingFromPayload),
        ("testThrowsWithEmptyData", testThrowsWithEmptyData),
        ("testThrowsWithMissingPayload", testThrowsWithMissingPayload),
        ("testThrowsWithNoNullTerminatorEvenIfNullTerminatorIsInFollowingPacket", testThrowsWithNoNullTerminatorEvenIfNullTerminatorIsInFollowingPacket),
        ("testThrowsWithPartialPacketHeader", testThrowsWithPartialPacketHeader),
        ("testThrowsWithPartialPayload", testThrowsWithPartialPayload),
        ("testThrowsWithPartialPayloadSize", testThrowsWithPartialPayloadSize),
    ]
}

extension PacketEncodingTests {
    static let __allTests = [
        ("testSucceeds", testSucceeds),
        ("testSucceedsAsPacket", testSucceedsAsPacket),
    ]
}

extension QueryTests {
    static let __allTests = [
        ("testShowVariablesAsDictionaries", testShowVariablesAsDictionaries),
        ("testShowVariablesAsObjects", testShowVariablesAsObjects),
    ]
}

#if !os(macOS)
public func __allTests() -> [XCTestCaseEntry] {
    return [
        testCase(CustomStringConvertibleDescriptionTests.__allTests),
        testCase(DataXoredTests.__allTests),
        testCase(DatabaseManagementTests.__allTests),
        testCase(HandshakeDecodingTests.__allTests),
        testCase(HandshakeResponseEncodingTests.__allTests),
        testCase(HandshakeTests.__allTests),
        testCase(LengthEncodedIntegerDecodingTests.__allTests),
        testCase(LengthEncodedIntegerEncodingTests.__allTests),
        testCase(LengthEncodedIntegerInitializationTests.__allTests),
        testCase(LengthEncodedStringDecodingTests.__allTests),
        testCase(MySqlClientTests.__allTests),
        testCase(PacketDecodingTests.__allTests),
        testCase(PacketEncodingTests.__allTests),
        testCase(QueryTests.__allTests),
    ]
}
#endif
