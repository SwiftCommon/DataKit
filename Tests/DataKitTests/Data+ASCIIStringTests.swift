//
// swiftlint:disable:previous file_name
// Created by Arjan Duijzer on 24/06/2018.
//

@testable import DataKit
import XCTest

final class DataASCIIStringTests: XCTestCase {

    func testIncompatibleData() {
        let testString = "Héllø, this îs ån ÜTF8 ßtrìnƒ"
        let data = testString.data(using: .utf8)
        XCTAssertNil(data?.asciiString)
    }

    func testASCIIData() {
        let data = Data(bytes: [97, 98, 99, 100])
        XCTAssertEqual("abcd", data.asciiString)
    }

    static var allTests = [
        ("testASCIIData", testASCIIData),
        ("testIncompatibleData", testIncompatibleData)
    ]
}
