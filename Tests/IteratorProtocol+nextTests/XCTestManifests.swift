import XCTest

extension Tests {
    static let __allTests = [
        ("testMaxLength0ReturnsNothing", testMaxLength0ReturnsNothing),
        ("testMaxLength1ReturnsOne", testMaxLength1ReturnsOne),
        ("testMaxLengthExceedingIteratorDataReturnsAll", testMaxLengthExceedingIteratorDataReturnsAll),
    ]
}

#if !os(macOS)
public func __allTests() -> [XCTestCaseEntry] {
    return [
        testCase(Tests.__allTests),
    ]
}
#endif
