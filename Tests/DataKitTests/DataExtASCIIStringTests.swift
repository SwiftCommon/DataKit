//
// Created by Arjan Duijzer on 24/06/2018.
//

@testable import DataKit
import Nimble
import XCTest

final class DataExtASCIIStringTests: XCTestCase {

    func testIncompatibleData() {
        let testString = "Héllø, this îs ån ÜTF8 ßtrìnƒ"
        let data = testString.data(using: .utf8)
        expect(data?.asciiString).to(beNil())
    }

    func testASCIIData() {
        let data = Data(bytes: [97, 98, 99, 100])
        expect(data.asciiString).to(equal("abcd"))
    }

    static var allTests = [
        ("testASCIIData", testASCIIData),
        ("testIncompatibleData", testIncompatibleData)
    ]
}
