//
//  MGSet+Utilities.swift
//  
//
//  Created by Vito Royeca on 12/27/21.
//

import UIKit

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
        guard let logoCode = logoCode,
            let url = URL(string: "\(ManaKit.shared.apiURL)/images/sets/\(logoCode).png") else {
            return nil
        }
        
        return url
    }
    
    public var logoImage: UIImage? {
        get {
            guard let logoCode = logoCode else {
                return nil
            }
            return UIImage(named: logoCode, in: Bundle.module, compatibleWith: nil)
        }
    }
}
