//
//  DatabaseMaintainer.swift
//  ManaKit
//
//  Created by Jovito Royeca on 12/04/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import DATAStack
import Kanna
import ManaKit
import SSZipArchive
import Sync

extension Character
{
    func unicodeScalarCodePoint() -> UInt32
    {
        let characterString = String(self)
        let scalars = characterString.unicodeScalars
        
        return scalars[scalars.startIndex].value
    }
}

class DatabaseMaintainer: NSObject {
    // MARK: - Shared Instance
    static let sharedInstance = DatabaseMaintainer()
    
    // MARK: Constants
//    let setCodesForProcessing:[String]? = ["DOM"]
    let setCodesForProcessing:[String]? = nil
    let printMilestone = 1000
    
    // MARK: Core Data updates 1
    func json2CoreData() {
        let dateStart = Date()

        if let path = Bundle.main.path(forResource: "AllSets-x.json", ofType: "zip", inDirectory: "data"),
            let docsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first {

            let jsonPath = "\(docsPath)/AllSets-x.json"
            SSZipArchive.unzipFile(atPath: path, toDestination: docsPath)

            if FileManager.default.fileExists(atPath: jsonPath) {
                let data = try! Data(contentsOf: URL(fileURLWithPath: jsonPath))

                if let jsonDictionary = try! JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: [String: Any]] {
                    let notifName = NSNotification.Name.NSManagedObjectContextObjectsDidChange
                    var dictionary = [[String: Any]]()
                    
                    for (key,value) in jsonDictionary {
                        var bWillAdd = false

                        if let setCodesForProcessing = setCodesForProcessing {
                            for setCode in setCodesForProcessing {
                                if key == setCode {
                                    bWillAdd = true
                                }
                            }
                        } else {
                            bWillAdd = true
                        }

                        if bWillAdd {
                            dictionary.append(value)
                        }
                    }
                    
                    ManaKit.sharedInstance.dataStack?.performInNewBackgroundContext { backgroundContext in
                        NotificationCenter.default.addObserver(self, selector: #selector(DatabaseMaintainer.changeNotification(_:)), name: notifName, object: backgroundContext)
                        Sync.changes(dictionary,
                                     inEntityNamed: "CMSet",
                                     predicate: nil,
                                     parent: nil,
                                     parentRelationship: nil,
                                     inContext: backgroundContext,
                                     operations: .all,
                                     completion:  { error in
                                        NotificationCenter.default.removeObserver(self, name:notifName, object: nil)

                                        // system
                                        self.updateSystem()
                                        
                                        // json
                                        var dateEnd = Date()
                                        var timeDifference = dateEnd.timeIntervalSince(dateStart)
                                        print("Time Elapsed: \(dateStart) - \(dateEnd) = \(self.format(timeDifference))")

                                        // sets
                                        var tmpDateStart = Date()
                                        self.updateSets()
                                        dateEnd = Date()
                                        timeDifference = dateEnd.timeIntervalSince(tmpDateStart)
                                        print("Time Elapsed: \(tmpDateStart) - \(dateEnd) = \(self.format(timeDifference))")

                                        // cards
                                        tmpDateStart = Date()
                                        self.updateCards()
                                        dateEnd = Date()
                                        timeDifference = dateEnd.timeIntervalSince(tmpDateStart)
                                        print("Time Elapsed: \(tmpDateStart) - \(dateEnd) = \(self.format(timeDifference))")

                                        // variations
                                        tmpDateStart = Date()
                                        self.updateVariations()
                                        dateEnd = Date()
                                        timeDifference = dateEnd.timeIntervalSince(tmpDateStart)
                                        print("Time Elapsed: \(tmpDateStart) - \(dateEnd) = \(self.format(timeDifference))")

                                        // printings
                                        tmpDateStart = Date()
                                        self.updatePrintings()
                                        dateEnd = Date()
                                        timeDifference = dateEnd.timeIntervalSince(tmpDateStart)
                                        print("Time Elapsed: \(tmpDateStart) - \(dateEnd) = \(self.format(timeDifference))")

                                        // rulings
                                        tmpDateStart = Date()
                                        self.updateRulings()
                                        dateEnd = Date()
                                        timeDifference = dateEnd.timeIntervalSince(tmpDateStart)
                                        print("Time Elapsed: \(tmpDateStart) - \(dateEnd) = \(self.format(timeDifference))")

                                        dateEnd = Date()
                                        timeDifference = dateEnd.timeIntervalSince(dateStart)
                                        print("Total Time Elapsed: \(dateStart) - \(dateEnd) = \(self.format(timeDifference))")
                                        print("docsPath = \(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])")
                        })
                    }
                }
            }
        }
    }
    
    func updateTCGPlayerName() {
        let request:NSFetchRequest<CMSet> = CMSet.fetchRequest() as! NSFetchRequest<CMSet>
        var tcgPlayerNameDict:[String: String]?
        
        if let path = Bundle.main.path(forResource: "TCGPlayerName", ofType: "plist", inDirectory: "data") {
            if FileManager.default.fileExists(atPath: path) {
                let data = try! Data(contentsOf: URL(fileURLWithPath: path))
                
                tcgPlayerNameDict = try! PropertyListSerialization.propertyList(from: data, options: [], format: nil) as? [String: String]
            }
        }
        
        request.predicate = NSPredicate(format: "tcgPlayerName == nil")
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        if let sets = try! ManaKit.sharedInstance.dataStack?.mainContext.fetch(request) {
            print("Updating TCGPLayer Names: \(sets.count)")
            
            for set in sets {
                print("\(set.code!) - \(set.name!)")

                if let tcgPlayerNameDict = tcgPlayerNameDict,
                    let code = set.code {
                    set.tcgPlayerName = tcgPlayerNameDict[code]
                }
                
                try! ManaKit.sharedInstance.dataStack?.mainContext.save()
            }
            print("Done")
        }
    }
    
