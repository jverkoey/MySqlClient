import XCTest

extension Tests {
    static let __allTests = [
        ("testInitiallyPullsFromStart", testInitiallyPullsFromStart),
        ("testPullingMoreThanAvailableOnlyPullsWhatsAvailable", testPullingMoreThanAvailableOnlyPullsWhatsAvailable),
        ("testSuccessivePullsUseCursor", testSuccessivePullsUseCursor),
    ]
}

#if !os(macOS)
public func __allTests() -> [XCTestCaseEntry] {
    return [
        testCase(Tests.__allTests),
    ]
}
#endif
