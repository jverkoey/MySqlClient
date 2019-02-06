import XCTest

extension MySqlConnectorTests {
    static let __allTests = [
        ("testConnectToServer", testConnectToServer),
    ]
}

#if !os(macOS)
public func __allTests() -> [XCTestCaseEntry] {
    return [
        testCase(MySqlConnectorTests.__allTests),
    ]
}
#endif
