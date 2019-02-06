import XCTest

extension Tests {
    static let __allTests = [
        ("testXorsEmptyData", testXorsEmptyData),
        ("testXorsMultipleBytes", testXorsMultipleBytes),
        ("testXorsOneByte", testXorsOneByte),
        ("testXorsUpToSmallerOfBothValuesLeftHandSide", testXorsUpToSmallerOfBothValuesLeftHandSide),
        ("testXorsUpToSmallerOfBothValuesRightHandSide", testXorsUpToSmallerOfBothValuesRightHandSide),
    ]
}

#if !os(macOS)
public func __allTests() -> [XCTestCaseEntry] {
    return [
        testCase(Tests.__allTests),
    ]
}
#endif
