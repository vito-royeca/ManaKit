//
//  MyMaintainer.swift
//  ManaKit_Example
//
//  Created by Jovito Royeca on 23/10/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit

class MyMaintainer: Maintainer {
    func updateCards() {
        // Original text
        // TODO: get original text from mtgjson
        
        // Firebase id
        // TODO: update firebaseId via: set.code + _ + card.name + _ + card.name.strippied + number?
        
        // myNumberOrder
        // myNameSection
    }
    
    /*
     * Converts @param string into double equivalents i.e. 100.1a = 100.197
     * Useful for ordering in NSSortDescriptor.
     */
    func order(of string: String) -> Double {
        var termOrder = Double(0)
        
        if let num = Double(string) {
            termOrder = num
        } else {
            let digits = NSCharacterSet.decimalDigits
            var numString = ""
            var charString = ""
            
            for c in string.unicodeScalars {
                if c == "." || digits.contains(c) {
                    numString.append(String(c))
                } else {
                    charString.append(String(c))
                }
            }
            
            if let num = Double(numString) {
                termOrder = num
            }
            
            if charString.count > 0 {
                for c in charString.unicodeScalars {
                    let s = String(c).unicodeScalars
                    termOrder += Double(s[s.startIndex].value) / 100
                }
            }
        }
        
        return termOrder
    }
}
