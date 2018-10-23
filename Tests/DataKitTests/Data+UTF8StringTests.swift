//
// Created by Arjan Duijzer on 10/06/2018.
//

import XCTest
@testable import DataKit

final class DataUTF8StringTests: XCTestCase {

    func testUTF8String() {
        let testString = "Héllø, this îs ån ÜTF8 ßtrìnƒ"
        let data = testString.data(using: .utf8)
        XCTAssertEqual(testString, data?.utf8string)
    }

    func testIncompatibleData() {
        let testString = "Héllø, this îs ån ÜTF8 ßtrìnƒ"
        let data = testString.data(using: .unicode)
        XCTAssertNotEqual(testString, data?.utf8string)
    }

    static var allTests = [
        ("testUTF8String", testUTF8String),
        ("testIncompatibleData", testIncompatibleData)
    ]
}
