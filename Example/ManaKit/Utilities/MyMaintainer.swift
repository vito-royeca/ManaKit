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
    func updateCards(useInMemoryDatabase: Bool) {
        toggleDatabaseUsage(useInMemoryDatabase: useInMemoryDatabase)

        startActivity(name: "updateCards")
        
        let request: NSFetchRequest<CMCard> = CMCard.fetchRequest()
        request.predicate = NSPredicate(format: "id != nil")
        request.sortDescriptors = [NSSortDescriptor(key: "set.releaseDate", ascending: true),
                                   NSSortDescriptor(key: "name", ascending: true)]
        let cards = try! context!.fetch(request)
        var count = 0
        print("Creating cards: \(count)/\(cards.count) \(Date())")
        
        for card in cards {
            // myNameSection
            if let name = card.name {
                card.myNameSection = sectionFor(name: name)
            }
            
            // myNumberOrder
            if let collectorNumber = card.collectorNumber {
                card.myNumberOrder = order(of: collectorNumber)
            }
            
            // Firebase id = set.code + _ + card.name + _ + card.name+ number?
            if let set = card.set,
                let setCode = set.code,
                let name = card.name {
                var firebaseId = "\(setCode.uppercased())_\(name)_\(name.lowercased())"
                
                if let variations = card.variations,
                    let array = variations.allObjects as? [CMCard] {
                    var index = 1
                    
                    for c in array {
                        if c.id == card.id {
                            firebaseId += "\(index)"
                            break
                        } else {
                            index += 1
                        }
                    }
                }
                card.firebaseId = firebaseId
            }
            
            // Original text
            // TODO: get original text from mtgjson
            
            // types
            // TODO: get types from mtgjson
            
            // Subtypes
            // TODO: get subtypes from mtgjson
            
            // Supertypes
            // TODO: get supertypes from mtgjson
            
            count += 1
            if count % printMilestone == 0 {
                print("Updating cards: \(count)/\(cards.count) \(Date())")
            }
        }

        try! context!.save()
        endActivity()
    }
    
    func createComprehensiveRules(useInMemoryDatabase: Bool) {
        toggleDatabaseUsage(useInMemoryDatabase: useInMemoryDatabase)
        
    }

    /*
     * Converts @param string into double equivalents i.e. 100.1a = 100.197
     * Useful for ordering in NSSortDescriptor.
     */
    private func order(of string: String) -> Double {
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
