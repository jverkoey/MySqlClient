import XCTest

extension DecodingTests {
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

extension EncodingTests {
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

#if !os(macOS)
public func __allTests() -> [XCTestCaseEntry] {
    return [
        testCase(DecodingTests.__allTests),
        testCase(EncodingTests.__allTests),
    ]
}
#endif