    func updateKeyruneCode() {
        let request:NSFetchRequest<CMSet> = CMSet.fetchRequest() as! NSFetchRequest<CMSet>
        var keyruneDict:[String: String]?
        
        if let path = Bundle.main.path(forResource: "Keyrune", ofType: "plist", inDirectory: "data") {
            if FileManager.default.fileExists(atPath: path) {
                let data = try! Data(contentsOf: URL(fileURLWithPath: path))
                
                keyruneDict = try! PropertyListSerialization.propertyList(from: data, options: [], format: nil) as? [String: String]
            }
        }
        
        request.predicate = NSPredicate(format: "keyruneCode == nil")
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        if let sets = try! ManaKit.sharedInstance.dataStack?.mainContext.fetch(request) {
            print("Updating Keyrune codes: \(sets.count)")
            
            for set in sets {
                print("\(set.code!) - \(set.name!)")
                
                if let keyruneDict = keyruneDict,
                    let code = set.code {
                    set.keyruneCode = keyruneDict[code.lowercased()]
                }
                
                try! ManaKit.sharedInstance.dataStack?.mainContext.save()
            }
            print("Done")
        }
    }
    
    public func updateSystem() {
        // delete existing data first
        let request:NSFetchRequest<CMSystem> = CMSystem.fetchRequest() as! NSFetchRequest<CMSystem>
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request as! NSFetchRequest<NSFetchRequestResult>)
        try! ManaKit.sharedInstance.dataStack?.persistentStoreCoordinator.execute(deleteRequest, with: (ManaKit.sharedInstance.dataStack?.mainContext)!)
        
