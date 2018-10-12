import XCTest

#if !os(macOS) && !os(iOS)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(Data_ASCIIStringTests.allTests),
        testCase(Data_HexStringTests.allTests),
        testCase(Data_UTF8StringTests.allTests),
    ]
}
#endif