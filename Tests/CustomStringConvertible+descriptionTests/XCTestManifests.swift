import XCTest

extension Tests {
    static let __allTests = [
        ("testObject", testObject),
        ("testObjectWithNestedObjects", testObjectWithNestedObjects),
        ("testObjectWithProperties", testObjectWithProperties),
    ]
}

#if !os(macOS)
public func __allTests() -> [XCTestCaseEntry] {
    return [
        testCase(Tests.__allTests),
    ]
}
#endif
