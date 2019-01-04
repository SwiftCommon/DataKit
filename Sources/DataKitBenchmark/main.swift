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

func resource(file path: String) -> URL {
    return resourcesPath.appendingPathComponent(path)
}

//swiftlint:disable:next force_try
let plainLoremIpsum = try! Data(contentsOf: resource(file: "PlainLoremIpsum.txt"))

/// Mark: Benchmark

func testNSDataBase64Decoding(count: Int = 1000) {
    print("Start decoding benchmark (\(count))")
    let file = resource(file: "PlainLoremIpsum_60.b64")
    let data = try! Data(contentsOf: file) //swiftlint:disable:this force_try

    let startTime: CFTimeInterval = gettime()
    let time = dispatch_benchmark(count) {
        _ = Data(base64Encoded: data, options: .ignoreUnknownCharacters)
    }
    let endTime: CFTimeInterval = gettime()
    print("Total time  (foundation): \(String(describing: (endTime - startTime)))")

    let startTime1: CFTimeInterval = gettime()
    let time1 = dispatch_benchmark(count) {
        _ = try? Base64.decode(data: data, mode: .ignoreWhiteSpaceAndNewline)
    }
    let endTime1: CFTimeInterval = gettime()

    print("Total time (swiftcommon): \(String(describing: (endTime1 - startTime1)))")
    print("Benchmark time\n\t-  foundation: \(String(describing: time))," +
            "\n\t- swiftcommon: \(String(describing: time1))")
}

func testNSDataBase64Encoding(count: Int = 1000) {
    print("Start encoding benchmark (\(count))")
    let data = plainLoremIpsum

    let startTime: CFTimeInterval = gettime()
    let time = dispatch_benchmark(count) {
        _ = data.base64EncodedData()
    }
    let endTime: CFTimeInterval = gettime()
    print("Total time  (foundation): \(String(describing: (endTime - startTime)))")

    let startTime1: CFTimeInterval = gettime()
    let time1 = dispatch_benchmark(count) {
        _ = Base64.base64.encode(data: data)
    }
    let endTime1: CFTimeInterval = gettime()

    print("Total time (swiftcommon): \(String(describing: (endTime1 - startTime1)))")
    print("Benchmark time \n\t-  " +
            "foundation: \(String(describing: time)), \n\t- swiftcommon: \(String(describing: time1))")
}

testNSDataBase64Encoding()
testNSDataBase64Decoding()
