//
// swiftlint:disable:previous file_name
// Created by Arjan Duijzer on 10/06/2018.
//

@testable import DataKit
import XCTest

final class DataHexStringTests: XCTestCase {

    func testHexString_no_separator() {
        let data = Data(bytes: [0, 1, 80, 127, 255])
        let expectedHexString = "0001507FFF"
        XCTAssertEqual(data.hexString(), expectedHexString)
    }

    func testHexString_with_separator() {
        let data = Data(bytes: [0, 1, 80, 127, 255])
        let expectedHexString = "00 01 50 7F FF"
        XCTAssertEqual(data.hexString(separator: " "), expectedHexString)
    }

    func testHexStringToData() {
        let hexString = "0003f6A0ff"
        do {
            let hex = try Data(hex: hexString)

            let expectedBytes: [UInt8] = [0, 3, 246, 160, 255]
            XCTAssertEqual(hex, expectedBytes.data)
        } catch {
            XCTFail("Could not parse hex string")
        }
    }

    func testHexStringToData_invalid_length() {
        let hexString = "0003f6a0ff0"
        do {
            let data = try Data(hex: hexString)
            XCTAssertNil(data)
        } catch let error {
            if case HexStringParsingError.invalidLength(let length) = error {
                XCTAssertEqual(hexString.count, length)
            } else {
                XCTFail("invalidLength Exception expected, but was not thrown")
            }
        }
    }

    func testNotSoHexStringToData_illegalCharacters() {
        let hexString = "ghij"
        do {
            let data = try Data(hex: hexString)
            XCTAssertNil(data)
        } catch let error {
            if case HexStringParsingError.illegalCharacters(let error) = error {
                XCTAssertEqual(hexString, error)
            } else {
                XCTFail("illegalCharacters Exception expected, but was not thrown")
            }
        }
    }

    static var allTests = [
        ("testHexString_no_separator", testHexString_no_separator),
        ("testHexString_with_separator", testHexString_with_separator),
        ("testHexStringToData", testHexStringToData),
        ("testHexStringToData_invalid_length", testHexStringToData_invalid_length),
        ("testNotSoHexStringToData_illegalCharacters", testNotSoHexStringToData_illegalCharacters)
    ]
}
