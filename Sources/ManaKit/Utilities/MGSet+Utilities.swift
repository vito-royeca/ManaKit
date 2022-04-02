//
//  MGSet+Utilities.swift
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
    
    public var logoURL: URL? {
        var code = code
        if code == "pw22" ||
           code == "pw21" {
            code = "wpnPromos"
        } else if code == "p22" ||
           code == "p22"{
            code = "judgePromos"
        } else {
            if let parent = parent {
                code = parent.code
            }
        }
        
        return URL(string: "http://managuideapp.com/images/sets/\(code).png")
    }
}
