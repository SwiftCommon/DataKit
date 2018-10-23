import XCTest

#if !os(macOS) && !os(iOS)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(DataASCIIStringTests.allTests),
        testCase(DataHexStringTests.allTests),
        testCase(DataUTF8StringTests.allTests)
    ]
}
#endif
