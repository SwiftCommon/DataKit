//
// Created by Arjan Duijzer on 10/06/2018.
//

@testable import DataKit
import Nimble
import XCTest

final class DataExtHexStringTests: XCTestCase {

    func testHexString_no_separator() {
        let data = Data(bytes: [0, 1, 80, 127, 255])
        let expectedHexString = "0001507FFF"
        expect(data.hexString()).to(equal(expectedHexString))
    }

    func testHexString_with_separator() {
        let data = Data(bytes: [0, 1, 80, 127, 255])
        let expectedHexString = "00 01 50 7F FF"
        expect(data.hexString(separator: " ")).to(equal(expectedHexString))
    }

    func testHexStringToData() {
        let hexString = "0003f6A0ff"
        let expectedBytes: [UInt8] = [0, 3, 246, 160, 255]
        expect {
            try Data(hex: hexString)
        }.to(equal(expectedBytes.data))
    }

    func testHexStringToData_invalid_length() {
        let hexString = "0003f6a0ff0"
        expect {
            try Data(hex: hexString)
        }.to(throwError(HexStringParsingError.invalidLength(hexString.count)))
    }

    func testNotSoHexStringToData_illegalCharacters() {
        let hexString = "nothex"
        expect {
            try Data(hex: hexString)
        }.to(throwError(HexStringParsingError.illegalCharacters(pattern: hexString)))
    }

    static let allTests = [
        ("testHexString_no_separator", testHexString_no_separator),
        ("testHexString_with_separator", testHexString_with_separator),
        ("testHexStringToData", testHexStringToData),
        ("testHexStringToData_invalid_length", testHexStringToData_invalid_length),
        ("testNotSoHexStringToData_illegalCharacters", testNotSoHexStringToData_illegalCharacters)
    ]
}
