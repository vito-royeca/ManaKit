//
//  MyMaintainer.swift
//  ManaKit_Example
//
//  Created by Jovito Royeca on 23/10/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import ManaKit
import RealmSwift
import PromiseKit

extension Maintainer {
    func updateOtherCardInformation() -> Promise<Void> {
        return Promise { seal in
            let sortDescriptors = [SortDescriptor(keyPath: "set.releaseDate", ascending: true),
                                   SortDescriptor(keyPath: "name", ascending: true)]
            let cards = realm.objects(CMCard.self).filter("id != nil").sorted(by: sortDescriptors)
            var count = 0
            print("Updating cards: \(count)/\(cards.count) \(Date())")
            
            // reload the date
            cachedCardTypes.removeAll()
            for object in realm.objects(CMCardType.self) {
                cachedCardTypes.append(object)
            }
            
            cachedLanguages.removeAll()
            for object in realm.objects(CMLanguage.self) {
                cachedLanguages.append(object)
            }
            let enLanguage = findLanguage(with: "en")
            
            // update the cards
            try! realm.write {
                for card in cards {
                    // displayName
                    var displayName: String?
                    if let language = card.language,
                        let code = language.code {
                        displayName = code == "en" ? card.name : card.printedName
                        
                        if displayName == nil {
                            displayName = card.name
                        }
                    }
                    card.displayName = displayName
                    
                    // myNameSection
                    if let _ = card.id,
                        let name = card.name {
                        card.myNameSection = sectionFor(name: name)
                    }

                    // myNumberOrder
                    if let _ = card.id,
                        let collectorNumber = card.collectorNumber {
                        card.myNumberOrder = order(of: collectorNumber)
                    }

                    // myType
                    if let typeLine = card.typeLine,
                        let name = typeLine.name {
                        
                        var types = [String]()
                        for type in ManaKit.sharedInstance.typeNames {
                            for n in name.components(separatedBy: " ") {
                                if n == type && !types.contains(type) {
                                    types.append(type)
                                }
                            }
                        }
                        
                        if types.count == 1 {
                            card.myType = findCardType(with: types.first!, language: enLanguage!)
                        } else if types.count > 1 {
                            card.myType = findCardType(with: "Multiple", language: enLanguage!)
                        }
                    }
                    
                    // Firebase id = set.code + _ + card.name + _ + card.name+ number?
                    if let _ = card.id,
                        let set = card.set,
                        let setCode = set.code,
                        let language = card.language,
                        let languageCode = language.code,
                        let name = card.name {
                        var firebaseID = "\(setCode.uppercased())_\(name)_\(name.lowercased())"

                        let variations = realm.objects(CMCard.self).filter("set.code = %@ AND language.code = %@ AND name = %@",
                                                                           setCode,
                                                                           languageCode,
                                                                           name)
                        
                        if variations.count > 1 {
                            let orderedVariations = variations.sorted(by: {(a, b) -> Bool in
                                return a.myNumberOrder < b.myNumberOrder
                            })
                            var index = 1

                            for c in orderedVariations {
                                if c.id == card.id {
                                    firebaseID += "\(index)"
                                    break
                                } else {
                                    index += 1
                                }
                            }
                        }

                        // add language code for non-english cards
                        if let language = card.language,
                            let code = language.code {
                            if code != "en" {
                                firebaseID += "_\(code)"
                            }
                        }
                        card.firebaseID = encodeFirebase(key: firebaseID)
                    }

                    realm.add(card)
                    
                    count += 1
                    if count % printMilestone == 0 {
                        print("Updating cards: \(count)/\(cards.count) \(Date())")
                    }
                }
                
                seal.fulfill(())
            }
        }
    }
    
//    func fetchVariations(ofCard card: CMCard) -> [CMCard] {
//        let predicate = NSPredicate(format: "set.code = %@ AND language.code = %@ AND id != %@ AND name = %@",
//                                    card.set!.code!,
//                                    card.language!.code!,
//                                    card.id!,
//                                    card.name!)
//        let sortDescriptors = [SortDescriptor(keyPath: "set.releaseDate", ascending: false),
//                               SortDescriptor(keyPath: "name", ascending: true),
//                               SortDescriptor(keyPath: "collectorNumber", ascending: true)]
//        var cards = [CMCard]()
//
//        for card in realm.objects(CMCard.self).filter(predicate).sorted(by: sortDescriptors) {
//            cards.append(card)
//        }
//        return cards
//    }
    
    func encodeFirebase(key: String) -> String {
        return key.replacingOccurrences(of: ".", with: "P%n*")
            .replacingOccurrences(of: "$", with: "D%n*")
            .replacingOccurrences(of: "#", with: "H%n*")
            .replacingOccurrences(of: "[", with: "On%*")
            .replacingOccurrences(of: "]", with: "n*C%")
            .replacingOccurrences(of: "/", with: "*S%n")
    }

