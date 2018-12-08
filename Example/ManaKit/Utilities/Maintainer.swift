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
    let cardsFileName   = "scryfall-all-cards"
    let rulingsFileName = "scryfall-rulings"
    let comprehensiveRulesFileName = "MagicCompRules 20181005"
    var dataStack =  ManaKit.sharedInstance.dataStack
    var context = ManaKit.sharedInstance.dataStack!.mainContext
    var useInMemoryDatabase = true
    
        // MARK: Variables
    var dateStart = Date()
    var cachedLanguages = [CMLanguage]()
    var cachedCardTypes = [CMCardType]()
    
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
    
    // MARK: Object finders
    func findLanguage(with code: String) -> CMLanguage? {
        if code.isEmpty {
            return nil
        }
        
        if let language = cachedLanguages.first(where: { $0.code == code}) {
            return language
        } else {
            if let desc = NSEntityDescription.entity(forEntityName: "CMLanguage", in: context),
                let language = NSManagedObject(entity: desc, insertInto: context) as? CMLanguage {
                
                language.code = code
                switch code {
                case "en":
                    language.name = "English"
                    language.displayCode = "EN"
                case "es":
                    language.name = "Spanish"
                    language.displayCode = "ES"
                case "fr":
                    language.name = "French"
                    language.displayCode = "FR"
                case "de":
                    language.name = "German"
                    language.displayCode = "DE"
                case "it":
                    language.name = "Italian"
                    language.displayCode = "IT"
                case "pt":
                    language.name = "Portuguese"
                    language.displayCode = "PT"
                case "ja":
                    language.name = "Japanese"
                    language.displayCode = "JA"
                case "ko":
                    language.name = "Korean"
                    language.displayCode = "KO"
                case "ru":
                    language.name = "Russian"
                    language.displayCode = "RU"
                case "zhs":
                    language.name = "Simplified Chinese"
                    language.displayCode = "汉语"
                case "zht":
                    language.name = "Traditional Chinese"
                    language.displayCode = "漢語"
                case "he":
                    language.name = "Hebrew"
                case "la":
                    language.name = "Latin"
                case "grc":
                    language.name = "Ancient Greek"
                case "ar":
                    language.name = "Arabic"
                case "sa":
                    language.name = "Sanskrit"
                case "px":
                    language.name = "Phyrexian"
                default:
                    ()
                }
                if let name = language.name {
                    language.nameSection = sectionFor(name: name)
                }
                
                cachedLanguages.append(language)
                return language
            }
        }
        
        return nil
    }
    
    func findCardType(with name: String, language: CMLanguage) -> CMCardType? {
        if name.isEmpty {
            return nil
        }
        
        if let type = cachedCardTypes.first(where: { $0.name == name}) {
            return type
        } else {
            if let desc = NSEntityDescription.entity(forEntityName: "CMCardType", in: context),
                let type = NSManagedObject(entity: desc, insertInto: context) as? CMCardType {
                
                type.name = name
                type.nameSection = sectionFor(name: name)
                type.language = language
                
                cachedCardTypes.append(type)
                return type
            }
        }
        
        return nil
    }
}
