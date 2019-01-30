//
//  Maintainer.swift
//  ManaKit_Example
//
//  Created by Jovito Royeca on 23/10/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import ManaKit
import PromiseKit
import SSZipArchive
import RealmSwift

class Maintainer: NSObject {
    // MARK: Constants
    let printMilestone = 1000
    let cardsFileName   = "scryfall-all-cards.json"
    let rulingsFileName = "scryfall-rulings.json"
    let comprehensiveRulesFileName = "MagicCompRules 20190125.txt"
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

    func compactDatabase() {
        print("Compacting database...")
        let path = "\(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])"
        let compactFile = "\(path)/ManaKit.realm"
        let zipFile = "\(compactFile).zip"
        
        if FileManager.default.fileExists(atPath: compactFile) {
            try! FileManager.default.removeItem(atPath: compactFile)
        }
        if FileManager.default.fileExists(atPath: zipFile) {
            try! FileManager.default.removeItem(atPath: zipFile)
        }
        
        try! realm.writeCopy(toFile: URL(fileURLWithPath: compactFile))
        SSZipArchive.createZipFile(atPath: zipFile,
                                   withFilesAtPaths: [compactFile])
        print("Done.")
    }
    
    func unpackScryfallData() {
        guard let cardsPath = Bundle.main.path(forResource: cardsFileName,
                                               ofType: "zip",
                                               inDirectory: "data"),
            let rulingsPath = Bundle.main.path(forResource: rulingsFileName,
                                               ofType: "zip",
                                               inDirectory: "data"),
            let cachePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first else {
            return
        }
        
        var willCopy = true
        
        if let scryfallDate = UserDefaults.standard.string(forKey: ManaKit.UserDefaultsKeys.ScryfallDate) {
            if scryfallDate == ManaKit.Constants.ScryfallDate {
                willCopy = false
            }
        }
        
        if willCopy {
            print("Extracting Scryfall files: \(ManaKit.Constants.ScryfallDate)")
            
            // Remove old database files in docs directory
            for file in try! FileManager.default.contentsOfDirectory(atPath: cachePath) {
                let path = "\(cachePath)/\(file)"
                if file.hasPrefix("scryfall-") {
                    try! FileManager.default.removeItem(atPath: path)
                }
            }
            
            // Unzip
            SSZipArchive.unzipFile(atPath: cardsPath,
                                   toDestination: cachePath)
            SSZipArchive.unzipFile(atPath: rulingsPath,
                                   toDestination: cachePath)
            
            UserDefaults.standard.set(ManaKit.Constants.ScryfallDate,
                                      forKey: ManaKit.UserDefaultsKeys.ScryfallDate)
            UserDefaults.standard.synchronize()
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
    func findSet(code: String) -> CMSet? {
        if cachedSets.isEmpty {
            for object in realm.objects(CMSet.self) {
                cachedSets.append(object)
            }
        }

        return cachedSets.first(where: { $0.code == code})
    }

    func findLanguage(with code: String) -> CMLanguage? {
        if code.isEmpty {
            return nil
        }

        if cachedLanguages.isEmpty {
            for object in realm.objects(CMLanguage.self) {
                cachedLanguages.append(object)
            }
        }
        
        if let language = cachedLanguages.first(where: { $0.code == code}) {
            return language
        } else {
            let language = CMLanguage()
            
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
    
    func findCardType(with name: String, language: CMLanguage) -> CMCardType? {
        if name.isEmpty {
            return nil
        }
        if cachedCardTypes.isEmpty {
            for object in realm.objects(CMCardType.self) {
                cachedCardTypes.append(object)
            }
        }
        
        if let type = cachedCardTypes.first(where: { $0.name == name}) {
            return type
        } else {
            let type = CMCardType()
            
            type.name = name
            type.nameSection = sectionFor(name: name)
            type.language = language

            cachedCardTypes.append(type)
            return type
        }
    }
    
    func findCardColor(with symbol: String) -> CMCardColor? {
        if symbol.isEmpty {
            return nil
        }
        if cachedCardColors.isEmpty {
            for object in realm.objects(CMCardColor.self) {
                cachedCardColors.append(object)
            }
        }
        
        if let color = cachedCardColors.first(where: { $0.symbol == symbol}) {
            return color
        } else {
            let color = CMCardColor()
                
            color.symbol = symbol
            switch symbol {
            case "B":
                color.name = "Black"
            case "U":
                color.name = "Blue"
            case "G":
                color.name = "Green"
            case "R":
                color.name = "Red"
            case "W":
                color.name = "White"
            default:
                ()
            }
            
            cachedCardColors.append(color)
            return color
        }
    }
    
    func findCardBorderColor(with name: String) -> CMCardBorderColor? {
        if name.isEmpty {
            return nil
        }
        if cachedBorderColors.isEmpty {
            for object in realm.objects(CMCardBorderColor.self) {
                cachedBorderColors.append(object)
            }
        }
        
        let capName = capitalize(string: name)
        
        if let borderColor = cachedBorderColors.first(where: { $0.name == capName}) {
            return borderColor
        } else {
            let borderColor = CMCardBorderColor()
                
            borderColor.name = capName
            borderColor.nameSection = sectionFor(name: name)
    
            cachedBorderColors.append(borderColor)
            return borderColor
        }
    }
    
    func findCardLayout(with name: String) -> CMCardLayout? {
        if name.isEmpty {
            return nil
        }
        if cachedLayouts.isEmpty {
            for object in realm.objects(CMCardLayout.self) {
                cachedLayouts.append(object)
            }
        }
        
        let capName = capitalize(string: name)
        
        if let layout = cachedLayouts.first(where: { $0.name == capName}) {
            return layout
        } else {
            let layout = CMCardLayout()
                
            layout.name = capName
            layout.nameSection = sectionFor(name: name)
            
            cachedLayouts.append(layout)
            return layout
        }
    }
    
    func findArtist(with name: String) -> CMCardArtist? {
        if name.isEmpty {
            return nil
        }
        if cachedArtists.isEmpty {
            for object in realm.objects(CMCardArtist.self) {
                cachedArtists.append(object)
            }
        }
        
        if let artist = cachedArtists.first(where: { $0.name == name}) {
            return artist
        } else {
            let artist = CMCardArtist()
                
            artist.name = name
            
            let names = name.components(separatedBy: " ")
            var nameSection: String?
            
            if names.count > 1 {
                if let lastName = names.last {
                    artist.lastName = lastName
                    nameSection = lastName
                }
                
                var firstName = ""
                for i in 0...names.count - 2 {
                    firstName.append("\(names[i])")
                    if i != names.count - 2 && names.count >= 3 {
                        firstName.append(" ")
                    }
                }
                artist.firstName = firstName
                
            } else {
                artist.firstName = names.first
                nameSection = artist.firstName
            }
            
            if let nameSection = nameSection {
                artist.nameSection = sectionFor(name: nameSection)
            }
            
            cachedArtists.append(artist)
            return artist
        }
    }
    
    func findCardFrame(with name: String) -> CMCardFrame? {
        if name.isEmpty {
            return nil
        }
        if cachedFrames.isEmpty {
            for object in realm.objects(CMCardFrame.self) {
                cachedFrames.append(object)
            }
        }
        
        let capName = capitalize(string: name)
        
        if let frame = cachedFrames.first(where: { $0.name == capName}) {
            return frame
        } else {
            let frame = CMCardFrame()
                
            frame.name = capName
            frame.nameSection = sectionFor(name: name)
            
            cachedFrames.append(frame)
            return frame
        }
    }
    
    func findCardFrameEffect(with name: String) -> CMCardFrameEffect? {
        if name.isEmpty {
            return nil
        }
        if cachedFrameEffects.isEmpty {
            for object in realm.objects(CMCardFrameEffect.self) {
                cachedFrameEffects.append(object)
            }
        }

        let capName = capitalize(string: name)
        
        if let frame = cachedFrameEffects.first(where: { $0.name == capName}) {
            return frame
        } else {
            let frame = CMCardFrameEffect()
                
            frame.name = capName
            frame.nameSection = sectionFor(name: name)

            cachedFrameEffects.append(frame)
            return frame
        }
    }
    
    func findRarity(with name: String) -> CMCardRarity? {
        if name.isEmpty {
            return nil
        }
        if cachedRarities.isEmpty {
            for object in realm.objects(CMCardRarity.self) {
                cachedRarities.append(object)
            }
        }
        
        let capName = capitalize(string: name)
        
        if let rarity = cachedRarities.first(where: { $0.name == capName}) {
            return rarity
        } else {
            let rarity = CMCardRarity()
                
            rarity.name = capName
            rarity.nameSection = sectionFor(name: name)

            cachedRarities.append(rarity)
            return rarity
        }
    }
    
    func findCardWatermark(with name: String) -> CMCardWatermark? {
        if name.isEmpty {
            return nil
        }
        if cachedWatermarks.isEmpty {
            for object in realm.objects(CMCardWatermark.self) {
                cachedWatermarks.append(object)
            }
        }
        
        let capName = capitalize(string: name)
        
        if let watermark = cachedWatermarks.first(where: { $0.name == capName}) {
            return watermark
        } else {
            let watermark = CMCardWatermark()
                
            watermark.name = capName
            watermark.nameSection = sectionFor(name: name)
            
            cachedWatermarks.append(watermark)
            return watermark
        }
    }
    
    func findFormat(with name: String) -> CMCardFormat? {
        if name.isEmpty {
            return nil
        }
        if cachedFormats.isEmpty {
            for object in realm.objects(CMCardFormat.self) {
                cachedFormats.append(object)
            }
        }

        let capName = capitalize(string: name)
        
        if let format = cachedFormats.first(where: { $0.name == capName}) {
            return format
        } else {
            let format = CMCardFormat()
                
            format.name = capName
            format.nameSection = sectionFor(name: name)

            cachedFormats.append(format)
            return format
        }
    }
    
    func findLegality(with name: String) -> CMLegality? {
        if name.isEmpty {
            return nil
        }
        if cachedLegalities.isEmpty {
            for object in realm.objects(CMLegality.self) {
                cachedLegalities.append(object)
            }
        }

        let capName = capitalize(string: name)
        
        if let legality = cachedLegalities.first(where: { $0.name == capName}) {
            return legality
        } else {
            let legality = CMLegality()
                
            legality.name = capName
            legality.nameSection = sectionFor(name: name)

            cachedLegalities.append(legality)
            return legality
        }
    }
    
    func findRuling(withDate date: String, andText text: String) -> CMRuling? {
        if date.isEmpty && text.isEmpty {
            return nil
        }
        if cachedRulings.isEmpty {
            for object in realm.objects(CMRuling.self) {
                cachedRulings.append(object)
            }
        }
        
        if let ruling = cachedRulings.first(where: { $0.date == date && $0.text == text }) {
            return ruling
        } else {
            let ruling = CMRuling()
                
            ruling.date = date
            ruling.text = text

            cachedRulings.append(ruling)
            return ruling
        }
    }
}
