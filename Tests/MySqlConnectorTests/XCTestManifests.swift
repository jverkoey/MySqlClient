import XCTest

extension MySqlConnectorTests {
    static let __allTests = [
        ("testExample", testExample),
    ]
}

#if !os(macOS)
public func __allTests() -> [XCTestCaseEntry] {
    return [
        testCase(MySqlConnectorTests.__allTests),
    ]
}
#endif
