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
        request.predicate = NSPredicate(format: "id != nil")
        request.sortDescriptors = [NSSortDescriptor(key: "set.releaseDate", ascending: true),
                                   NSSortDescriptor(key: "name", ascending: true)]
        let cards = try! context.fetch(request)
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
                var firebaseID = "\(setCode.uppercased())_\(name)_\(name.lowercased())"
                
                if let variations = card.variations,
                    let array = variations.allObjects as? [CMCard] {
                    var index = 1
                    
                    for c in array {
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
                card.firebaseID = firebaseID
            }

            count += 1
            if count % printMilestone == 0 {
                print("Updating cards: \(count)/\(cards.count) \(Date())")
            }
        }
        try! context.save()
        
        // Comprehensive rules
        createComprehensiveRules()
        
        endActivity()
    }
    
    // MARK: Comprehensive rules
    func createComprehensiveRules() {
        startActivity(name: "createComprehensiveRules")
        
        guard let path = Bundle.main.path(forResource: comprehensiveRulesFileName,
                                          ofType: "txt",
                                          inDirectory: "data") else {
            return
        }
        
        // delete existing data first
        let request: NSFetchRequest<CMRule> = CMRule.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request as! NSFetchRequest<NSFetchRequestResult>)
        try! dataStack!.persistentStoreCoordinator.execute(deleteRequest,
                                                           with: context)
        
        let data = try! String(contentsOfFile: path, encoding: .ascii)
        let lines = data.components(separatedBy: .newlines)
        var objectFinder:[String: AnyObject]? = nil
        var startLine:String? = nil
        var endLine:String? = nil
        var includeStartLine = false
        var includeEndLine = false
        
        // parse the introduction
        objectFinder = ["term": "Introduction"] as [String: AnyObject]
        if let object = ManaKit.sharedInstance.findObject("CMRule",
                                                          objectFinder: objectFinder,
                                                          createIfNotFound: true) as? CMRule {
            object.term = "Introduction"
            object.order = 0
            object.definition = nil
            
            startLine = "Magic: The Gathering Comprehensive Rules"
            endLine = "Contents"
            includeStartLine = true
            includeEndLine = false
            if let text = parseData(fromLines: lines,
                                    startLine: startLine!,
                                    endLine: endLine!,
                                    includeStartLine: includeStartLine,
                                    includeEndLine: includeEndLine) {
                objectFinder = ["parent": object] as [String: AnyObject]
                
                if let object2 = ManaKit.sharedInstance.findObject("CMRule",
                                                                   objectFinder: objectFinder,
                                                                   createIfNotFound: true) as? CMRule {
                    object2.term = nil
                    object2.order = 0.1
                    object2.definition = text
                    object2.parent = object
                }
            }
        }
        
        // parse the rules
        parseRules(fromLines: lines)
        
        // parse the glossary
        objectFinder = ["term": "Glossary"] as [String: AnyObject]
        if let object = ManaKit.sharedInstance.findObject("CMRule",
                                                          objectFinder: objectFinder,
                                                          createIfNotFound: true) as? CMRule {
            object.term = "Glossary"
            object.order = 10000
            object.definition = nil
            
            parseGlossary(fromLines: lines, parent: object)
        }
        
        // parse the credits
        objectFinder = ["term": "Credits"] as [String: AnyObject]
        if let object = ManaKit.sharedInstance.findObject("CMRule",
                                                          objectFinder: objectFinder,
                                                          createIfNotFound: true) as? CMRule {
            object.term = "Credits"
            object.order = 11000
            object.definition = nil
            
            startLine = "Magic: The Gathering Original Game Design: Richard Garfield"
            endLine = "Published by Wizards of the Coast LLC"
            includeStartLine = true
            includeEndLine = true
            if let text = parseData(fromLines: lines, startLine: startLine!, endLine: endLine!, includeStartLine: includeStartLine, includeEndLine: includeEndLine) {
                objectFinder = ["parent": object] as [String: AnyObject]
                
                if let object2 = ManaKit.sharedInstance.findObject("CMRule",
                                                                   objectFinder: objectFinder,
                                                                   createIfNotFound: true) as? CMRule {
                    object2.term = nil
                    object2.order = 11000.1
                    object2.definition = text
                    object2.parent = object
                }
            }
        }
        
        try! context.save()
        endActivity()
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
                    
                    let objectFinder = ["term": term] as [String: AnyObject]
                    if let object = ManaKit.sharedInstance.findObject("CMRule",
                                                                      objectFinder: objectFinder,
                                                                      createIfNotFound: true) as? CMRule {
                        object.term = term
                        object.order = order(of: term)
                        object.definition = definition
                        
                        if term.contains(".") {
                            term = term.components(separatedBy: ".").first!
                            let _ = findParent(forRule: object, withTerm: term)
                        } else {
                            while term != "" {
                                term.remove(at: term.index(before: term.endIndex))
                                
                                if term.count > 0 {
                                    if let _ = findParent(forRule: object, withTerm: term) {
                                        break
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        
        return
    }
    
    func findParent(forRule rule: CMRule, withTerm term: String) -> CMRule? {
        let parentFinder = ["term": term] as [String: AnyObject]
        
        guard let parent = ManaKit.sharedInstance.findObject("CMRule",
                                                             objectFinder: parentFinder,
                                                             createIfNotFound: true) as? CMRule else {
            return nil
        }
        
        if parent.definition == nil &&
            parent.definition == nil {
            context.delete(parent)
        } else {
            if parent != rule {
                rule.parent = parent
                try! context.save()
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
                            let objectFinder = ["term": term!] as [String: AnyObject]
                            
                            if let object = ManaKit.sharedInstance.findObject("CMRule",
                                                                              objectFinder: objectFinder,
                                                                              createIfNotFound: true) as? CMRule {
                                let letters = CharacterSet.letters
                                var prefix = String(term!.prefix(1))
                                if prefix.rangeOfCharacter(from: letters) == nil {
                                    prefix = "#"
                                }
                                
                                object.term = term
                                object.termSection = prefix
                                object.definition = definition
                                object.parent = parent
                                
                                term = nil
                                definition = nil
                                lastDefinition = nil
                            }
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
        
        return
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
