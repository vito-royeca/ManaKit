//
//  MyMaintainer.swift
//  ManaKit_Example
//
//  Created by Jovito Royeca on 23/10/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import CoreData
import ManaKit

class MyMaintainer: Maintainer {
    func updateCards() {
        startActivity(name: "updateCards")
        
        let request: NSFetchRequest<CMCard> = CMCard.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "set.releaseDate", ascending: true),
                                   NSSortDescriptor(key: "name", ascending: true)]
        if let cards = try! ManaKit.sharedInstance.dataStack?.mainContext.fetch(request) {
            var count = 0
            print("Creating cards: \(count)/\(cards.count) \(Date())")
            
            for card in cards {
                count += 1
                
                // myNameSection
                if let name = card.name {
                    card.myNameSection = sectionFor(name: name)
                }
                
                // myNumberOrder
                if let collectorNumber = card.collectorNumber {
                    card.myNumberOrder = order(of: collectorNumber)
                }
                
                // Original text
                // TODO: get original text from mtgjson
                
                // Firebase id
                // TODO: update firebaseId via: set.code + _ + card.name + _ + card.name.strippied + number?
                
                if count % printMilestone == 0 {
                    print("Updating cards: \(count)/\(cards.count) \(Date())")
                    try! ManaKit.sharedInstance.dataStack?.mainContext.save()
                }
            }
        }
        
        endActivity()
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
