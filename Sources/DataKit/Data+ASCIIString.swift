//
// Created by Arjan Duijzer on 24/06/2018.
//

import Foundation

/// Convert Data into String
extension Data {

    /// Convert the Data blob to a 7-bit ASCII string when possible
    /// - Returns: unicode String
    public var asciiString: String? {
        return String(data: self, encoding: .nonLossyASCII)
    }
}
