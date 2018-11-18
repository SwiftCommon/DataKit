//
// Created by Arjan Duijzer on 09/11/2018.
//

import Foundation

/// Base64 encoder
public enum Base64 {
    /// Normal Base64 encoding alphabet
    case base64
    /// URL safe Base64 encoding alphabet
    case urlSafe

    var table: String {
        switch self {
        case .base64:
            return "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/="
        case .urlSafe:
            return "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_="
        }
    }

    /// Base64 encode Data blob
    ///
    /// - Parameters:
    ///     - data: the blob to encode
    ///     - padding: padding mode for encoding (default: .padding)
    /// - Returns: the Base64 encoded data blob
    public func encode(data: Data, with padding: Base64Padding = .padding) -> Data {
        // Length needed to encode data
        let outLength = padding.encodedLength(data)
        // Original input length
        let inLength = data.count
        // Data buffer that stores the encoded bytes
        let dataPtr = UnsafeMutablePointer<UInt8>.allocate(capacity: outLength)
        // Lookup character table
        let characterTable: [CUnsignedChar] = Array(self.table.utf8CString).map {
            UInt8($0)
        }

        // Pad the last 2 output bytes just in case padding would be needed. If not, the bytes will be overridden later.
        dataPtr[outLength - 2] = characterTable[0x40]
        dataPtr[outLength - 1] = characterTable[0x40]

        // pointer to the input data backing buffer
        _ = data.withUnsafeBytes { (bytes: UnsafePointer<UInt8>) -> Int in
            // Create a buffer to store the current to-encode bytes
            let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: 3)
            defer {
                buffer.deallocate()
            }
            // Space needed
            var bufferSize: Int
            // Overall bytes that need encoding
            var bytesRemaining: Int = inLength
            // Every step (iteration) of 3 bytes; outputs 4. To keep the output index in sync we add this extra to the
            // output index.
            var extra = 0
            // Encode the input byte buffer step-by-step with steps of 3 bytes at a time
            let stepSize = 3
            for idx in stride(from: 0, to: inLength, by: stepSize) {
                // Space to fill for this pass is stepSize or bytesRemaining when lesser than.
                bufferSize = min(stepSize, bytesRemaining)
                // Fill the buffer with the input bytes
                // note: it doesn't matter that we can get out of bounds with assignment since the Pointee type is a
                // 'trivial' one (UInt8)
                buffer.assign(from: bytes.advanced(by: idx), count: stepSize)
                // Tell the compiler the current buffer is to treated as an UInt32
                buffer.withMemoryRebound(to: UInt32.self, capacity: bufferSize) { value in
                    // value is little-endian so the first byte is the least significant part of the UInt32.
                    let intValue = value.pointee.bigEndian
                    // Since we've organized intValue in bigEndian we start with the first 6 bits (32-6 = 26) of
                    // intValue and go through the remaining bits when applicable.
                    var shift = 26
                    // Loop through the intValue till bufferSize and1 in favor of an if-pyramid
                    for lIdx in 0..<bufferSize + 1 {
                        // Get the 6 bits we need to lookup the index character
                        let charIndex = Int((intValue >> shift) & 0x3f)
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
        return Data(bytesNoCopy: dataPtr, count: outLength, deallocator: .free)
    }
}

/// Base64 encoding options
public enum Base64Padding {
    /// No-pad
    case noPadding
    /// Use padding (default)
    case padding

    /// Calculate the bytes needed to encode a given Data blob
    ///
    /// - Parameter data: the data to calculate the necessary encoding length needed for
    /// - Returns: the encoded byte length needed for Base64 encoding
    public func encodedLength(_ data: Data) -> Int {
        var encodedLength = data.count
        let excess = encodedLength % 3
        if excess != 0 {
            encodedLength += 3 - excess
        }
        encodedLength /= 3
        encodedLength *= 4

        if excess > 0, case .noPadding = self {
            // Remove padding size when not needed
            encodedLength -= 3 - excess
        }

        return encodedLength
    }
}
