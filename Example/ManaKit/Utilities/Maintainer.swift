//
//  Maintainer.swift
//  ManaKit_Example
//
//  Created by Jovito Royeca on 23/10/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import ManaKit
import PromiseKit
import SSZipArchive

enum MaintainerKeys {
    static let MaintainanceDone        = "MaintainanceDone"
}

class Maintainer: NSObject {
    // MARK: Constants
    let printMilestone = 1000
    let cardsFileName   = "scryfall-all-cards.json"
    let rulingsFileName = "scryfall-rulings.json"
    let setsFileName    = "scryfall-sets.json"
    let keyruneFileName = "keyrune.html"
    let comprehensiveRulesFileName = "MagicCompRules 20190823"
    let setCodesForProcessing:[String]? = nil
    let tcgplayerAPIVersion = "v1.9.0"
    let tcgplayerAPILimit = 300
    var tcgplayerAPIToken = ""
    
    // MARK: Variables
    var dateStart = Date()
    
    // MARK: Custom methods
    func createPGData() -> Promise<Void> {
        return Promise { seal in
            let setsArray = setsData()
            let cardsArray = cardsData()
            let rulingsArray = rulingsData()
            var promises = [()->Promise<(data: Data, response: URLResponse)>]()
            
//            // sets
            promises.append(contentsOf: filterSetBlocks(array: setsArray))
            promises.append(contentsOf: filterSetTypes(array: setsArray))
            promises.append(contentsOf: filterSets(array: setsArray))
            promises.append(contentsOf: createKeyrunePromises(array: setsArray))
//
//            // cards
            promises.append(contentsOf: filterArtists(array: cardsArray))
            promises.append(contentsOf: filterRarities(array: cardsArray))
            promises.append(contentsOf: filterLanguages(array: cardsArray))
            promises.append(contentsOf: filterWatermarks(array: cardsArray))
            promises.append(contentsOf: filterLayouts(array: cardsArray))
            promises.append(contentsOf: filterFrames(array: cardsArray))
            promises.append(contentsOf: filterFrameEffects(array: cardsArray))
            promises.append(contentsOf: filterColors(array: cardsArray))
            promises.append(contentsOf: filterFormats(array: cardsArray))
            promises.append(contentsOf: filterLegalities(array: cardsArray))
            promises.append(contentsOf: filterTypes(array: cardsArray))
            promises.append(contentsOf: filterComponents(array: cardsArray))
            promises.append(contentsOf: cardsArray.map { dict in
                return {
                    return self.createCardPromise(dict: dict)
                }
            })
            promises.append(contentsOf: filterFaces(array: cardsArray))
            
            // rulings
            promises.append(self.createDeleteRulingPromise)
            promises.append(contentsOf: rulingsArray.map { dict in
                return {
                    return self.createRulingPromise(dict: dict)
                }
            })
            
            // test only
            
            execInSequence(promises: promises)
            seal.fulfill(())
        }
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
    
    func execInSequence(promises: [()->Promise<(data: Data, response: URLResponse)>]) {
        var promise = promises.first!()
        
        let countTotal = promises.count
        var countIndex = 0
        
        print("Start exec: \(countIndex)/\(countTotal) \(Date())")
        for next in promises {
            promise = promise.then { n -> Promise<(data: Data, response: URLResponse)> in
                countIndex += 1
                
                if countIndex % self.printMilestone == 0 {
                    print("Exec... \(countIndex)/\(countTotal) \(Date())")
                }
                return next()
            }
        }
        promise.done {_ in
            print("Done exec: \(countIndex)/\(countTotal) \(Date())")
            self.endActivity()
        }.catch { error in
            print(error)
        }
    }
    
    func startActivity(name: String) {
        dateStart = Date()
        print("Starting \(name) on... \(dateStart)")
    }
    
    func endActivity() {
        let dateEnd = Date()
        let timeDifference = dateEnd.timeIntervalSince(dateStart)
        
        print("Total Time Elapsed on: \(dateStart) - \(dateEnd) = \(format(timeDifference))")
        print("docsPath = \(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])")
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

