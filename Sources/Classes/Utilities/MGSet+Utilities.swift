//
//  File.swift
//  
//
//  Created by Vito Royeca on 12/27/21.
//

import Foundation

extension MGSet {
    public func keyrune2Unicode() -> String {
        let keyruneUnicode = keyruneUnicode ?? "e684"
        
        guard let charAsInt = Int(keyruneUnicode, radix: 16),
           let uScalar = UnicodeScalar(charAsInt) else {
            return ""
        }
        let unicode = "\(uScalar)"
        
        return unicode
    }
}
