import XCTest

extension MySqlQueryTests {
    static let __allTests = [
        ("testInsertIgnoresFields", testInsertIgnoresFields),
        ("testInsertMultipleObjects", testInsertMultipleObjects),
        ("testInsertSingleObject", testInsertSingleObject),
        ("testInsertWithMaxDuplicateKeyBehavior", testInsertWithMaxDuplicateKeyBehavior),
    ]
}

#if !os(macOS)
public func __allTests() -> [XCTestCaseEntry] {
    return [
        testCase(MySqlQueryTests.__allTests),
    ]
}
#endif
