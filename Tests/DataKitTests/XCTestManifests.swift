import XCTest

#if !os(macOS) && !os(iOS)
/// Run all tests in DataKit
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(DataExtASCIIStringTests.allTests),
        testCase(DataExtHexStringTests.allTests),
        testCase(DataExtUTF8StringTests.allTests)
    ]
}
#endif
