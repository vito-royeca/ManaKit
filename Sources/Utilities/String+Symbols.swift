//
//  String+Symbols.swift
//  Manaprobe
//
//  Created by Vito Royeca on 11/14/23.
//

import Foundation

extension String {
    public static let emdash = "\u{2014}"
    
    public func toSetUnicode() -> String {
        let keyruneUnicode = self.isEmpty ? "e684" : self
        
        guard let charAsInt = Int(keyruneUnicode, radix: 16),
           let uScalar = UnicodeScalar(charAsInt) else {
            return ""
        }
        let unicode = "\(uScalar)"
        
        return unicode
    }
    
    public func toManaUnicode() -> String {
        if self.isEmpty {
            return ""
        }
        
//        if let url = Bundle.module.url(forResource: "mana", withExtension: "plist") {
//            let data = try! Data(contentsOf: url)
//            let decoder = PropertyListDecoder()
//            return try! decoder.decode([String: [String: String]].self, from: data)
//        } else {
//            return [:]
//        }
        
        var sentinel = 0
        var result = self
        let tempcode = "e684"

        repeat {
            for i in sentinel...self.count - 1 {
                let c = self[self.index(self.startIndex, offsetBy: i)]
                
                if c == "{" {
                    for j in i...self.count - 1 {
                        let cc = self[self.index(self.startIndex, offsetBy: j)]
                        
                        if cc == "}" {
                            sentinel = j + 1
                            break
                        }
                    }
                
                    guard let charAsInt = Int(tempcode, radix: 16),
                       let uScalar = UnicodeScalar(charAsInt) else {
                        return ""
                    }

                    let unicode = "\(uScalar)"
                    let start = self.index(result.startIndex, offsetBy: i)
                    let end = self.index(result.startIndex, offsetBy: sentinel)
                    result = result.replacingCharacters(in: start..<end, with: unicode)

                    break
                } else {
                    sentinel += 1
                }
            }
        } while sentinel <= self.count - 1
        
        return result
    }
}
