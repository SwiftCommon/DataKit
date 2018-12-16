//
// Created by Arjan Duijzer on 11/12/2018.
//

import DataKit
import Foundation

func gettime() -> CFTimeInterval {
    return Date.timeIntervalSinceReferenceDate
}

// Get static Resource bundle path
let resourcesPath: URL = {
    return URL(fileURLWithPath: #file)
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .appendingPathComponent("Tests/DataKitTests/Resources")
}()

//swiftlint:disable:next force_try
let plainLoremIpsum = try! Data(contentsOf: resourcesPath.appendingPathComponent("PlainLoremIpsum.txt"))

func resource(file path: String) -> URL {
    return resourcesPath.appendingPathComponent(path)
}

/// Mark: Benchmark

func testNSDataBase64Decoding() {
    print("Start decoding benchmark")
    let file = resource(file: "PlainLoremIpsum_60.b64")
    let data = try! Data(contentsOf: file) //swiftlint:disable:this force_try

    let startTime: CFTimeInterval = gettime()
    let time = dispatch_benchmark(1000) {
        autoreleasepool {
            _ = Data(base64Encoded: data, options: .ignoreUnknownCharacters)
        }
    }
    let endTime: CFTimeInterval = gettime()
    print("Total time (foundation): \(String(describing: (endTime - startTime)))")

    let startTime1: CFTimeInterval = gettime()
    let time1 = dispatch_benchmark(1000) {
        autoreleasepool {
            _ = try? Base64.decode(data: data, mode: .ignoreWhiteSpaceAndNewline)
        }
    }
    let endTime1: CFTimeInterval = gettime()

    print("Total time (swiftcommon): \(String(describing: (endTime1 - startTime1)))")
    print("Benchmark time foundation: \(String(describing: time)), swiftcommon: \(String(describing: time1))")
}

func testNSDataBase64Encoding() {
    print("Start encoding benchmark")
    let data = plainLoremIpsum

    let startTime: CFTimeInterval = gettime()
    let time = dispatch_benchmark(1000) {
        autoreleasepool {
            _ = data.base64EncodedData()
        }
    }
    let endTime: CFTimeInterval = gettime()
    print("Total time (foundation): \(String(describing: (endTime - startTime)))")

    let startTime1: CFTimeInterval = gettime()
    let time1 = dispatch_benchmark(1000) {
        autoreleasepool {
            _ = Base64.base64.encode(data: data)
        }
    }
    let endTime1: CFTimeInterval = gettime()

    print("Total time (swiftcommon): \(String(describing: (endTime1 - startTime1)))")
    print("Benchmark time foundation: \(String(describing: time)), swiftcommon: \(String(describing: time1))")
}

testNSDataBase64Encoding()
testNSDataBase64Decoding()
