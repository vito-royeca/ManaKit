//
//  MyMaintainer+Rules.swift
//  ManaKit_Example
//
//  Created by Jovito Royeca on 23/10/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import ManaKit
import RealmSwift
import PromiseKit

extension Maintainer {
    func createRulings() -> Promise<Void> {
        return Promise { seal in
            firstly {
                self.fetchRulings()
            }.then {
                self.saveRulings()
            }.done {
                seal.fulfill(())
            }.catch { error in
                seal.reject(error)
            }
        }
    }
    
    func fetchRulings() -> Promise<Void> {
        return Promise { seal in
            guard let cachePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first else {
                fatalError("Malformed cachePath")
            }
            let rulingsPath = "\(cachePath)/\(ManaKit.Constants.ScryfallDate)_\(rulingsFileName)"
            let willFetch = !FileManager.default.fileExists(atPath: rulingsPath)
            
            if willFetch {
                guard let urlString = "https://archive.scryfall.com/json/\(rulingsFileName)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                    let url = URL(string: urlString) else {
                        fatalError("Malformed url")
                }
                var rq = URLRequest(url: url)
                rq.httpMethod = "GET"
                
                print("Fetching Scryfall rulings... \(urlString)")
                firstly {
                    URLSession.shared.dataTask(.promise, with:rq)
                }.compactMap {
                    try JSONSerialization.jsonObject(with: $0.data) as? [[String: Any]]
                }.done { json in
                    if let outputStream = OutputStream(toFileAtPath: rulingsPath, append: false) {
                        print("Writing Scryfall rulings... \(rulingsPath)")
                        var error: NSError?
                        outputStream.open()
                        JSONSerialization.writeJSONObject(json,
                                                          to: outputStream,
                                                          options: JSONSerialization.WritingOptions(),
                                                          error: &error)
                        outputStream.close()
                        print("Done!")
                    }
                    seal.fulfill(())
                }.catch { error in
                    seal.reject(error)
                }
            } else {
                seal.fulfill(())
            }
        }
    }
    
    private func saveRulings() -> Promise<Void> {
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

    private func parseData(fromLines lines: [String], startLine: String, endLine: String, includeStartLine: Bool, includeEndLine: Bool) -> String? {
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
    
    private func parseRules(fromLines lines: [String]) {
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
    
    private func findParent(forRule rule: CMRule, withTerm term: String) -> CMRule? {
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
    
    private func parseGlossary(fromLines lines: [String], parent: CMRule?) {
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
    
    // MARK: Cleanup
    private func removeIDs()  {
        let cards = realm.objects(CMCard.self).filter("id != nil")
        var count = 0
        print("Removing ID: \(count)/\(cards.count) \(Date())")
        
        try! realm.write {
            for card in cards {
                card.id = nil
                realm.add(card)
                
                count += 1
                if count % printMilestone == 0 {
                    print("Removing ID: \(count)/\(cards.count) \(Date())")
                }
            }
        }
    }
}
