//
// Created by Arjan Duijzer on 10/06/2018.
//

import Foundation

/// Convert Data into String
public extension Data {

    /// Convert the Data blob to an UTF-8 string when possible
    /// - Returns: UTF-8 String
    public var utf8string: String? {
        return String(data: self, encoding: .utf8)
    }
}