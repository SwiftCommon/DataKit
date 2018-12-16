//
// Created by Arjan Duijzer on 09/11/2018.
//

import Foundation

/// Base64 encoder/decoder
public enum Base64 {
    /// Normal Base64 encoding alphabet as per RFC 4648,4
    case base64
    /// URL and Filename Safe alphabet as per RFC 4648,5
    case urlSafe

    var table: String {
        switch self {
        case .base64:
            return "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/="
        case .urlSafe:
            return "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_="
        }
    }

    /// ASCII table for decoding
    static var asciiTable: [UInt8] {
        return [
            64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64,
            64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64,
            64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 62, 64, 62, 64, 63,
            52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 64, 64, 64, 64, 64, 64,
            64, 00, 01, 02, 03, 04, 05, 06, 07, 08, 09, 10, 11, 12, 13, 14,
            15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 64, 64, 64, 64, 63,
            64, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40,
            41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 64, 64, 64, 64, 64,
            64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64,
            64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64,
            64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64,
            64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64,
            64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64,
            64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64,
            64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64,
            64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64
        ]
    }

    /// Decoding policy
    public enum Mode {
        /// Default: fail when encoded data/string contains invalid characters
        case failOnInvalidCharacters
        /// Accept newline, whitespace characters to appear between the Base64 encoded chars
        case ignoreWhiteSpaceAndNewline
        /// Just ignore all non-base64 chars
        case ignoreInvalidCharacters

        /**
            Calculate the number of bytes needed to Base64 decode the given data blob

            - Parameter data: Base64 encoded data
            - Returns: number of bytes needed for decoded data
         */
        public func decodedLength(_ data: Data) -> Int {
            var ctr = 0
            var byte: Int
            var char: UInt8

            let table = Base64.asciiTable
            // Loop through the data set and scan the chars for validity based on the current [decoding] mode
            for idx in 0..<data.count {
                byte = Int(data[idx])
                char = table[byte]
                if char == 0x40 {
                    // char is out of valid Base64 range
                    if !skip(invalid: data[idx]) {
                        // If we choose NOT to skip the char it better be a padding char
                        if data[idx] != 0x3d {
                            return -1
                        }
                        break
                    }
                } else {
                    ctr += 1
                }
            }

            return ctr > 0 ? (ctr / 4) * 3 + 1 : 0
        }

        /**
            Check whether we should skip an invalid char or escalate

            - Discussion: whether we should just ignore/skip the char based on the mode
            - Parameter char: the invalid cchar
            - Returns: true to skip/ignore the invalid char
         */
        internal func skip(invalid char: UInt8) -> Bool {
            switch self {
            case .failOnInvalidCharacters:
                return false
            case .ignoreWhiteSpaceAndNewline:
                return CharacterSet.whitespacesAndNewlines.contains(UnicodeScalar(char))
            case .ignoreInvalidCharacters:
                return char != 0x3d // 0x3d = '=' padding character
            }
        }
    }

    /// Encoding options
    public enum Padding {
        /// No padding
        case none
        /// Use padding (default)
        case padding

        /// Calculate the bytes needed to encode a given Data blob
        ///
        /// - Parameters:
        ///     - data: the data to calculate the necessary encoding length needed for
        ///     - lineFeeds: the interval at which new lines character needs to be inserted
        /// - Returns: the encoded byte length needed for Base64 encoding
        public func encodedLength(_ data: Data, lineFeeds: Int = 0) -> Int {
            var encodedLength = ((data.count + 2) / 3) * 4
            if case .none = self {
                let excess = data.count % 3
                // Remove padding size when not needed
                if excess > 0 {
                    encodedLength -= 3 - excess
                }
            }

            if lineFeeds > 0 {
                return encodedLength + (encodedLength / lineFeeds)
            } else {
                return encodedLength
            }
        }
    }

    /// Base64 Error
    public enum Error: Swift.Error {
        case invalidBase64String
    }

    /// Base64 encode Data blob
    ///
    /// - Parameters:
    ///     - data: the blob to encode
    ///     - padding: padding mode for encoding (default: .padding)
    /// - Returns: the Base64 encoded data blob
    public func encode(data: Data, with padding: Padding = .padding, lineFeeds: Int = 0) -> Data {
        // Length needed to encode data
        let outlen = padding.encodedLength(data, lineFeeds: lineFeeds)
        // Original input length
        let inlen = data.count
        // Data buffer that stores the encoded bytes
        let dataPtr = UnsafeMutablePointer<CChar>.allocate(capacity: outlen)
        // Lookup character table
        let characterTable = self.table.utf8CString

        // Pad the last 2 output bytes just in case padding would be needed. If not, the bytes will be overridden later.
        dataPtr[outlen - 2] = characterTable[0x40]
        dataPtr[outlen - 1] = characterTable[0x40]

        // pointer to the input data backing buffer
        _ = data.withUnsafeBytes { (bytes: UnsafePointer<UInt8>) -> Int in
            // Space needed per encoding block
            var bufferSize: Int
            let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: 3)
            defer {
                buffer.deallocate()
            }
            // Overall bytes that need encoding
            var bytesRemaining: Int = inlen
            // Every step (iteration) of 3 bytes; outputs 4. To keep the output index in sync we add this extra to the
            // output index.
            var extra = 0
            var addedLineFeeds = 0
            // Encode the input byte buffer step-by-step with steps of 3 bytes at a time
            let stepSize = 3
            for idx in stride(from: 0, to: inlen, by: stepSize) {
                // Space to fill for this pass is stepSize or bytesRemaining when latter is lesser.
                bufferSize = min(stepSize, bytesRemaining)
                // Fill the buffer with the input bytes
                buffer.initialize(repeating: 0, count: 3)
                buffer.assign(from: bytes.advanced(by: idx), count: bufferSize)
                // Tell the compiler the current buffer is to treated as an UInt32
                buffer.withMemoryRebound(to: UInt32.self, capacity: bufferSize) { bufferBytes in
                    // buffer is little-endian so the first byte is the least significant part of the UInt32.
                    let intValue = bufferBytes.pointee.bigEndian
                    // Since we've organized intValue in bigEndian we start with the first 6 bits (32-6 = 26) of
                    // intValue and go through the remaining bits when applicable.
                    var shift = 26
                    // Loop through the intValue till bufferSize and1 in favor of an if-pyramid
                    for lIdx in 0...bufferSize {
                        // Get the 6 bits we need to lookup the index character
                        let charIndex = Int((intValue >> shift) & 0x3f)
                        let index = idx + extra + lIdx
                        if lineFeeds > 0 && index > 0 && (index - addedLineFeeds) % lineFeeds == 0 {
                            extra += 1
                            addedLineFeeds += 1
                            // Put new line (LF) character
                            dataPtr[index] = CChar(bitPattern: 0xA)
                        }
                        // Put the character in the output buffer
                        dataPtr[idx + extra + lIdx] = characterTable[charIndex]
                        // Shift 6 bits left to go right in the intValue
                        shift -= 6
                    }
                }
                // As we did a great job, we can now strike of the hard work and subtract the stepSize from the still
                // to process bytes in the buffer
                bytesRemaining -= stepSize
                // This also goes for the extra count we have to add to the output buffer index
                extra += 1
            }

            // For verification purposes we could check whether the result/return value is 0 as it would indicate all
            // bytes have passed through encoding.
            return bytesRemaining
        }

