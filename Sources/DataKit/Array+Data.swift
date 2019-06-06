//
// Created by Arjan Duijzer on 12/10/2018.
//

import Foundation

extension Array where Element == UInt8 {
    /// Returns: `[UInt8]` as `Data`
    public var data: Data {
        return Data(self)
    }
}
