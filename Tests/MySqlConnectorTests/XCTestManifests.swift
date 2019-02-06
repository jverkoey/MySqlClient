import XCTest

#if !os(macOS)
public func __allTests() -> [XCTestCaseEntry] {
    return [
        testCase(MySqlConnectorTests.__allTests),
    ]
}
#endif
