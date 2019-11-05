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
import RealmSwift

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
    let realm = ManaKit.sharedInstance.realm
    let setCodesForProcessing:[String]? = nil
    let tcgplayerAPIVersion = "v1.9.0"
    let tcgplayerAPILimit = 300
    var tcgplayerAPIToken = ""
    
    // MARK: Variables
    var dateStart = Date()
    var cardPrimaryKey = Int32(1)
    var cachedLanguages = [CMLanguage]()
    var cachedCardTypes = [CMCardType]()
    var cachedSets = [CMSet]()
    var cachedCardColors = [CMCardColor]()
    var cachedBorderColors = [CMCardBorderColor]()
    var cachedLayouts = [CMCardLayout]()
    var cachedArtists = [CMCardArtist]()
    var cachedFrames = [CMCardFrame]()
    var cachedFrameEffects = [CMCardFrameEffect]()
    var cachedRarities = [CMCardRarity]()
    var cachedWatermarks = [CMCardWatermark]()
    var cachedFormats = [CMCardFormat]()
    var cachedLegalities = [CMLegality]()
    var cachedRulings = [CMRuling]()
    var countIndex = 0
    var countTotal = 0
    
    // MARK: Custom methods
    func createPGData() -> Promise<Void> {
        return Promise { seal in
            let setsArray = setsData()
            let cardsArray = cardsData()

            // sets
//            var promises = filterSetBlocks(array: setsArray)
//            promises.append(contentsOf: filterSetTypes(array: setsArray))
//            promises.append(contentsOf: setsArray.map { dict in
//                return {
//                    return self.createOrUpdatePGSetPromise(dict: dict)
//                }
//            })
//            promises.append(contentsOf: createOrUpdatePGKeyrunePromises(array: setsArray))
//
//            // cards
//            promises.append(contentsOf: filterRarities(array: cardsArray))
//            promises.append(contentsOf: filterLanguages(array: cardsArray))
//            promises.append(contentsOf: filterWatermarks(array: cardsArray))
//            promises.append(contentsOf: filterLayouts(array: cardsArray))
//            promises.append(contentsOf: filterFrames(array: cardsArray))
//            promises.append(contentsOf: filterFrameEffects(array: cardsArray))
//            promises.append(contentsOf: filterColors(array: cardsArray))
//            promises.append(contentsOf: filterFormats(array: cardsArray))
//            promises.append(contentsOf: filterLegalities(array: cardsArray))
//            promises.append(contentsOf: filterTypes(array: cardsArray))
//            promises.append(contentsOf: cardsArray.map { dict in
//                return {
//                    return self.createOrUpdatePGCardPromise(dict: dict)
//                }
//            })
            
            let promises = filterTypes(array: cardsArray)
            execInSequence(promises: promises)
            seal.fulfill(())
        }
    }
    
    func startActivity(name: String) {
        dateStart = Date()
        print("Starting \(name) on... \(dateStart)")
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
    
    func createNodePromise(urlString: String, parameters: String) -> Promise<(data: Data, response: URLResponse)> {
            guard let cleanURL = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                let url = URL(string: cleanURL) else {
                fatalError("Malformed url")
            }
            
            var rq = URLRequest(url: url)
            rq.httpMethod = "POST"
            rq.setValue("application/json", forHTTPHeaderField: "Accept")
            rq.httpBody = parameters.replacingOccurrences(of: "\n", with: "").data(using: .utf8)
        
            return URLSession.shared.dataTask(.promise, with: rq)
    }
    
    func execInSequence(promises: [()->Promise<(data: Data, response: URLResponse)>]) {
        var promise = promises.first!()
        countIndex = 0
        countTotal = promises.count
        
        print("Start creating data: \(self.countIndex)/\(self.countTotal) \(Date())")
        for next in promises {
            promise = promise.then { n -> Promise<(data: Data, response: URLResponse)> in
                self.countIndex += 1
                if self.countIndex % self.printMilestone == 0 {
                    print("Creating... \(self.countIndex)/\(self.countTotal) \(Date())")
                }
                return next()
            }
        }
        promise.done {_ in
            print("Done creating data: \(self.countIndex)/\(self.countTotal) \(Date())")
            self.endActivity()
        }.catch { error in
            print(error)
        }
    }
}

