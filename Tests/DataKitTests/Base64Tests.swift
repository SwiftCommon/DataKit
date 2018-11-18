//
// Created by Arjan Duijzer on 09/11/2018.
//

@testable import DataKit
import Foundation
import Nimble
import XCTest

final class Base64Tests: XCTestCase {

    /// Mark: Base64 URL Safe decoding
    //TODO

    /// Mark: Base64 URL Safe encoding
    //TODO

    /// Mark: Base64 standard decoding
    //TODO

    /// Mark: Base64 standard encoding

    func testBase64Encoding() {
        let plain = "abcdefghijklmnopqrstuvwxyz0123456789\n".data(using: .utf8)!
        let expected = "YWJjZGVmZ2hpamtsbW5vcHFyc3R1dnd4eXowMTIzNDU2Nzg5Cg==".data(using: .utf8)!
        let encoded = Base64.base64.encode(data: plain)

        expect(encoded).to(equal(expected))
    }

    /// Mark: padding

    func testBase64PaddingLength_empty() {
        let padding = Base64Padding.padding
        let data = [UInt8](repeating: 0x0, count: 0).data
        expect(padding.encodedLength(data)).to(equal(0))
    }

    func testBase64PaddingLength_1byte() {
        let padding = Base64Padding.padding
        let data = [UInt8](repeating: 0x0, count: 1).data
        expect(padding.encodedLength(data)).to(equal(4))
    }

    func testBase64PaddingLength_2bytes() {
        let padding = Base64Padding.padding
        let data = [UInt8](repeating: 0x0, count: 2).data
        expect(padding.encodedLength(data)).to(equal(4))
    }

    func testBase64PaddingLength_3bytes() {
        let padding = Base64Padding.padding
        let data = [UInt8](repeating: 0x0, count: 3).data
        expect(padding.encodedLength(data)).to(equal(4))
    }

    func testBase64PaddingLength_4bytes() {
        let padding = Base64Padding.padding
        let data = [UInt8](repeating: 0x0, count: 4).data
        expect(padding.encodedLength(data)).to(equal(8))
    }

    func testBase64PaddingLength_64bytes() {
        let padding = Base64Padding.padding
        let data = [UInt8](repeating: 0x0, count: 64).data
        expect(padding.encodedLength(data)).to(equal(88))
    }

    /// Mark: no-padding
    func testBase64NoPaddingLength_empty() {
        let padding = Base64Padding.noPadding
        let data = [UInt8](repeating: 0x0, count: 0).data
        expect(padding.encodedLength(data)).to(equal(0))
    }

    func testBase64NoPaddingLength_1byte() {
        let padding = Base64Padding.noPadding
        let data = [UInt8](repeating: 0x0, count: 1).data
        expect(padding.encodedLength(data)).to(equal(2))
    }

    func testBase64NoPaddingLength_2bytes() {
        let padding = Base64Padding.noPadding
        let data = [UInt8](repeating: 0x0, count: 2).data
        expect(padding.encodedLength(data)).to(equal(3))
    }

    func testBase64NoPaddingLength_3bytes() {
        let padding = Base64Padding.noPadding
        let data = [UInt8](repeating: 0x0, count: 3).data
        expect(padding.encodedLength(data)).to(equal(4))
    }

    func testBase64NoPaddingLength_4bytes() {
        let padding = Base64Padding.noPadding
        let data = [UInt8](repeating: 0x0, count: 4).data
        expect(padding.encodedLength(data)).to(equal(6))
    }

    func testBase64NoPaddingLength_5bytes() {
        let padding = Base64Padding.noPadding
        let data = [UInt8](repeating: 0x0, count: 5).data
        expect(padding.encodedLength(data)).to(equal(7))
    }

    func testBase64NoPaddingLength_6bytes() {
        let padding = Base64Padding.noPadding
        let data = [UInt8](repeating: 0x0, count: 6).data
        expect(padding.encodedLength(data)).to(equal(8))
    }

    func testBase64NoPaddingLength_64bytes() {
        let padding = Base64Padding.noPadding
        let data = [UInt8](repeating: 0x0, count: 64).data
        expect(padding.encodedLength(data)).to(equal(86))
    }

    static let allTests = [
        ("testBase64Encoding", testBase64Encoding)
    ]
}