        let objectFinder = ["version": kMTGJSONVersion] as [String: AnyObject]
        if let system = ManaKit.sharedInstance.findOrCreateObject("CMSystem", objectFinder: objectFinder) as? CMSystem {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            
            system.version = kMTGJSONVersion
            system.date = NSDate(timeIntervalSince1970: formatter.date(from: kMTGJSONDate)!.timeIntervalSince1970)
            try! ManaKit.sharedInstance.dataStack?.mainContext.save()
        }
    }
    
    public func updateSets() {
        let request:NSFetchRequest<CMSet> = CMSet.fetchRequest() as! NSFetchRequest<CMSet>
        
        if let sets = try! ManaKit.sharedInstance.dataStack?.mainContext.fetch(request) {
            print("Updating sets: \(sets.count)")
            
            for set in sets {
                // border
                if let border = set.border {
                    let objectFinder = ["name": border] as [String: AnyObject]
                    if let object = ManaKit.sharedInstance.findOrCreateObject("CMBorder", objectFinder: objectFinder) as? CMBorder {
                        object.name = border
                        set.border = nil
                        set.border_ = object
                    }
                }
                
                // type
                if let type = set.type {
                    let objectFinder = ["name": type] as [String: AnyObject]
                    if let object = ManaKit.sharedInstance.findOrCreateObject("CMSetType", objectFinder: objectFinder) as? CMSetType {
                        object.name = type
                        set.type = nil
                        set.type_ = object
                    }
                }
                
                // block
                if let block = set.block {
                    let objectFinder = ["name": block] as [String: AnyObject]
                    if let object = ManaKit.sharedInstance.findOrCreateObject("CMBlock", objectFinder: objectFinder) as? CMBlock {
                        object.name = block
                        set.block = nil
                        set.block_ = object
                    }
                }
                
                // booster
                if let booster = set.booster {
                    if let boosterArray = NSKeyedUnarchiver.unarchiveObject(with: booster as Data) as? [String] {
                        var boosterDict = [CMBooster: Int]()
                        
                        for booster in boosterArray {
                            let objectFinder = ["name": booster] as [String: AnyObject]
                            if let object = ManaKit.sharedInstance.findOrCreateObject("CMBooster", objectFinder: objectFinder) as? CMBooster {
                                object.name = booster
                                
                                if let value = boosterDict[object] {
                                    boosterDict[object] = value + 1
                                } else {
                                    boosterDict[object] = 1
                                }
                            }
                        }
                        
                        for (key,value) in boosterDict {
                            if let object = ManaKit.sharedInstance.findOrCreateObject("CMSetBooster", objectFinder: nil) as? CMSetBooster {
                                object.booster = key
                                object.set = set
                                object.count = Int32(value)
                                object.id = Int64("\(key)_\(set.code!)_\(value)".hashValue)
                            }
                        }
                    }
                    
                    set.booster = nil
                }
                
                // nameSection
                let letters = CharacterSet.letters
                var prefix = String(set.name!.prefix(1))
                if prefix.rangeOfCharacter(from: letters) == nil {
                    prefix = "#"
                }
                set.nameSection = prefix.uppercased().folding(options: .diacriticInsensitive, locale: .current)
                
                // typeSection
                prefix = String(set.type_!.name!.prefix(1))
                let rest = String(set.type_!.name!.dropFirst())
                set.typeSection = "\(prefix.uppercased())\(rest)"
                
                // yearSection
                prefix = String(set.releaseDate!.prefix(4))
                set.yearSection = prefix
                
                try! ManaKit.sharedInstance.dataStack?.mainContext.save()
            }
        }
    }
    
    public func updateCards() {
        let request:NSFetchRequest<CMCard> = CMCard.fetchRequest() as! NSFetchRequest<CMCard>
        
        if let cards = try! ManaKit.sharedInstance.dataStack?.mainContext.fetch(request) {
            let letters = CharacterSet.letters
            var cachedLayouts = [CMLayout]()
            var cachedColors = [CMColor]()
            var cachedCardTypes = [CMCardType]()
            var cachedRarities = [CMRarity]()
            var cachedArtists = [CMArtist]()
            var cachedWatermarks = [CMWatermark]()
            var cachedBorders = [CMBorder]()
            
            var count = 0
            print("Updating cards: \(count)/\(cards.count) \(Date())")
            
            for card in cards {
                // id
                let cardID = "\(card.set!.code!)_\(card.name!)_\(card.imageName!)".replacingOccurrences(of: ".", with: "-")
                card.id = cardID
                
                // layout
                if let layout = card.layout {
                    if let object = cachedLayouts.first(where: { $0.name == layout }) {
                        card.layout_ = object
                    } else {
                        let objectFinder = ["name": layout] as [String: AnyObject]
                        if let object = ManaKit.sharedInstance.findOrCreateObject("CMLayout", objectFinder: objectFinder) as? CMLayout {
                            object.name = layout
                            card.layout_ = object
                            cachedLayouts.append(object)
                        }
                    }
                    
                    card.layout = nil
                }
                
                // colors
                if let colors = card.colors {
                    let colors_ = card.mutableSetValue(forKey: "colors_")
                    
                    if let colorsArray = NSKeyedUnarchiver.unarchiveObject(with: colors as Data) as? [String] {
                        for color in colorsArray {
                            if let object = cachedColors.first(where: { $0.name == color }) {
                                colors_.add(object)
                            } else {
                                let objectFinder = ["name": color] as [String: AnyObject]
                                if let object = ManaKit.sharedInstance.findOrCreateObject("CMColor", objectFinder: objectFinder) as? CMColor {
                                    object.name = color
                                    var prefix = String(color.prefix(1))
                                    
                                    if color == "Blue" {
                                        prefix = "U"
                                    }
                                    object.symbol = prefix
                                    colors_.add(object)
                                    cachedColors.append(object)
                                }
                            }
                        }
                    }
                    
                    card.colors = nil
                }
                
                // colorIdentity
                if let colorIdentity = card.colorIdentity {
                    let colorIdentities_ = card.mutableSetValue(forKey: "colorIdentities_")
                    
                    if let coloridentityArray = NSKeyedUnarchiver.unarchiveObject(with: colorIdentity as Data) as? [String] {
                        for symbol in coloridentityArray {
                            if let object = cachedColors.first(where: { $0.symbol == symbol }) {
                                colorIdentities_.add(object)
                            } else {
                                let objectFinder = ["symbol": colorIdentity] as [String: AnyObject]
                                if let object = ManaKit.sharedInstance.findOrCreateObject("CMColor", objectFinder: objectFinder) as? CMColor {
                                    if symbol == "B" {
                                        object.name = "Black"
                                    } else if symbol == "U" {
                                        object.name = "Blue"
                                    } else if symbol == "G" {
                                        object.name = "Green"
                                    } else if symbol == "R" {
                                        object.name = "Red"
                                    } else if symbol == "W" {
                                        object.name = "White"
                                    }
                                    object.symbol = symbol
                                    colorIdentities_.add(object)
                                    cachedColors.append(object)
                                }
                            }
                        }
                    }
                    
                    card.colorIdentity = nil
                }
                
                // type
                if let type = card.type {
                    if let object = cachedCardTypes.first(where: { $0.name == type }) {
                        card.type_ = object
                    } else {
                        let objectFinder = ["name": type] as [String: AnyObject]
                        if let object = ManaKit.sharedInstance.findOrCreateObject("CMCardType", objectFinder: objectFinder) as? CMCardType {
                            object.name = type
                            card.type_ = object
                            cachedCardTypes.append(object)
                        }
                    }
                    
                    card.type = nil
                }
                
                // supertypes
                if let supertypes = card.supertypes {
                    let supertypes_ = card.mutableSetValue(forKey: "supertypes_")
                    
                    if let supertypesArray = NSKeyedUnarchiver.unarchiveObject(with: supertypes as Data) as? [String] {
                        for supertype in supertypesArray {
                            if let object = cachedCardTypes.first(where: { $0.name == supertype }) {
                                supertypes_.add(object)
                            } else {
                                let objectFinder = ["name": supertype] as [String: AnyObject]
                                if let object = ManaKit.sharedInstance.findOrCreateObject("CMCardType", objectFinder: objectFinder) as? CMCardType {
                                    object.name = supertype
                                    supertypes_.add(object)
                                    cachedCardTypes.append(object)
                                }
                            }
                        }
                    }
                    
                    card.supertypes = nil
                }
                
                // types
                if let types = card.types {
                    let types_ = card.mutableSetValue(forKey: "types_")
                    
                    if let typesArray = NSKeyedUnarchiver.unarchiveObject(with: types as Data) as? [String] {
                        var typeSection = ""
                        
                        for type in typesArray {
                            if let object = cachedCardTypes.first(where: { $0.name == type }) {
                                types_.add(object)
                                
                                if typeSection.count == 0 {
                                    typeSection.append(object.name!)
                                } else {
                                    typeSection.append(" \(object.name!)")
                                }
                                
                            } else {
                                let objectFinder = ["name": type] as [String: AnyObject]
                                if let object = ManaKit.sharedInstance.findOrCreateObject("CMCardType", objectFinder: objectFinder) as? CMCardType {
                                    object.name = type
                                    types_.add(object)
                                    cachedCardTypes.append(object)
                                    
                                    if typeSection.count == 0 {
                                        typeSection.append(object.name!)
                                    } else {
                                        typeSection.append(" \(object.name!)")
                                    }
                                }
                            }
                        }
                        
                        card.typeSection = typeSection
                    }
                    
                    card.types = nil
                }
                
                // subtypes
                if let subtypes = card.subtypes {
                    let subtypes_ = card.mutableSetValue(forKey: "subtypes_")
                    
                    if let subtypesArray = NSKeyedUnarchiver.unarchiveObject(with: subtypes as Data) as? [String] {
                        for subtype in subtypesArray {
                            if let object = cachedCardTypes.first(where: { $0.name == subtype }) {
                                subtypes_.add(object)
                            } else {
                                let objectFinder = ["name": subtype] as [String: AnyObject]
                                if let object = ManaKit.sharedInstance.findOrCreateObject("CMCardType", objectFinder: objectFinder) as? CMCardType {
                                    object.name = subtype
                                    subtypes_.add(object)
                                    cachedCardTypes.append(object)
                                }
                            }
                        }
                    }
                    
                    card.subtypes = nil
                }
                
                // rarity
                if let rarity = card.rarity {
                    if let object = cachedRarities.first(where: { $0.name == rarity }) {
                        card.rarity_ = object
                    } else {
                        let objectFinder = ["name": rarity] as [String: AnyObject]
                        if let object = ManaKit.sharedInstance.findOrCreateObject("CMRarity", objectFinder: objectFinder) as? CMRarity {
                            object.name = rarity
                            card.rarity_ = object
                            cachedRarities.append(object)
                        }
                    }
                    
                    card.rarity = nil
                }
                
                // artist
                if let artist = card.artist {
                    if let object = cachedArtists.first(where: { $0.name == artist }) {
                        card.artist_ = object
                    } else {
                        let objectFinder = ["name": artist] as [String: AnyObject]
                        if let object = ManaKit.sharedInstance.findOrCreateObject("CMArtist", objectFinder: objectFinder) as? CMArtist {
                            
                            let names = artist.components(separatedBy: " ")
                            var nameSection: String?
                            
                            if names.count > 1 {
                                if let lastName = names.last {
                                    object.lastName = lastName
                                    nameSection = object.lastName
                                }
                                
                                var firstName = ""
                                for i in 0...names.count - 2 {
                                    firstName.append("\(names[i])")
                                    if i != names.count - 2 && names.count >= 3 {
                                        firstName.append(" ")
                                    }
                                }
                                object.firstName = firstName
                                
                            } else {
                                object.firstName = names.first
                                nameSection = object.firstName
                            }
                            
                            if let nameSection = nameSection {
                                var prefix = String(nameSection.prefix(1))
                                
                                if prefix.rangeOfCharacter(from: letters) == nil {
                                    prefix = "#"
                                }
                                object.nameSection = prefix.uppercased().folding(options: .diacriticInsensitive, locale: .current)
                            }
                            
                            object.name = artist
                            
                            card.artist_ = object
                            cachedArtists.append(object)
                        }
                    }
                    
                    card.artist = nil
                }
                
                // watermark
                if let watermark = card.watermark {
                    if let object = cachedWatermarks.first(where: { $0.name == watermark }) {
                        card.watermark_ = object
                    } else {
                        let objectFinder = ["name": watermark] as [String: AnyObject]
                        if let object = ManaKit.sharedInstance.findOrCreateObject("CMWatermark", objectFinder: objectFinder) as? CMWatermark {
                            object.name = watermark
                            card.watermark_ = object
                            cachedWatermarks.append(object)
                        }
                    }
                    
                    card.watermark = nil
                }
                
                // border
                if let border = card.border {
                    if let object = cachedBorders.first(where: { $0.name == border }) {
                        card.border_ = object
                    } else {
                        let objectFinder = ["name": border] as [String: AnyObject]
                        if let object = ManaKit.sharedInstance.findOrCreateObject("CMBorder", objectFinder: objectFinder) as? CMBorder {
                            object.name = border
                            card.border_ = object
                            cachedBorders.append(object)
                        }
                    }
                    
                    card.border = nil
                }
                
                // nameSection
                var prefix = String(card.name!.prefix(1))
                if prefix.rangeOfCharacter(from: letters) == nil {
                    prefix = "#"
                }
                card.nameSection = prefix.uppercased().folding(options: .diacriticInsensitive, locale: .current)
                
                // numberOrder
                if let number = card.number ?? card.mciNumber {
                    card.numberOrder = order(of: number)
                }
                
                try! ManaKit.sharedInstance.dataStack?.mainContext.save()
                
                count += 1
                if count % printMilestone == 0 {
                    print("Updating cards: \(count)/\(cards.count) \(Date())")
                }
            }
            
            print("Updating cards: \(count)/\(cards.count) \(Date())")
        }
    }

    func updateVariations() {
        let request:NSFetchRequest<CMCard> = CMCard.fetchRequest() as! NSFetchRequest<CMCard>
        let predicate = NSPredicate(format: "variations != nil")
        let sortDescriptors = [NSSortDescriptor(key: "set.releaseDate", ascending: true),
                               NSSortDescriptor(key: "name", ascending: true)]
        request.predicate = predicate
        request.sortDescriptors = sortDescriptors
        
        if let cards = try! ManaKit.sharedInstance.dataStack?.mainContext.fetch(request) {
            var count = 0
            print("Updating variations: \(count)/\(cards.count) \(Date())")
            
            for card in cards {
                if let variations = card.variations {
                    let variations_ = card.mutableSetValue(forKey: "variations_")
                    
                    if let variationsArray = NSKeyedUnarchiver.unarchiveObject(with: variations as Data) as? [Int] {
                        for variation in variationsArray {
                            if let object = cards.first(where: { $0.multiverseid == Int64(variation) }) {
                                variations_.add(object)
                            }
                        }
                    }
                    
                    card.variations = nil
                    try! ManaKit.sharedInstance.dataStack?.mainContext.save()
                }
                
                count += 1
                if count % printMilestone == 0 {
                    print("Updating variations: \(count)/\(cards.count) \(Date())")
                }
            }
            
            print("Updating variations: \(count)/\(cards.count) \(Date())")
        }
    }

    func updatePrintings() {
        let setRequest:NSFetchRequest<CMSet> = CMSet.fetchRequest() as! NSFetchRequest<CMSet>
        let cardRequest:NSFetchRequest<CMCard> = CMCard.fetchRequest() as! NSFetchRequest<CMCard>
        let predicate = NSPredicate(format: "printings != nil")
        let sortDescriptors = [NSSortDescriptor(key: "set.releaseDate", ascending: true),
                               NSSortDescriptor(key: "name", ascending: true)]
        cardRequest.predicate = predicate
        cardRequest.sortDescriptors = sortDescriptors
        
        if let cards = try! ManaKit.sharedInstance.dataStack?.mainContext.fetch(cardRequest),
            let sets = try! ManaKit.sharedInstance.dataStack?.mainContext.fetch(setRequest) {
            
            var count = 0
            print("Updating printings: \(count)/\(cards.count) \(Date())")
            
            for card in cards {
                if let printings = card.printings {
                    let printings_ = card.mutableSetValue(forKey: "printings_")
                    
                    if let printingsArray = NSKeyedUnarchiver.unarchiveObject(with: printings as Data) as? [String] {
                        for printing in printingsArray {
                            if let object = sets.first(where: { $0.code == printing }) {
                                printings_.add(object)
                            }
                        }
                    }
                    
                    card.printings = nil
                    try! ManaKit.sharedInstance.dataStack?.mainContext.save()
                }
                
                count += 1
                if count % printMilestone == 0 {
                    print("Updating printings: \(count)/\(cards.count) \(Date())")
                }
            }
            
            print("Updating printings: \(count)/\(cards.count) \(Date())")
        }
    }

    func updateRulings() {
        let request:NSFetchRequest<CMCard> = CMCard.fetchRequest() as! NSFetchRequest<CMCard>
        let predicate = NSPredicate(format: "rulings != nil")
        let sortDescriptors = [NSSortDescriptor(key: "set.releaseDate", ascending: true),
                               NSSortDescriptor(key: "name", ascending: true)]
        request.predicate = predicate
        request.sortDescriptors = sortDescriptors
        
        if let cards = try! ManaKit.sharedInstance.dataStack?.mainContext.fetch(request) {
            
            var count = 0
            print("Updating rulings: \(count)/\(cards.count) \(Date())")
            
            for card in cards {
                if let rulings = card.rulings {
                    let rulings_ = card.mutableSetValue(forKey: "rulings_")
                    
                    if let rulingsArray = NSKeyedUnarchiver.unarchiveObject(with: rulings as Data) as? [[String: AnyObject]] {
                        for ruling in rulingsArray {
                            if let object = ManaKit.sharedInstance.findOrCreateObject("CMRuling", objectFinder: nil) as? CMRuling {
                                object.date = ruling["date"] as? String
                                object.text = ruling["text"] as? String
                                object.card = card
                                object.id = Int64("\(card.id!)_\(object.date!)_\(object.text!)".hashValue)
                                rulings_.add(object)
                            }
                        }
                    }
                    
                    card.rulings = nil
                    try! ManaKit.sharedInstance.dataStack?.mainContext.save()
                }
                
                count += 1
                if count % printMilestone == 0 {
                    print("Updating rulings: \(count)/\(cards.count) \(Date())")
                }
            }
            
            print("Updating rulings: \(count)/\(cards.count) \(Date())")
        }
    }
    
    // MARK: Core Data updates 2
    func updateForeignNames() {
        let dateStart = Date()
        let request:NSFetchRequest<CMCard> = CMCard.fetchRequest() as! NSFetchRequest<CMCard>
        let predicate = NSPredicate(format: "foreignNames != nil")
        let sortDescriptors = [NSSortDescriptor(key: "set.releaseDate", ascending: true),
                               NSSortDescriptor(key: "name", ascending: true)]
        request.predicate = predicate
        request.sortDescriptors = sortDescriptors
        
        if let cards = try! ManaKit.sharedInstance.dataStack?.mainContext.fetch(request) {
            var cachedLanguages = [CMLanguage]()
            
            var count = 0
            print("Updating foreign names: \(count)/\(cards.count) \(Date())")
            
            for card in cards {
                if let foreignNames = card.foreignNames {
                    let foreignNames_ = card.mutableSetValue(forKey: "foreignNames_")
                    
                    if let foreignNamesArray = NSKeyedUnarchiver.unarchiveObject(with: foreignNames as Data) as? [[String: AnyObject]] {
                        for foreignName in foreignNamesArray {
                            var language:CMLanguage?
                            let name = foreignName["language"] as! String
                            
                            if let object = cachedLanguages.first(where: { $0.name == name }) {
                                language = object
                            } else {
                                let objectFinder = ["name": name] as [String: AnyObject]
                                if let object = ManaKit.sharedInstance.findOrCreateObject("CMLanguage", objectFinder: objectFinder) as? CMLanguage {
                                    object.name = name
                                    language = object
                                    cachedLanguages.append(language!)
                                }
                            }
                            
                            if let object = ManaKit.sharedInstance.findOrCreateObject("CMForeignName", objectFinder: nil) as? CMForeignName {
                                object.name = foreignName["name"] as? String
                                object.language = language
                                object.card = card
                                
                                var id = "\(card.id!)_\(object.name!)_\(object.language!.name!)"
                                if let multiverseid = foreignName["multiverseid"] as? String {
                                    object.multiverseid = Int64(multiverseid)!
                                    id += "_\(multiverseid)"
                                }
                                object.id = Int64(id.hashValue)
                                foreignNames_.add(object)
                            }
                        }
                    }
                    
                    card.foreignNames = nil
                    try! ManaKit.sharedInstance.dataStack?.mainContext.save()
                }
                
                count += 1
                if count % printMilestone == 0 {
                    print("Updating foreign names: \(count)/\(cards.count) \(Date())")
                }
            }
            
            print("Updating foreign names: \(count)/\(cards.count) \(Date())")
        }
        
        let dateEnd = Date()
        let timeDifference = dateEnd.timeIntervalSince(dateStart)
        print("Total Time Elapsed: \(dateStart) - \(dateEnd) = \(self.format(timeDifference))")
        print("docsPath = \(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])")
    }
    
    func updateLegalities() {
        let dateStart = Date()
        let request:NSFetchRequest<CMCard> = CMCard.fetchRequest() as! NSFetchRequest<CMCard>
        let predicate = NSPredicate(format: "legalities != nil")
        let sortDescriptors = [NSSortDescriptor(key: "set.releaseDate", ascending: true),
                               NSSortDescriptor(key: "name", ascending: true)]
        request.predicate = predicate
        request.sortDescriptors = sortDescriptors
        
        if let cards = try! ManaKit.sharedInstance.dataStack?.mainContext.fetch(request) {
            let letters = CharacterSet.letters
            var cachedFormats = [CMFormat]()
            var cachedLegalities = [CMLegality]()
            
            var count = 0
            print("Updating legalities: \(count)/\(cards.count) \(Date())")
            
            for card in cards {
                if let legalities = card.legalities {
                    let legalities_ = card.mutableSetValue(forKey: "cardLegalities_")
                    
                    if let legalitiesArray = NSKeyedUnarchiver.unarchiveObject(with: legalities as Data) as? [[String: AnyObject]] {
                        for legality in legalitiesArray {
                            let formatName = legality["format"] as! String
                            let legalName = legality["legality"] as! String
                            var format:CMFormat?
                            var legal:CMLegality?
                            
                            if let object = cachedFormats.first(where: { $0.name == formatName }) {
                                format = object
                            } else {
                                let objectFinder = ["name": formatName] as [String: AnyObject]
                                if let object = ManaKit.sharedInstance.findOrCreateObject("CMFormat", objectFinder: objectFinder) as? CMFormat {
                                    object.name = formatName
                                    
                                    // nameSection
                                    var prefix = String(formatName.prefix(1))
                                    if prefix.rangeOfCharacter(from: letters) == nil {
                                        prefix = "#"
                                    }
                                    object.nameSection = prefix.uppercased()
                                    
                                    format = object
                                    cachedFormats.append(format!)
                                }
                            }
                            
                            if let object = cachedLegalities.first(where: { $0.name == legalName }) {
                                legal = object
                            } else {
                                let objectFinder = ["name": legalName] as [String: AnyObject]
                                if let object = ManaKit.sharedInstance.findOrCreateObject("CMLegality", objectFinder: objectFinder) as? CMLegality {
                                    object.name = legalName
                                    legal = object
                                    cachedLegalities.append(legal!)
                                }
                            }
                            
                            if let object = ManaKit.sharedInstance.findOrCreateObject("CMCardLegality", objectFinder: nil) as? CMCardLegality {
                                object.format = format
                                object.legality = legal
                                object.card = card
                                object.id = Int64("\(card.id!)_\(object.format!.name!)_\(object.legality!.name!)".hashValue)
                                legalities_.add(object)
                            }
                        }
                    }
                    
                    card.legalities = nil
                    try! ManaKit.sharedInstance.dataStack?.mainContext.save()
                }
                
                count += 1
                if count % printMilestone == 0 {
                    print("Updating legalities: \(count)/\(cards.count) \(Date())")
                }
            }
            
            print("Updating legalities: \(count)/\(cards.count) \(Date())")
        }
        
        let dateEnd = Date()
        let timeDifference = dateEnd.timeIntervalSince(dateStart)
        print("Total Time Elapsed: \(dateStart) - \(dateEnd) = \(self.format(timeDifference))")
        print("docsPath = \(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])")
    }

    func rules2CoreData() {
        if let path = Bundle.main.path(forResource: "MagicCompRules 20180413", ofType: "txt", inDirectory: "data") {
            let dateStart = Date()
            
            print("Updating comprehensive rules: \(dateStart)")
            
            // delete existing data first
            let request:NSFetchRequest<CMRule> = CMRule.fetchRequest() as! NSFetchRequest<CMRule>
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: request as! NSFetchRequest<NSFetchRequestResult>)
            try! ManaKit.sharedInstance.dataStack?.persistentStoreCoordinator.execute(deleteRequest, with: (ManaKit.sharedInstance.dataStack?.mainContext)!)
            
            let data = try! String(contentsOfFile: path, encoding: .ascii)
            let lines = data.components(separatedBy: .newlines)
            var objectFinder:[String: AnyObject]? = nil
            var startLine:String? = nil
            var endLine:String? = nil
            var includeStartLine = false
            var includeEndLine = false
            
            // parse the introduction
            objectFinder = ["term": "Introduction"] as [String: AnyObject]
            if let object = ManaKit.sharedInstance.findOrCreateObject("CMRule", objectFinder: objectFinder) as? CMRule {
                object.term = "Introduction"
                object.order = 0
                object.definition = nil
                try! ManaKit.sharedInstance.dataStack?.mainContext.save()
                
                startLine = "Magic: The Gathering Comprehensive Rules"
                endLine = "Contents"
                includeStartLine = true
                includeEndLine = false
                if let text = parseData(fromLines: lines, startLine: startLine!, endLine: endLine!, includeStartLine: includeStartLine, includeEndLine: includeEndLine) {
                    objectFinder = ["parent": object] as [String: AnyObject]
                    
                    if let object2 = ManaKit.sharedInstance.findOrCreateObject("CMRule", objectFinder: objectFinder) as? CMRule {
                        object2.term = nil
                        object2.order = 0.1
                        object2.definition = text
                        object2.parent = object
                        try! ManaKit.sharedInstance.dataStack?.mainContext.save()
                    }
                }
            }
            
            // parse the rules
            parseRules(fromLines: lines)
            
            // parse the glossary
            objectFinder = ["term": "Glossary"] as [String: AnyObject]
            if let object = ManaKit.sharedInstance.findOrCreateObject("CMRule", objectFinder: objectFinder) as? CMRule {
                object.term = "Glossary"
                object.order = 10000
                object.definition = nil
                try! ManaKit.sharedInstance.dataStack?.mainContext.save()
                
                parseGlossary(fromLines: lines, parent: object)
            }
            
            // parse the credits
            objectFinder = ["term": "Credits"] as [String: AnyObject]
            if let object = ManaKit.sharedInstance.findOrCreateObject("CMRule", objectFinder: objectFinder) as? CMRule {
                object.term = "Credits"
                object.order = 11000
                object.definition = nil
                try! ManaKit.sharedInstance.dataStack?.mainContext.save()
                
                startLine = "Magic: The Gathering Original Game Design: Richard Garfield"
                endLine = "Published by Wizards of the Coast LLC"
                includeStartLine = true
                includeEndLine = true
                if let text = parseData(fromLines: lines, startLine: startLine!, endLine: endLine!, includeStartLine: includeStartLine, includeEndLine: includeEndLine) {
                    objectFinder = ["parent": object] as [String: AnyObject]
                    
                    if let object2 = ManaKit.sharedInstance.findOrCreateObject("CMRule", objectFinder: objectFinder) as? CMRule {
                        object2.term = nil
                        object2.order = 11000.1
                        object2.definition = text
                        object2.parent = object
                        try! ManaKit.sharedInstance.dataStack?.mainContext.save()
                    }
                }
            }
            
            let dateEnd = Date()
            let timeDifference = dateEnd.timeIntervalSince(dateStart)
            print("Total Time Elapsed: \(dateStart) - \(dateEnd) = \(self.format(timeDifference))")
            print("docsPath = \(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])")
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
                    
                    let objectFinder = ["term": term] as [String: AnyObject]
                    if let object = ManaKit.sharedInstance.findOrCreateObject("CMRule", objectFinder: objectFinder) as? CMRule {
                        object.term = term
                        object.order = order(of: term)
                        object.definition = definition
                        try! ManaKit.sharedInstance.dataStack?.mainContext.save()
                        
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
        
        if let parent = ManaKit.sharedInstance.findOrCreateObject("CMRule", objectFinder: parentFinder) as? CMRule {
            if parent.definition == nil &&
                parent.definition == nil {
                ManaKit.sharedInstance.dataStack?.mainContext.delete(parent)
                try! ManaKit.sharedInstance.dataStack?.mainContext.save()
            } else {
                if parent != rule {
                    rule.parent = parent
                    try! ManaKit.sharedInstance.dataStack?.mainContext.save()
                    return parent
                }
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

                            if let object = ManaKit.sharedInstance.findOrCreateObject("CMRule", objectFinder: objectFinder) as? CMRule {
                                let letters = CharacterSet.letters
                                var prefix = String(term!.prefix(1))
                                if prefix.rangeOfCharacter(from: letters) == nil {
                                    prefix = "#"
                                }

                                object.term = term
                                object.termSection = prefix
                                object.definition = definition
                                object.parent = parent
                                try! ManaKit.sharedInstance.dataStack?.mainContext.save()

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

    /**
      * Updates the `CMCard.mciNumber` value from http://magiccards.info/
      *
      */
    func updateMCINumbers() {
        let dateStart = Date()
        
        let request:NSFetchRequest<CMCard> = CMCard.fetchRequest() as! NSFetchRequest<CMCard>
        var predicate = NSPredicate(format: "mciNumber == nil AND number == nil")
        let sortDescriptors = [NSSortDescriptor(key: "set.releaseDate", ascending: true),
                               NSSortDescriptor(key: "name", ascending: true)]
        
        if let setCodesForProcessing = setCodesForProcessing {
            let setPredicate = NSPredicate(format: "set.code in %@", setCodesForProcessing)
            predicate = NSCompoundPredicate.init(andPredicateWithSubpredicates: [predicate, setPredicate])
        }
        request.predicate = predicate
        request.sortDescriptors = sortDescriptors
        
        if let cards = try! ManaKit.sharedInstance.dataStack?.mainContext.fetch(request) {
            var cachedMCISets = [String: [[String: Any]]]()
            
            var count = 0
            print("Updating MCI Numbers: \(count)/\(cards.count) \(Date())")
            
            for card in cards {
                var array:[[String: Any]]?

                if let a = cachedMCISets[card.set!.code!]  {
                    array = a
                } else {
                    if let set = card.set {
                        if let code = set.magicCardsInfoCode ?? set.code {
                            if let url = URL(string: "http://magiccards.info/\(code)/en.html") {
                                do {
                                    let htmlDoc = try HTML(url: url, encoding: .utf8)
                                    array = [[String: Any]]()
                                    
                                    // Search for nodes by XPath
                                    for tr in htmlDoc.xpath("//tr[@class='even']") {
                                        if let number = tr.xpath("td")[0].text,
                                            let name = tr.xpath("td")[1].text {
                                            array!.append(["name": name.replacingOccurrences(of: "Æ", with: "Ae")
                                                                       .replacingOccurrences(of: "æ", with: "ae"),
                                                           "number": number])
                                        }
                                    }
                                    for tr in htmlDoc.xpath("//tr[@class='odd']") {
                                        if let number = tr.xpath("td")[0].text,
                                            let name = tr.xpath("td")[1].text {
                                            array!.append(["name": name.replacingOccurrences(of: "Æ", with: "Ae")
                                                                       .replacingOccurrences(of: "æ", with: "ae"),
                                                           "number": number])
                                        }
                                    }
                                    
                                    cachedMCISets[card.set!.code!] = array
                                } catch {
                                    print("Error in loading page: \(url.absoluteString)")
                                }
                            }
                        }
                    }
                }

                var index = 0
                if let array = array {
                    for a in array {
                        if let name = a["name"] as? String,
                            let number = a["number"] as? String {
                            if name == card.name {
                                card.mciNumber = number
                                
                                // numberOrder
                                card.numberOrder = order(of: number)
                                
                                print("\(card.set!.code!) - \(card.name!) - \(number)")
                                try! ManaKit.sharedInstance.dataStack?.mainContext.save()
                                break
                            }
                        }
                        index += 1
                    }
                }
                
                if array != nil {
                    if index < array!.count {
                        array!.remove(at: index)
                        cachedMCISets[card.set!.code!] = array
                    }
                }
                
                count += 1
                if count % printMilestone == 0 {
                    print("Updating MCI Numbers: \(count)/\(cards.count) \(Date())")
                }
            }
            
            print("Updating MCI Numbers: \(count)/\(cards.count) \(Date())")
        }
        
        let dateEnd = Date()
        let timeDifference = dateEnd.timeIntervalSince(dateStart)
        print("Total Time Elapsed: \(dateStart) - \(dateEnd) = \(self.format(timeDifference))")
        print("docsPath = \(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])")
    }
    
    // MARK: Custom methods
    func changeNotification(_ notification: Notification) {
        if let updatedObjects = notification.userInfo?[NSUpdatedObjectsKey] {
            if let set = updatedObjects as? NSSet {
                print("updatedObjects: \(set.count)")
            }
        }
        if let deletedObjects = notification.userInfo?[NSDeletedObjectsKey] {
            if let set = deletedObjects as? NSSet {
                print("deletedObjects: \(set.count)")
            }
        }
        if let insertedObjects = notification.userInfo?[NSInsertedObjectsKey] {
            if let set = insertedObjects as? NSSet {
                print("insertedObjects: \(set.count)")
            }
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
        Converts @param string into double equivalents i.e. 100.1a = 100.197
     
        Useful for ordering in NSSortDescriptor.
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
                    let char = Character(c)
                    termOrder += Double(char.unicodeScalarCodePoint()) / 1000
                }
            }
        }
        
        return termOrder
    }
    
    // MARK: temporary updates
    func updateArtist() {
        let dateStart = Date()
        
        let request:NSFetchRequest<CMArtist> = CMArtist.fetchRequest() as! NSFetchRequest<CMArtist>
        
        if let artists = try! ManaKit.sharedInstance.dataStack?.mainContext.fetch(request) {
            print("Updating Artists: \(artists.count) \(Date())")
            
            for artist in artists {
                let names = artist.name!.components(separatedBy: " ")
                var nameSection: String?
                
                if names.count > 1 {
                    if let lastName = names.last {
                        artist.lastName = lastName
                        nameSection = artist.lastName
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
                    let letters = CharacterSet.letters
                    var prefix = String(nameSection.prefix(1))
                    
                    if prefix.rangeOfCharacter(from: letters) == nil {
                        prefix = "#"
                    }
                    artist.nameSection = prefix.uppercased().folding(options: .diacriticInsensitive, locale: .current)
                }
            }
            
            try! ManaKit.sharedInstance.dataStack?.mainContext.save()
        }
        
        self.updateSystem()
        
        let dateEnd = Date()
        let timeDifference = dateEnd.timeIntervalSince(dateStart)
        print("Total Time Elapsed: \(dateStart) - \(dateEnd) = \(self.format(timeDifference))")
        print("docsPath = \(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])")
    }
    
}
