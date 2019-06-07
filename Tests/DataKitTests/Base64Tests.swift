//
// Created by Arjan Duijzer on 09/11/2018.
//

@testable import DataKit
import Foundation
import Nimble
import XCTest

//swiftlint:disable:next type_body_length
final class Base64Tests: XCTestCase {

    // Get static Resource bundle path
    static let resourcesPath: URL = {
        return URL(fileURLWithPath: #file)
                .deletingLastPathComponent()
                .appendingPathComponent("Resources")
    }()

    static var plainLoremIpsum = Data()

    override class func setUp() {
        super.setUp()

        //swiftlint:disable:next force_try
        plainLoremIpsum = try! Data(contentsOf: resourcesPath.appendingPathComponent("PlainLoremIpsum.txt"))
    }

    func resource(file path: String) -> URL {
        return type(of: self).resourcesPath.appendingPathComponent(path)
    }

    /// Mark: Base64 URL Safe decoding

    func testURLSafeDecoding_image() {
        let base64data = try! Data(contentsOf: resource(file: "asciifull.b64url")) //swiftlint:disable:this force_try
        let expected = try! Data(contentsOf: resource(file: "asciifull.gif")) //swiftlint:disable:this force_try

        expect {
            try Base64.decode(data: base64data)
        } == expected
    }

    func testURLSafeDecoding_LoremIpsum() {
        let file = resource(file: "PlainLoremIpsum.b64url")
        let data = try! Data(contentsOf: file) //swiftlint:disable:this force_try

        expect {
            try Base64.decode(data: data)
        } == type(of: self).plainLoremIpsum

        expect {
            try Base64.decode(data: data, mode: .ignoreWhiteSpaceAndNewline)
        } == type(of: self).plainLoremIpsum

        expect {
            try Base64.decode(data: data, mode: .ignoreInvalidCharacters)
        } == type(of: self).plainLoremIpsum
    }

    /// Mark: Base64 URL Safe encoding

    func testURLSafeEncoding() {
        let plain = "abcdefghijklmnopqrstuvwxyz0123456789\n".cStringByteBuffer
        let expected = "YWJjZGVmZ2hpamtsbW5vcHFyc3R1dnd4eXowMTIzNDU2Nzg5Cg==".cStringByteBuffer
        let encoded = Base64.urlSafe.encode(data: plain)

        expect(encoded) == expected
    }

    func testURLSafeEncoding_padding() {
        let plain = type(of: self).plainLoremIpsum
        //swiftlint:disable:next force_try
        let expected = try! Data(contentsOf: resource(file: "PlainLoremIpsum_padded.b64url"))

        expect(Base64.urlSafe.encode(data: plain, with: .padding)) == expected
    }

    /// Mark: Base64 standard decoding

    func testBase64Decoding() {
        let base64 = "YWJjZGVmZ2hpamtsbW5vcHFyc3R1dnd4eXowMTIzNDU2Nzg5Cg=="
        let plain = "abcdefghijklmnopqrstuvwxyz0123456789\n".cStringByteBuffer

        expect {
            try Base64.decode(string: base64)
        } == plain
    }

    func testBase64DecodingEmpty() {
        let base64 = Data()

        expect {
            try Base64.decode(data: base64)
        } == Data()
    }

    func testBase64Decoding_image() {
        let base64data = try! Data(contentsOf: resource(file: "asciifull.b64")) //swiftlint:disable:this force_try
        let expected = try! Data(contentsOf: resource(file: "asciifull.gif")) //swiftlint:disable:this force_try

        expect {
            try Base64.decode(data: base64data)
        } == expected
    }

    func testBase64Decoding_CR_LF() {
        let file = resource(file: "PlainLoremIpsum_CR_LF_76.b64")
        let data = try! Data(contentsOf: file) //swiftlint:disable:this force_try

        expect {
            try Base64.decode(data: data)
        }.to(throwError(Base64.Error.invalidBase64String))

        expect {
            try Base64.decode(data: data, mode: .ignoreWhiteSpaceAndNewline)
        } == type(of: self).plainLoremIpsum

        expect {
            try Base64.decode(data: data, mode: .ignoreInvalidCharacters)
        } == type(of: self).plainLoremIpsum
    }

    func testBase64Decoding_LF() {
        let file = resource(file: "PlainLoremIpsum_60.b64")
        let data = try! Data(contentsOf: file) //swiftlint:disable:this force_try

        expect {
            try Base64.decode(data: data)
        }.to(throwError(Base64.Error.invalidBase64String))

        expect {
            try Base64.decode(data: data, mode: .ignoreWhiteSpaceAndNewline)
        } == type(of: self).plainLoremIpsum

        expect {
            try Base64.decode(data: data, mode: .ignoreInvalidCharacters)
        } == type(of: self).plainLoremIpsum
    }

    func testBase64Decoding_LoremIpsum() {
        let file = resource(file: "PlainLoremIpsum.b64")
        let data = try! Data(contentsOf: file) //swiftlint:disable:this force_try

        expect {
            try Base64.decode(data: data)
        } == type(of: self).plainLoremIpsum

        expect {
            try Base64.decode(data: data, mode: .ignoreWhiteSpaceAndNewline)
        } == type(of: self).plainLoremIpsum

        expect {
            try Base64.decode(data: data, mode: .ignoreInvalidCharacters)
        } == type(of: self).plainLoremIpsum
    }

    func testBase64Decoding_LoremIpsum_no_padding() {
        let file = resource(file: "PlainLoremIpsum_76_no_padding.b64")
        let data = try! Data(contentsOf: file) //swiftlint:disable:this force_try

        expect {
            try Base64.decode(data: data)
        }.to(throwError(Base64.Error.invalidBase64String))

        expect {
            try Base64.decode(data: data, mode: .ignoreWhiteSpaceAndNewline)
        } == type(of: self).plainLoremIpsum

        expect {
            try Base64.decode(data: data, mode: .ignoreInvalidCharacters)
        } == type(of: self).plainLoremIpsum
    }

    func testBase64Decoding_illegal_characters() {
        let base64Illegal = "ñYWJjZGVmZ2%hpam.tsbW5vcHFyc3R1\ndnd4eXowMTIzüNDU2Nzg5Cg==".cStringByteBuffer

        expect {
            try Base64.decode(data: base64Illegal, mode: .failOnInvalidCharacters)
        }.to(throwError(Base64.Error.invalidBase64String))

        expect {
            try Base64.decode(data: base64Illegal, mode: .ignoreWhiteSpaceAndNewline)
        }.to(throwError(Base64.Error.invalidBase64String))

        let plain = "abcdefghijklmnopqrstuvwxyz0123456789\n".cStringByteBuffer
        expect {
            try Base64.decode(data: base64Illegal, mode: .ignoreInvalidCharacters)
        } == plain
    }

    func testBase64Decoding_illegal_characters_with_early_padding() {
        let base64Illegal = "ñYWJjZGVmZ2%hpam.tsbW5vcHFy=c3R1\ndnd4eXowMTIzüNDU2Nzg5Cg==".cStringByteBuffer

        expect {
            try Base64.decode(data: base64Illegal, mode: .failOnInvalidCharacters)
        }.to(throwError(Base64.Error.invalidBase64String))

        expect {
            try Base64.decode(data: base64Illegal, mode: .ignoreWhiteSpaceAndNewline)
        }.to(throwError(Base64.Error.invalidBase64String))

        let plain = "abcdefghijklmnopqr".cStringByteBuffer
        expect {
            try Base64.decode(data: base64Illegal, mode: .ignoreInvalidCharacters)
        } == plain
    }

    func testBase64DecodingLength() {
        let base64 = "YWJjZGVmZ2hpamtsbW5vcHFyc3R1dnd4eXowMTIzNDU2Nzg5Cg==".cStringByteBuffer

        expect(Base64.Mode.failOnInvalidCharacters.decodedLength(base64)) == 37
        expect(Base64.Mode.ignoreWhiteSpaceAndNewline.decodedLength(base64)) == 37
        expect(Base64.Mode.ignoreInvalidCharacters.decodedLength(base64)) == 37
    }

    func testBase64DecodingLengthWithLineFeeds() {
        let base64LFWhiteSpace = "YWJjZGVmZ2hp amtsbW5vcHFyc3R1\ndnd4eXowMTI\tzNDU2Nzg5Cg==\n\n".cStringByteBuffer

        expect(Base64.Mode.failOnInvalidCharacters.decodedLength(base64LFWhiteSpace)) == -1
        expect(Base64.Mode.ignoreWhiteSpaceAndNewline.decodedLength(base64LFWhiteSpace)) == 37
        expect(Base64.Mode.ignoreInvalidCharacters.decodedLength(base64LFWhiteSpace)) == 37
    }

    func testBase64DecodingLengthWithIllegalCharacters() {
        let base64Illegal = "ñYWJjZGVmZ2%hpam.tsbW5vcHFyc3R1\ndnd4eXowMTIzüNDU2Nzg5Cg==".cStringByteBuffer

        expect(Base64.Mode.failOnInvalidCharacters.decodedLength(base64Illegal)) == -1
        expect(Base64.Mode.ignoreWhiteSpaceAndNewline.decodedLength(base64Illegal)) == -1
        expect(Base64.Mode.ignoreInvalidCharacters.decodedLength(base64Illegal)) == 37
    }

    func testBase64DecodingLengthWithIllegalCharactersAndEarlyPadding() {
        let base64Illegal = "YWJjZGVmZ2hpamtsbW5=vcHFyc3R1\ndnd4eXowMTIzüN2Nzg5Cg==".cStringByteBuffer

        expect(Base64.Mode.failOnInvalidCharacters.decodedLength(base64Illegal)) == 13
        expect(Base64.Mode.ignoreWhiteSpaceAndNewline.decodedLength(base64Illegal)) == 13
        expect(Base64.Mode.ignoreInvalidCharacters.decodedLength(base64Illegal)) == 13
    }

    func testBase64DecodingLengthNoPadding() {
        let base64noPadding = "YWJjZGVmZ2hpamtsbW5vcHFyc3R1dnd4eXowMTIzNDU2Nzg5Cg".cStringByteBuffer

        expect(Base64.Mode.failOnInvalidCharacters.decodedLength(base64noPadding)) == 37
        expect(Base64.Mode.ignoreWhiteSpaceAndNewline.decodedLength(base64noPadding)) == 37
        expect(Base64.Mode.ignoreInvalidCharacters.decodedLength(base64noPadding)) == 37
    }

    /// Mark: Base64 standard encoding

    func testBase64Encoding() {
        let plain = "abcdefghijklmnopqrstuvwxyz0123456789\n".cStringByteBuffer
        let expected = "YWJjZGVmZ2hpamtsbW5vcHFyc3R1dnd4eXowMTIzNDU2Nzg5Cg==".cStringByteBuffer

        let encoded = Base64.standard.encode(data: plain)
        expect(encoded) == expected
    }

    func testBase64Encoding_LF() {
        let plain = type(of: self).plainLoremIpsum
        let expected = try! Data(contentsOf: resource(file: "PlainLoremIpsum_76.b64"))//swiftlint:disable:this force_try
        let encoded = Base64.standard.encode(data: plain, with: .padding, lineFeeds: 76)

        expect(encoded) == expected
    }

    func testBase64Encoding_LF_no_padding() {
        let plain = type(of: self).plainLoremIpsum
        //swiftlint:disable:next force_try
        let expected = try! Data(contentsOf: resource(file: "PlainLoremIpsum_76_no_padding.b64"))

        expect(Base64.standard.encode(data: plain, with: .none, lineFeeds: 76)) == expected
    }

    /// Mark: padding

    func testBase64PaddingLength_empty() {
        let padding = Base64.Padding.padding
        let data = [UInt8](repeating: 0x0, count: 0).data
        expect(padding.encodedLength(data)) == 0
    }

    func testBase64PaddingLength_1byte() {
        let padding = Base64.Padding.padding
        let data = [UInt8](repeating: 0x0, count: 1).data
        expect(padding.encodedLength(data)) == 4
    }

    func testBase64PaddingLength_2bytes() {
        let padding = Base64.Padding.padding
        let data = [UInt8](repeating: 0x0, count: 2).data
        expect(padding.encodedLength(data)) == 4
    }

    func testBase64PaddingLength_3bytes() {
        let padding = Base64.Padding.padding
        let data = [UInt8](repeating: 0x0, count: 3).data
        expect(padding.encodedLength(data)) == 4
    }

    func testBase64PaddingLength_4bytes() {
        let padding = Base64.Padding.padding
        let data = [UInt8](repeating: 0x0, count: 4).data
        expect(padding.encodedLength(data)) == 8
    }

    func testBase64PaddingLength_64bytes() {
        let padding = Base64.Padding.padding
        let data = [UInt8](repeating: 0x0, count: 64).data
        expect(padding.encodedLength(data)) == 88
    }

    /// Mark: no-padding
    func testBase64NoPaddingLength_empty() {
        let padding = Base64.Padding.none
        let data = [UInt8](repeating: 0x0, count: 0).data
        expect(padding.encodedLength(data)) == 0
    }

    func testBase64NoPaddingLength_1byte() {
        let padding = Base64.Padding.none
        let data = [UInt8](repeating: 0x0, count: 1).data
        expect(padding.encodedLength(data)) == 2
    }

    func testBase64NoPaddingLength_2bytes() {
        let padding = Base64.Padding.none
        let data = [UInt8](repeating: 0x0, count: 2).data
        expect(padding.encodedLength(data)) == 3
    }

    func testBase64NoPaddingLength_3bytes() {
        let padding = Base64.Padding.none
        let data = [UInt8](repeating: 0x0, count: 3).data
        expect(padding.encodedLength(data)) == 4
    }

    func testBase64NoPaddingLength_4bytes() {
        let padding = Base64.Padding.none
        let data = [UInt8](repeating: 0x0, count: 4).data
        expect(padding.encodedLength(data)) == 6
    }

    func testBase64NoPaddingLength_5bytes() {
        let padding = Base64.Padding.none
        let data = [UInt8](repeating: 0x0, count: 5).data
        expect(padding.encodedLength(data)) == 7
    }

    func testBase64NoPaddingLength_6bytes() {
        let padding = Base64.Padding.none
        let data = [UInt8](repeating: 0x0, count: 6).data
        expect(padding.encodedLength(data)) == 8
    }

    func testBase64NoPaddingLength_64bytes() {
        let padding = Base64.Padding.none
        let data = [UInt8](repeating: 0x0, count: 64).data
        expect(padding.encodedLength(data)) == 86
    }

    static let allTests = [
        ("testURLSafeDecoding_image", testURLSafeDecoding_image),
        ("testURLSafeDecoding_LoremIpsum", testURLSafeDecoding_LoremIpsum),
        ("testURLSafeEncoding", testURLSafeEncoding),
        ("testURLSafeEncoding_padding", testURLSafeEncoding_padding),
        ("testBase64Decoding", testBase64Decoding),
        ("testBase64DecodingEmpty", testBase64DecodingEmpty),
        ("testBase64Decoding_image", testBase64Decoding_image),
        ("testBase64Decoding_CR_LF", testBase64Decoding_CR_LF),
        ("testBase64Decoding_LF", testBase64Decoding_LF),
        ("testBase64Decoding_LoremIpsum", testBase64Decoding_LoremIpsum),
        ("testBase64Decoding_illegal_characters", testBase64Decoding_illegal_characters),
        ("testBase64Decoding_illegal_characters_with_early_padding",
                testBase64Decoding_illegal_characters_with_early_padding),
        ("testBase64DecodingLength", testBase64DecodingLength),
        ("testBase64DecodingLengthWithLineFeeds", testBase64DecodingLengthWithLineFeeds),
        ("testBase64DecodingLengthWithIllegalCharacters", testBase64DecodingLengthWithIllegalCharacters),
        ("testBase64DecodingLengthWithIllegalCharactersAndEarlyPadding",
                testBase64DecodingLengthWithIllegalCharactersAndEarlyPadding),
        ("testBase64DecodingLengthNoPadding", testBase64DecodingLengthNoPadding),
        ("testBase64Encoding", testBase64Encoding),
        ("testBase64Encoding_LF", testBase64Encoding_LF),
        ("testBase64Encoding_LF_no_padding", testBase64Encoding_LF_no_padding),
        ("testBase64PaddingLength_empty", testBase64PaddingLength_empty),
        ("testBase64PaddingLength_1byte", testBase64PaddingLength_1byte),
        ("testBase64PaddingLength_2bytes", testBase64PaddingLength_2bytes),
        ("testBase64PaddingLength_3bytes", testBase64PaddingLength_3bytes),
        ("testBase64PaddingLength_4bytes", testBase64PaddingLength_4bytes),
        ("testBase64PaddingLength_64bytes", testBase64PaddingLength_64bytes),
        ("testBase64NoPaddingLength_empty", testBase64NoPaddingLength_empty),
        ("testBase64NoPaddingLength_1byte", testBase64NoPaddingLength_1byte),
        ("testBase64NoPaddingLength_2bytes", testBase64NoPaddingLength_2bytes),
        ("testBase64NoPaddingLength_3bytes", testBase64NoPaddingLength_3bytes),
        ("testBase64NoPaddingLength_4bytes", testBase64NoPaddingLength_4bytes),
        ("testBase64NoPaddingLength_5bytes", testBase64NoPaddingLength_5bytes),
        ("testBase64NoPaddingLength_6bytes", testBase64NoPaddingLength_6bytes),
        ("testBase64NoPaddingLength_64bytes", testBase64NoPaddingLength_64bytes)
    ]
}