        // Manage the unsafe dataPtr
        return Data(bytesNoCopy: dataPtr, count: outlen, deallocator: .free)
    }

    /// Base64 decode String
    ///
    /// - Parameters:
    ///     - string: base64 encoded string
    ///     - mode: decoding mode (default: .failOnInvalidCharacters)
    ///
    /// - Throws: Base64.Error
    ///
    /// - SeeAlso: `Base64.decode(data: Data, mode: Base64DecodeMode)`
    ///
    /// - Returns: base64 decoded data
    public static func decode(string: String, mode: Mode = .failOnInvalidCharacters) throws -> Data {
        return try string.withCString { bytes in
            // null terminated cString length
            let count = strlen(bytes)
            // pass cString as mutable raw pointer - it's safe we're not going to mutate the input on decoding anyway
            let ptr = UnsafeMutableRawPointer(mutating: bytes)
            let base64 = Data(bytesNoCopy: ptr, count: count, deallocator: .none)
            return try decode(data: base64, mode: mode)
        }
    }

    /// Base64 decode Data blob
    ///
    /// - Parameters:
    ///     - data: base64 encoded data
    ///     - mode: decoding mode (default: .failOnInvalidCharacters)
    ///
    /// - Throws: Base64.Error
    ///
    /// - Returns: base64 decoded data
    public static func decode(data: Data, mode: Mode = .failOnInvalidCharacters) throws -> Data {
        let input = data
        let decodedLength = mode.decodedLength(input)
        if decodedLength < 0 {
            throw Error.invalidBase64String
        }
        guard decodedLength > 0 else {
            /// No bytes to decode
            return Data()
        }

        // Data buffer that stores the decoded bytes
        let dataPtr = UnsafeMutablePointer<UInt8>.allocate(capacity: decodedLength)
        // Get the byte buffer to the encoded data
        let outLength = try input.withUnsafeBytes { (bytes: UnsafePointer<UInt8>) -> Int in
            return try decode(buffer: bytes, output: dataPtr, len: input.count, mode: mode)
        }

        // Manage the unsafe dataPtr
        return Data(bytesNoCopy: dataPtr, count: outLength, deallocator: .free)
    }

    private static func decode(
            buffer bytes: UnsafePointer<UInt8>,
            output dataPtr: UnsafeMutablePointer<UInt8>,
            len: Int,
            mode: Mode = .failOnInvalidCharacters
    ) throws -> Int {
        var needle = 0
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: 4)
        var bufferSize = 0
        defer {
            buffer.deallocate()
        }

        // Number of characters to decode
        var bytesLeft: () -> Int = {
            return len - needle
        }

        let table = Base64.asciiTable

        // Output buffer pointer
        var ptr = 0
        repeat {
            bufferSize = 0
            repeat {
                // fill the buffer - to skip over characters when necessary
                let nextByte = bytes[needle]
                if nextByte != 0x3d {
                    if table[Int(nextByte)] < 0x40 {
                        buffer[bufferSize] = nextByte
                        bufferSize += 1
                    } else if !mode.skip(invalid: nextByte) {
                        // abort decoding, we've encountered a bad char and we're not allowed to continue
                        defer {
                            dataPtr.deallocate()
                        }
                        throw Error.invalidBase64String
                    }
                    needle += 1
                } else {
                    // padding '=' char encountered (end-of-stream)
                    needle = len
                }
            } while bufferSize < 4 && bytesLeft() > 0

            // Decode the buffer
            if bufferSize > 0 {
                if bufferSize > 1 {
                    dataPtr[ptr] = table[Int(buffer[0])] << 2 | table[Int(buffer[1])] >> 4
                    ptr += 1
                }
                if bufferSize > 2 {
                    dataPtr[ptr] = table[Int(buffer[1])] << 4 | table[Int(buffer[2])] >> 2
                    ptr += 1
                }
                if bufferSize > 3 {
                    dataPtr[ptr] = table[Int(buffer[2])] << 6 | table[Int(buffer[3])]
                    ptr += 1
                }
            }
        } while bytesLeft() > 0
        return ptr
    }
}