    func decodeFirebase(key: String) -> String {
        return key.replacingOccurrences(of: "P%n*", with: ".")
            .replacingOccurrences(of: "D%n*", with: "$")
            .replacingOccurrences(of: "H%n*", with: "#")
            .replacingOccurrences(of: "On%*", with: "[")
            .replacingOccurrences(of: "n*C%", with: "]")
            .replacingOccurrences(of: "*S%n", with: "/")
    }

    // MARK: Comprehensive rules
    func createComprehensiveRules() -> Promise<Void> {
        return Promise { seal in
            guard let path = Bundle.main.path(forResource: comprehensiveRulesFileName,
                                              ofType: "txt",
                                              inDirectory: "data") else {
                seal.fulfill(())
                return
            }
            
            // delete existing data first
            try! realm.write {
                for object in realm.objects(CMRule.self) {
                    realm.delete(object)
                }
            
                let data = try! String(contentsOfFile: path, encoding: .ascii)
                let lines = data.components(separatedBy: .newlines)
                var startLine:String? = nil
                var endLine:String? = nil
                var includeStartLine = false
                var includeEndLine = false
                
                // parse the introduction
                var object: CMRule?
                if let o = realm.objects(CMRule.self).filter("term = %@", "Introduction").first {
                    object = o
                } else {
                    object = CMRule()
                }
                object!.term = "Introduction"
                object!.order = 0
                object!.definition = nil
                realm.add(object!)
                
                // parse the greetings
                var object2: CMRule?
                startLine = "Magic: The Gathering Comprehensive Rules"
                endLine = "Contents"
                includeStartLine = true
                includeEndLine = false
                if let text = parseData(fromLines: lines,
                                        startLine: startLine!,
                                        endLine: endLine!,
                                        includeStartLine: includeStartLine,
                                        includeEndLine: includeEndLine) {
                    if let o = realm.objects(CMRule.self).filter("parent = %@", object!).first {
                        object2 = o
                    } else {
                        object2 = CMRule()
                    }
                    object2!.term = nil
                    object2!.order = 0.1
                    object2!.definition = text
                    object2!.parent = object
                    realm.add(object2!)
                }
                
                // parse the rules
                parseRules(fromLines: lines)
                
                // parse the glossary
                if let o = realm.objects(CMRule.self).filter("term = %@", "Glossary").first {
                    object = o
                } else {
                    object = CMRule()
                }
                object!.term = "Glossary"
                object!.order = 10000
                object!.definition = nil
                realm.add(object!)
                parseGlossary(fromLines: lines, parent: object!)
                
                
                // parse the credits
                if let o = realm.objects(CMRule.self).filter("term = %@", "Credits").first {
                    object = o
                } else {
                    object = CMRule()
                }
                object!.term = "Credits"
                object!.order = 11000
                object!.definition = nil
                realm.add(object!)
                
                startLine = "Magic: The Gathering Original Game Design: Richard Garfield"
                endLine = "Published by Wizards of the Coast LLC"
                includeStartLine = true
                includeEndLine = true
                if let text = parseData(fromLines: lines,
                                        startLine: startLine!,
                                        endLine: endLine!,
                                        includeStartLine: includeStartLine,
                                        includeEndLine: includeEndLine) {
                    if let o = realm.objects(CMRule.self).filter("parent = %@", object!).first {
                        object2 = o
                    } else {
                        object2 = CMRule()
                    }
                    object2!.term = nil
                    object2!.order = 11000.1
                    object2!.definition = text
                    object2!.parent = object
                }
                
                seal.fulfill(())
            }
        }
    }

    func parseData(fromLines lines: [String], startLine: String, endLine: String, includeStartLine: Bool, includeEndLine: Bool) -> String? {
        var text: String?
        var isParsing = false
        
        for line in lines {
            if line.hasPrefix(startLine) {
                text = String()
                isParsing = true
            }
            
            if isParsing {
                if line.hasPrefix(endLine) {
                    if includeEndLine {
                        text!.append(line == "" ? "\n\n" : line)
                    }
                    isParsing = false
                } else {
                    if line.hasPrefix(startLine) {
                        if includeStartLine {
                            text!.append(line == "" ? "\n\n" : line)
                        }
                    } else {
                        text!.append(line == "" ? "\n\n" : line)
                    }
                }
            }
            
            if !isParsing {
                if text != nil {
                    text = text!.replacingOccurrences(of: "\n\n\n", with: "\n")
                    break
                }
            }
        }
        
        return text
    }
    
