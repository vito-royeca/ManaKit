//
//  Maintainer+Rules.swift
//  ManaKit_Example
//
//  Created by Jovito Royeca on 23/10/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import ManaKit
import PromiseKit
import SwiftKuery
import SwiftKueryPostgreSQL

extension Maintainer {
    func rulesData() -> [String] {
        guard let path = Bundle.main.path(forResource: comprehensiveRulesFileName,
                                          ofType: "txt",
                                          inDirectory: "data") else {
            fatalError("Malformed data")
        }
        
        let data = try! String(contentsOfFile: path, encoding: .ascii)
        let lines = data.components(separatedBy: .newlines)
        
        return lines
    }
    
    func filterRules(lines: [String], connection: PostgreSQLConnection) -> [()->Promise<Void>] {
        var rules = [[String: Any]]()
        var id = 0
        
        var startLine:String? = nil
        var endLine:String? = nil
        var includeStartLine = false
        var includeEndLine = false
        
        // Introduction
        rules.append(["term": "Introduction",
                      "order": 0,
                      "id": id])
        
        // Greetings
        startLine = "Magic: The Gathering Comprehensive Rules"
        endLine = "Contents"
        includeStartLine = true
        includeEndLine = false
        id = id + 1
        if let text = parseData(fromLines: lines,
                                startLine: startLine!,
                                endLine: endLine!,
                                includeStartLine: includeStartLine,
                                includeEndLine: includeEndLine) {
            rules.append(["definition": text,
                          "order": 0.1,
                          "parent": 0,
                          "id": id])
        }
        
        // Rules
        rules.append(contentsOf: parseRules(fromLines: lines, startId: id))
        
        // Glossary
        id = rules.count + 2
        rules.append(["term": "Glossary",
                      "order": 10000,
                      "id": id])
        rules.append(contentsOf: parseGlossary(fromLines: lines, startId: id, parent: id))
        
        // Credits
        id = rules.count + 2
        rules.append(["term": "Credits",
                      "order": 11000,
                      "id": id])
        
        startLine = "Magic: The Gathering Original Game Design: Richard Garfield"
        endLine = "Published by Wizards of the Coast LLC"
        includeStartLine = true
        includeEndLine = true
        if let text = parseData(fromLines: lines,
                                startLine: startLine!,
                                endLine: endLine!,
                                includeStartLine: includeStartLine,
                                includeEndLine: includeEndLine) {
            rules.append(["definition": text,
                          "order": 11000.1,
                          "parent": id,
                          "id": id + 2])
        }
        
        
        let promises: [()->Promise<Void>] = rules.map { dict in
            return {
                return self.createRulePromise(dict: dict,
                                              connection: connection)
            }
        }
        
        return promises
    }
    
    func createDeleteRulesPromise(connection: PostgreSQLConnection) -> Promise<Void> {
        let query = "DELETE FROM cmrule"
        return createPromise(with: query,
                             parameters: nil,
                             connection: connection)
    }
    
    func createRulePromise(dict: [String: Any], connection: PostgreSQLConnection) -> Promise<Void> {
        let term = dict["term"] ?? "null"
        let termSection = dict["termSection"] ?? "null"
        let definition = dict["definition"] ?? "null"
        let order = dict["order"] ?? Double(0)
        let parent = dict["parent"] ?? -1
        let id = dict["id"] ?? 0
        let query = "SELECT createOrUpdateRule($1,$2,$3,$4,$5,$6)"
        let parameters = [term,
                          termSection,
                          definition,
                          order,
                          parent,
                          id] as [Any]
        
        return createPromise(with: query,
                             parameters: parameters,
                             connection: connection)
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
    
    private func parseRules(fromLines lines: [String], startId: Int) -> [[String: Any]] {
        var rules = [[String: Any]]()
        var id = startId + 1
        
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

                    id = id + 1
                    var rule = ["term": term,
                                "definition": definition,
                                "order": order(of: term),
                                "id": id] as [String: Any]
                    
                    if term.contains(".") {
                        if let term = term.components(separatedBy: ".").first,
                            let parent = findParent(of: term, from: rules) {
                            rule["parent"] = parent
                        }
                        
                    } else {
                        while term != "" {
                            term.remove(at: term.index(before: term.endIndex))
                            
                            if term.count > 0 {
                                if let parent = findParent(of: term, from: rules) {
                                    rule["parent"] = parent
                                    break
                                }
                            }
                        }
                    }
                    
                    rules.append(rule)
                }
            }
        }
        
        return rules
    }
    
    private func findParent(of term: String, from rules: [[String: Any]]) -> Int? {
        for rule in rules {
            if let x = rule["term"] as? String,
                term == x {
                return rule["id"] as? Int
            }
        }
        
        return nil
    }
    
    private func parseGlossary(fromLines lines: [String], startId: Int, parent: Int?) -> [[String: Any]] {
        var rules = [[String: Any]]()
        var id = startId + 1
        
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
                        var nextLine = lines[lines.firstIndex(of: lastDefinition!)! + 1]
                        if nextLine == "" {
                            nextLine = lines[lines.firstIndex(of: lastDefinition!)! + 2]
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
                            let letters = CharacterSet.letters
                            var prefix = String(term!.prefix(1))
                            if prefix.rangeOfCharacter(from: letters) == nil {
                                prefix = "#"
                            }
                            
                            let rule = ["term": term ?? "null",
                                        "termSection": prefix,
                                        "definition": definition ?? "null",
                                        "parent": parent ?? 0,
                                        "id": id] as [String: Any]
                            rules.append(rule)
                            
                            term = nil
                            definition = nil
                            lastDefinition = nil
                            id = id + 1
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
        
        return rules
    }
}
