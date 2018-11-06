//
// Created by Arjan Duijzer on 10/06/2018.
//

@testable import DataKit
import Nimble
import XCTest

final class DataExtUTF8StringTests: XCTestCase {

    func testUTF8String() {
        let testString = "Héllø, this îs ån ÜTF8 ßtrìnƒ"
        let data = testString.data(using: .utf8)
        expect(data?.utf8string).to(equal(testString))
    }

    func testIncompatibleData() {
        let testString = "Héllø, this îs ån ÜTF8 ßtrìnƒ"
        let data = testString.data(using: .unicode)
        expect(data?.utf8string).to(beNil())
    }

    static var allTests = [
        ("testUTF8String", testUTF8String),
        ("testIncompatibleData", testIncompatibleData)
    ]
}
