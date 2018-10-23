import XCTest

#if !os(macOS) && !os(iOS)
/// Run all tests in DataKit
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(DataASCIIStringTests.allTests),
        testCase(DataHexStringTests.allTests),
        testCase(DataUTF8StringTests.allTests)
    ]
}
#endif
