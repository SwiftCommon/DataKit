//
// Created by Arjan Duijzer on 11/12/2018.
//

@testable import DataKit
import Foundation
import XCTest

final class Base64Benchmark: XCTestCase {

    // Get static Resource bundle path
    static let resourcesPath: URL = {
        return URL(fileURLWithPath: #file)
                .deletingLastPathComponent()
                .deletingLastPathComponent()
                .appendingPathComponent("DataKitTests/Resources")
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

    /// Mark: Benchmark

    func testNSDataBase64Decoding() {
        print("Start decoding benchmark")
        let file = resource(file: "PlainLoremIpsum_60.b64")
        let data = try! Data(contentsOf: file) //swiftlint:disable:this force_try

        let startTime: CFTimeInterval = CACurrentMediaTime()
        let time = dispatch_benchmark(1000) {
            autoreleasepool {
                _ = Data(base64Encoded: data, options: .ignoreUnknownCharacters)
            }
        }
        let endTime: CFTimeInterval = CACurrentMediaTime()
        print("Total time (foundation): \(String(describing: (endTime - startTime)))")

        let startTime1: CFTimeInterval = CACurrentMediaTime()
        let time1 = dispatch_benchmark(1000) {
            autoreleasepool {
                _ = try? Base64.decode(data: data, mode: .ignoreWhiteSpaceAndNewline)
            }
        }
        let endTime1: CFTimeInterval = CACurrentMediaTime()

        print("Total time (swiftcommon): \(String(describing: (endTime1 - startTime1)))")
        print("Benchmark time foundation: \(String(describing: time)), swiftcommon: \(String(describing: time1))")
    }

    func testNSDataBase64Encoding() {
        print("Start encoding benchmark")
        let data = type(of: self).plainLoremIpsum

        let startTime: CFTimeInterval = CACurrentMediaTime()
        let time = dispatch_benchmark(1000) {
            autoreleasepool {
                _ = data.base64EncodedData()
            }
        }
        let endTime: CFTimeInterval = CACurrentMediaTime()
        print("Total time (foundation): \(String(describing: (endTime - startTime)))")

        let startTime1: CFTimeInterval = CACurrentMediaTime()
        let time1 = dispatch_benchmark(1000) {
            autoreleasepool {
                _ = Base64.base64.encode(data: data)
            }
        }
        let endTime1: CFTimeInterval = CACurrentMediaTime()

        print("Total time (swiftcommon): \(String(describing: (endTime1 - startTime1)))")
        print("Benchmark time foundation: \(String(describing: time)), swiftcommon: \(String(describing: time1))")
    }
}
