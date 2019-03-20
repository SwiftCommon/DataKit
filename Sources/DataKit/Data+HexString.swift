//
// Created by Arjan Duijzer on 10/06/2018.
//

import Foundation

extension Data {
    /**
        Transform data to Hex String

        *Example*:
        ```
        let data = Data(bytes: [0, 1, 80, 127, 255])
        print(data.hexString()) >> 0001507FFF
        ```

        - Returns: Data block in Hex/Octet String
    */
    public func hexString(separator: String = "") -> String {
        return map {
            String(format: "%02hhX", $0)
        }.joined(separator: separator)
    }

    /**
        Initialize Data from a Hex String.

        - Parameter hex: The Hex String to parse. Should match regex pattern: `[a-z][A-Z][0-9]`.

        *Example*:
        ```
        let data = try? Data(hex: "00ffAAC3")
        ```

        - Throws: `HexStringParsingError` when the length is invalid or the hex string contains illegal characters.
     */
    public init(hex: String) throws {
        // Check invalid length
        let length = hex.count
        guard length % 2 == 0 else {
            throw HexStringParsingError.invalidLength(length)
        }

        // Allocate the byte buffer needed
        let bufferSize = length / 2
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: bufferSize)

        var error: Error?
        guard Data.parse(hex: hex, to: buffer, maxSize: bufferSize, error: &error) else {
            // Deallocate buffer in case of failure
            buffer.deallocate()
            throw error ?? HexStringParsingError.unknownError
        }

        // Manage the unsafe buffer
        self.init(bytesNoCopy: buffer, count: bufferSize, deallocator: .free)
    }

    private static func parse(hex: String,
                              to buffer: UnsafeMutablePointer<UInt8>,
                              maxSize: Int,
                              error: inout Error?) -> Bool {
        return hex.withCString { cString -> Bool in
            let length = strlen(cString)

            guard length / 2 == maxSize else {
                error = HexStringParsingError.invalidLength(maxSize)
                return false
            }

            // Allocate a buffer for CChars that make up one Byte
            let charBuffer = UnsafeMutablePointer<CChar>.allocate(capacity: 3)
            // make sure we're null terminated
            charBuffer.initialize(repeating: 0, count: 3)
            defer {
                charBuffer.deallocate()
            }
            // Loop through the Hex String to fill the ptr buffer
            for idx in stride(from: 0, to: length, by: 2) {
                // assign the next two characters to the buffer
                charBuffer.assign(from: cString.advanced(by: idx), count: 2)
                let byteLiteral = String(cString: charBuffer)
                // Parse the String to UInt8
                guard let byte = UInt8(byteLiteral, radix: 16) else {
                    error = HexStringParsingError.illegalCharacters(pattern: hex, index: idx, literal: byteLiteral)
                    return false
                }
                buffer[idx / 2] = byte
            }
            return true
        }
    }
}

/// HexString parsing error cases
public enum HexStringParsingError: Error, Equatable {
    /// characters do not conform to regex pattern: `[a-z][A-Z][0-9]`.
    case illegalCharacters(pattern: String, index: Int, literal: String)
    /// When the String length is *odd*
    case invalidLength(_: Int)
    /// Unknown error
    case unknownError
}
