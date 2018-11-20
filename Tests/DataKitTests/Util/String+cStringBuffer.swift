//
// Created by Arjan Duijzer on 10/12/2018.
//

import Foundation

extension String {
    /// copy cString byte buffer for reading only
    var cStringByteBuffer: Data {
        return withCString { bytes in
            // null terminated cString length
            let count = strlen(bytes)
            return Data(bytes: bytes, count: count)
        }
    }
}
