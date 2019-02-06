import XCTest

extension DecodingTests {
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

#if !os(macOS)
public func __allTests() -> [XCTestCaseEntry] {
    return [
        testCase(DecodingTests.__allTests),
    ]
}
#endif
