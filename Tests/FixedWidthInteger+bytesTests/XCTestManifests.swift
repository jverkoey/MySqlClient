import XCTest

extension Tests {
    static let __allTests = [
        ("testIntDependsOnThePlatform", testIntDependsOnThePlatform),
        ("testUInt16IsTwoBytesInLittleEndian", testUInt16IsTwoBytesInLittleEndian),
        ("testUInt32IsFourBytesInLittleEndian", testUInt32IsFourBytesInLittleEndian),
        ("testUInt64IsEightBytesInLittleEndian", testUInt64IsEightBytesInLittleEndian),
        ("testUInt8IsOneByte", testUInt8IsOneByte),
    ]
}

#if !os(macOS)
public func __allTests() -> [XCTestCaseEntry] {
    return [
        testCase(Tests.__allTests),
    ]
}
#endif
