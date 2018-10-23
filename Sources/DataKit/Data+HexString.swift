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
        guard hex.count % 2 == 0 else {
            throw HexStringParsingError.invalidLength(hex.count)
        }

        // Allocate the byte buffer needed
        let dataPtr = UnsafeMutablePointer<UInt8>.allocate(capacity: hex.count / 2)
        let charPtr = UnsafeMutablePointer<UInt8>.allocate(capacity: 2)

        defer {
            // Deallocate the tmp charPtr
            charPtr.deallocate()
        }

        // Loop through the Hex String to fill the dataPtr buffer
        for (index, character) in hex.utf8.enumerated() {
            // Even index means we need to 'cache' the first part of the byte literal
            if index % 2 == 0 {
                charPtr[0] = character
            } else {
                charPtr[1] = character
                let byteLiteral = String(cString: charPtr)
                // Parse the String to UInt8
                guard let byte = UInt8(byteLiteral, radix: 16) else {
                    defer {
                        // Deallocate dataPtr in case of illegal character - since the dataPtr is unmanaged
                        dataPtr.deallocate()
                    }
                    throw HexStringParsingError.illegalCharacters(pattern: hex)
                }
                dataPtr[index / 2] = byte
            }
        }

        // Manage the unsafe dataPtr
        self.init(bytesNoCopy: dataPtr, count: hex.count / 2, deallocator: .free)
    }
}

/// HexString parsing error cases
public enum HexStringParsingError: Error {
    /// characters do not conform to regex pattern: `[a-z][A-Z][0-9]`.
    case illegalCharacters(pattern: String)
    /// When the String length is *odd*
    case invalidLength(_: Int)
}