    func parseRules(fromLines lines: [String]) {
        let startLine = "Credits"
        let endLine = "Glossary"
        var isParsing = false
        var secondEndLine = false
        
        for line in lines {
            if line.hasPrefix(startLine) {
                isParsing = true
            } else if line.hasPrefix(endLine) {
                // glossary appears twice, so we need to end on the second appearance
                if secondEndLine {
                    break
                }
                secondEndLine = true
            }
            
            if isParsing {
                if line.hasPrefix("1") ||
                    line.hasPrefix("2") ||
                    line.hasPrefix("3") ||
                    line.hasPrefix("4") ||
                    line.hasPrefix("5") ||
                    line.hasPrefix("6") ||
                    line.hasPrefix("7") ||
                    line.hasPrefix("8") ||
                    line.hasPrefix("9") {
                    
                    var term = ""
                    var definition = ""
                    var first = true
                    
                    for e in line.components(separatedBy: " ") {
                        if first {
                            term = e
                            first = false
                        } else {
                            definition.append(definition.count > 0 ? " \(e)" : e)
                        }
                    }
                    if term.hasSuffix(".") {
                        term.remove(at: term.index(before: term.endIndex))
                    }

                    var object: CMRule?
                    if let o = realm.objects(CMRule.self).filter("term = %@", term).first {
                        object = o
                    } else {
                        object = CMRule()
                    }
                    object!.term = term
                    object!.order = order(of: term)
                    object!.definition = definition
                    realm.add(object!)

                    if term.contains(".") {
                        term = term.components(separatedBy: ".").first!
                        let _ = findParent(forRule: object!, withTerm: term)
                    } else {
                        while term != "" {
                            term.remove(at: term.index(before: term.endIndex))
                            
                            if term.count > 0 {
                                if let _ = findParent(forRule: object!, withTerm: term) {
                                    break
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func findParent(forRule rule: CMRule, withTerm term: String) -> CMRule? {
        guard let parent = realm.objects(CMRule.self).filter("term = %@", term).first else {
            return nil
        }
        
        if parent.definition == nil &&
            parent.definition == nil {
            realm.delete(parent)
        } else {
            if parent != rule {
                rule.parent = parent
                realm.add(rule)
                return parent
            }
        }
        
        return nil
    }
    
    func parseGlossary(fromLines lines: [String], parent: CMRule?) {
        let startLine = "Glossary"
        let endLine = "Credits"
        var isParsing = false
        var firstStartLineDone = false
        var firstEndLineDone = false
        var term: String?
        var definition: String?
        var lastDefinition: String?
        
        for line in lines {
            // Glssary and credits appear twice, hence must on second appearance
            if line.hasPrefix(startLine) {
                if firstStartLineDone {
                    isParsing = true
                    continue
                }
                firstStartLineDone = true
            }
            if line.hasPrefix(endLine) {
                if firstEndLineDone {
                    break
                }
                firstEndLineDone = true
            }
            
            if isParsing {
                if line == "" {
                    if term != nil && definition != nil {
                        var nextLine = lines[lines.index(of: lastDefinition!)! + 1]
                        if nextLine == "" {
                            nextLine = lines[lines.index(of: lastDefinition!)! + 2]
                        }
                        
                        let isList = nextLine.hasPrefix("1") ||
                            nextLine.hasPrefix("2") ||
                            nextLine.hasPrefix("3") ||
                            nextLine.hasPrefix("4") ||
                            nextLine.hasPrefix("5") ||
                            nextLine.hasPrefix("6") ||
                            nextLine.hasPrefix("7") ||
                            nextLine.hasPrefix("8") ||
                            nextLine.hasPrefix("9") ||
                            nextLine.hasPrefix("See") ||
                            nextLine.hasPrefix("Some older cards")
                        
                        if isList {
                            definition!.append(definition!.count > 0 ? "\n\(line)" : line)
                        } else {
                            var object: CMRule?
                            if let o = realm.objects(CMRule.self).filter("term = %@", term!).first {
                                object = o
                            } else {
                                object = CMRule()
                            }
                            
                            let letters = CharacterSet.letters
                            var prefix = String(term!.prefix(1))
                            if prefix.rangeOfCharacter(from: letters) == nil {
                                prefix = "#"
                            }
                            
                            object!.term = term
                            object!.termSection = prefix
                            object!.definition = definition
                            object!.parent = parent
                            realm.add(object!)
                            
                            term = nil
                            definition = nil
                            lastDefinition = nil
                        }
                    }
                } else {
                    let isList = line.hasPrefix("1") ||
                        line.hasPrefix("2") ||
                        line.hasPrefix("3") ||
                        line.hasPrefix("4") ||
                        line.hasPrefix("5") ||
                        line.hasPrefix("6") ||
                        line.hasPrefix("7") ||
                        line.hasPrefix("8") ||
                        line.hasPrefix("9") ||
                        line.hasPrefix("See") ||
                        line.hasPrefix("Some older cards")
                    
                    if isList {
                        if definition == nil {
                            definition = String()
                        }
                        definition!.append(definition!.count > 0 ? "\n\(line)" : line)
                        lastDefinition = line
                    } else {
                        if term == nil {
                            term = line
                        } else {
                            if definition == nil {
                                definition = String()
                            }
                            definition!.append(line)
                            lastDefinition = line
                        }
                    }
                }
            }
        }
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
