//
//  Maintainer.swift
//  ManaKit_Example
//
//  Created by Jovito Royeca on 23/10/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import CoreData
import ManaKit
import Sync

class Maintainer: NSObject {
    // MARK: Constants
    let printMilestone = 1000
    let cardsFileName   = "scryfall-all-cards.json"
    let rulingsFileName = "scryfall-rulings.json"
    let comprehensiveRulesFileName = "MagicCompRules 20181005"
    var dataStack =  ManaKit.sharedInstance.dataStack
    var context = ManaKit.sharedInstance.dataStack!.mainContext
    var useInMemoryDatabase = true
    
    // MARK: Variables
    var dateStart = Date()
    
    // MARK: Custom methods
    func startActivity(name: String) {
        dateStart = Date()
        print("Starting \(name)...")
    }
    
    func endActivity() {
        let dateEnd = Date()
        let timeDifference = dateEnd.timeIntervalSince(dateStart)
        print("Total Time Elapsed: \(self.dateStart) - \(dateEnd) = \(self.format(timeDifference))")
        print("docsPath = \(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])")
    }

    // MARK: Utility methods
    func sectionFor(name: String) -> String? {
        if name.count == 0 {
            return nil
        } else {
            let letters = CharacterSet.letters
            var prefix = String(name.prefix(1))
            if prefix.rangeOfCharacter(from: letters) == nil {
                prefix = "#"
            }
            return prefix.uppercased().folding(options: .diacriticInsensitive, locale: .current)
        }
    }
    
    func displayFor(name: String) -> String {
        var display = ""
        let components = name.components(separatedBy: "_")
        
        if components.count > 1 {
            for e in components {
                var cap = e
                
                if e != "the" || e != "a" || e != "an" || e != "and" {
                    cap = e.prefix(1).uppercased() + e.dropFirst()
                }
                if display.count > 0 {
                    display.append(" ")
                }
                display.append(cap)
            }
        } else {
            display = name
        }
        
        return display
    }
    
    func capitalize(string: String) -> String {
        if string.count == 0 {
            return string
        } else {
            return (string.prefix(1).uppercased() + string.dropFirst()).replacingOccurrences(of: "_", with: " ")
        }
    }
    
    func format(_ interval: TimeInterval) -> String {
        if interval == 0 {
            return "HH:mm:ss"
        }
        
        let seconds = interval.truncatingRemainder(dividingBy: 60)
        let minutes = (interval / 60).truncatingRemainder(dividingBy: 60)
        let hours = (interval / 3600)
        return String(format: "%.2d:%.2d:%.2d", Int(hours), Int(minutes), Int(seconds))
    }
}
