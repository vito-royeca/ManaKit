//
//  MGSet+Utilities.swift
//  
//
//  Created by Vito Royeca on 12/27/21.
//

import Foundation

#if !os(macOS)
import UIKit
#endif

extension MGSet {
    public var keyrune2Unicode: String {
        get {
            let keyruneUnicode = keyruneUnicode ?? "e684"
            
            guard let charAsInt = Int(keyruneUnicode, radix: 16),
               let uScalar = UnicodeScalar(charAsInt) else {
                return ""
            }
            let unicode = "\(uScalar)"
            
            return unicode
        }
    }
    
    public var smallLogoURL: URL? {
        guard let logoCode = logoCode,
            let url = URL(string: "\(ManaKit.shared.apiURL)/images/sets/\(logoCode)_small.png") else {
            return nil
        }
        
        return url
    }
    
    public var bigLogoURL: URL? {
        guard let logoCode = logoCode,
            let url = URL(string: "\(ManaKit.shared.apiURL)/images/sets/\(logoCode)_big.png") else {
            return nil
        }
        
        return url
    }

    public var displayReleaseDate: String? {
        get {
            guard let releaseDate = releaseDate else {
                return nil
            }
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            
            return formatter.string(from: releaseDate)
        }
    }
}
