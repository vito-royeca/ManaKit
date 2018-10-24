//
//  ScryfallMaintainer.swift
//  ManaKit
//
//  Created by Jovito Royeca on 21.10.18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import CoreData
import ManaKit
import PromiseKit
import SSZipArchive

class ScryfallMaintainer: Maintainer {
    // MARK: Constants
    let setCodesForProcessing:[String]? = nil
    let fileName = "scryfall-default-cards.json"
    
    // MARK: Variables
    var cachedLanguages = [CMLanguage]()
    var cachedSets = [CMSet]()
    var cachedCardColors = [CMCardColor]()
    var cachedBorderColors = [CMCardBorderColor]()
    var cachedLayouts = [CMCardLayout]()
    var cachedCardTypes = [CMCardType]()
    var cachedArtists = [CMArtist]()
    var cachedFrames = [CMCardFrame]()
    var cachedRarities = [CMRarity]()
    var cachedWatermarks = [CMCardWatermark]()
    
    // MARK: Sets
    func fetchSets() {
        startActivity(name: "fetchSets")
        
        if let urlString = "https://api.scryfall.com/sets".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
            let url = URL(string: urlString) {
            
            var rq = URLRequest(url: url)
            rq.httpMethod = "GET"
            
            firstly {
                URLSession.shared.dataTask(.promise, with:rq)
            }.compactMap {
                try JSONSerialization.jsonObject(with: $0.data) as? [String: Any]
            }.done { json in
                if let data = json["data"] as? [[String: Any]] {
                    self.processSets(data: data)
                }
                self.endActivity()
            }.catch { error in
                print("\(error)")
            }
        }
    }
    
    private func processSets(data: [[String: Any]]) {
        for dict in data {
            if let code = dict["code"] as? String,
                let name = dict["name"] as? String {
                
                if let set = ManaKit.sharedInstance.findObject("CMSet",
                                                               objectFinder: ["code": code] as [String: AnyObject],
                                                               createIfNotFound: true) as? CMSet {
                    set.code = code
                    set.mtgoCode = dict["mtgo_code"] as? String
                    
                    // name
                    set.name = name
                    set.myNameSection = self.sectionFor(name: name)
                    
                    // setType
                    if let setType = dict["set_type"] as? String {
                        if let st = ManaKit.sharedInstance.findObject("CMSetType",
                                                                      objectFinder: ["name": setType] as [String: AnyObject],
                                                                      createIfNotFound: true) as? CMSet {
                            st.name = self.displayFor(name: setType)
                            st.myNameSection = self.sectionFor(name: setType)
                        }
                    }
                    
                    // releaseDate
                    if let releaseAt = dict["released_at"] as? String {
                        set.releaseDate = releaseAt
                        set.myYearSection = String(releaseAt.prefix(4))
                    }
                    
                    // block
                    if let block = dict["block"] as? String {
                        if let b = ManaKit.sharedInstance.findObject("CMSetBlock",
                                                                     objectFinder: ["name": block] as [String: AnyObject],
                                                                     createIfNotFound: true) as? CMSet {
                            b.code = dict["block_code"] as? String
                            b.name = block
                            b.myNameSection = self.sectionFor(name: block)
                            
                        }
                    }
                    
                    if let cardCount = dict["card_count"] as? Int {
                        set.cardCount = Int32(cardCount)
                    }
                    if let digital = dict["digital"] as? Bool {
                        set.isOnlineOnly = digital
                    }
                    if let foilOnly = dict["foil_only"] as? Bool {
                        set.isFoilOnly = foilOnly
                    }
                    
                    print("\(code) - \(name)")
                    try! ManaKit.sharedInstance.dataStack?.mainContext.save()
                }
            }
        }
        
        // parent-child
        for dict in data {
            if let code = dict["code"] as? String,
                let parentSetSode = dict["parent_set_code"] as? String {
                
                if let childSet = ManaKit.sharedInstance.findObject("CMSet",
                                                                    objectFinder: ["code": code] as [String: AnyObject],
                                                                    createIfNotFound: true) as? CMSet,
                    let parentSet = ManaKit.sharedInstance.findObject("CMSet",
                                                                      objectFinder: ["code": parentSetSode] as [String: AnyObject],
                                                                      createIfNotFound: true) as? CMSet {
                    childSet.parent = parentSet
                    print("\(parentSetSode) -> \(code)")
                    try! ManaKit.sharedInstance.dataStack?.mainContext.save()
                }
            }
        }
    }
    
    // MARK: Cards
    func createCards() {
        startActivity(name: "createCards")
        
        guard let path = Bundle.main.path(forResource: fileName, ofType: "zip", inDirectory: "data"),
            let docsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first else {
            return
        }
        let jsonPath = "\(docsPath)/\(fileName)"
        
        SSZipArchive.unzipFile(atPath: path, toDestination: docsPath)
        
        if FileManager.default.fileExists(atPath: jsonPath) {
            let data = try! Data(contentsOf: URL(fileURLWithPath: jsonPath))
            guard let array = try! JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [[String: Any]] else {
                return
            }
            
            var count = 0
            print("Creating cards: \(count)/\(array.count) \(Date())")
            for dict in array {
                if let id = dict["id"] {
                    if let card = ManaKit.sharedInstance.findObject("CMCard",
                                                                   objectFinder: ["id": id] as [String: AnyObject],
                                                                   createIfNotFound: true) as? CMCard {
                        // arena id
                        card.arenaId = dict["arena_id"] as? String
                        
                        // id
                        card.id = dict["id"] as? String
                        
                        // mtgo
                        card.mtgoId = dict["mtgo_id"] as? String
                        card.mtgoFoilId = dict["mtgo_foil_id"] as? String
                        
                        // multiverseIds
                        if let multiverseIds = dict["multiverse_ids"] as? [Int] {
                            card.multiverseIds = NSKeyedArchiver.archivedData(withRootObject: multiverseIds) as NSData
                        }
                        
                        card.oracleId = dict["oracle_id"] as? String
                        
                        // converted mana cost
                        if let convertedManaCost = dict["cmc"] as? Double {
                            card.comvertedManaCost = convertedManaCost
                        }
                        
                        // loyalty
                        card.loyalty = dict["loyalty"] as? String
                        
                        // mana cost
                        card.manaCost = dict["mana_cost"] as? String
                        
                        // name
                        card.name = dict["name"] as? String
                        
                        // oracle text
                        card.oracleText = dict["oracle_text"] as? String
                        
                        // foil
                        if let foil = dict["foil"] as? Bool {
                            card.isFoil = foil
                        }
                        
                        // nonfoil
                        if let nonfoil = dict["nonfoil"] as? Bool {
                            card.isNonFoil = nonfoil
                        }
                        
                        // oversized
                        if let oversized = dict["oversized"] as? Bool {
                            card.isOversized = oversized
                        }
                        
                        // reserved
                        if let reserved = dict["reserved"] as? Bool {
                            card.isReserved = reserved
                        }
                        
                        // power
                        card.power = dict["power"] as? String
                        
                        // toughness
                        card.toughness = dict["toughness"] as? String
                        
                        // collector number, number order
                        card.collectorNumber = dict["collector_number"] as? String
                        
                        // colorshifted
                        if let colorshifted = dict["colorshifted"] as? Bool {
                            card.isColorshifted = colorshifted
                        }
                        
                        // digital
                        if let digital = dict["digital"] as? Bool {
                            card.isDigital = digital
                        }
                        
                        // flavor text
                        card.flavorText = dict["flavor_text"] as? String
                        
                        // full art
                        if let fullArt = dict["full_art"] as? Bool {
                            card.isFullArt = fullArt
                        }
                        
                        // futureshifted
                        if let futureshifted = dict["futureshifted"] as? Bool {
                            card.isFutureshifted = futureshifted
                        }
                        
                        // high res image
                        if let highresImage = dict["highres_image"] as? Bool {
                            card.isHighResImage = highresImage
                        }
                        
                        // illustration id
                        card.illustrationId = dict["illustration_id"] as? String
                        
                        // printed name
                        card.printedName = dict["printed_name"] as? String
                        
                        // printed text
                        card.printedText = dict["printed_text"] as? String
                        
                        // reprint
                        if let reprint = dict["reprint"] as? Bool {
                            card.isReprint = reprint
                        }
                        
                        // story spotlight
                        if let storySpotlight = dict["story_spotlight"] as? Bool {
                            card.isStorySpotlight = storySpotlight
                        }
                        
                        // timeshifted
                        if let timeshifted = dict["timeshifted"] as? Bool {
                            card.isTimeshifted = timeshifted
                        }
                        
                        // image uris
                        if let imageUris = dict["image_uris"] as? [String: String] {
                            // remove the key (?APIKEY) in the url
                            var newImageUris = [String: String]()
                            for (k,v) in imageUris {
                                newImageUris[k] = v.components(separatedBy: "?").first
                            }
                            
                            let binaryImageUris = NSKeyedArchiver.archivedData(withRootObject: newImageUris)
                            card.imageUris = binaryImageUris as NSData
                        }

                        ////
                        //cached data here
                        ////
                        
                        // language and set
                        if let lang = dict["lang"] as? String,
                            let set = dict["set"] as? String,
                            let l = findLanguage(with: lang),
                            let s = findSet(code: set) {
                            
                            card.language = l
                            card.set = s
                            
                            // add the language to set
                            if let langs = s.languages,
                                let array = langs.allObjects as? [CMLanguage] {
                                if !array.contains(l) {
                                    s.addToLanguages(l)
                                }
                            } else {
                                s.addToLanguages(l)
                            }
                        }
                        
                        // colors
                        if let colors = dict["colors"] as? [String] {
                            for color in colors {
                                if let c = findCardColor(with: color) {
                                    card.addToColors(c)
                                }
                            }
                        }
                        
                        // color identities
                        if let colors = dict["color_identity"] as? [String] {
                            for color in colors {
                                if let c = findCardColor(with: color) {
                                    card.addToColorIdentities(c)
                                }
                            }
                        }
                        
                        // color identities
                        if let colors = dict["color_indicator"] as? [String] {
                            for color in colors {
                                if let c = findCardColor(with: color) {
                                    card.addToColorIndicators(c)
                                }
                            }
                        }
                        
                        // border color
                        if let borderColor = dict["border_color"] as? String {
                            card.borderColor = findCardBorderColor(with: borderColor)
                        }

                        // layout
                        if let layout = dict["layout"] as? String {
                            card.layout = findCardLayout(with: layout)
                        }
                        
                        // type line
                        if let type = dict["type_line"] as? String {
                            card.typeLine = findCardType(with: type)
                        }
                        
                        // printed type line
                        if let type = dict["printed_type_line"] as? String {
                            card.printedTypeLine = findCardType(with: type)
                        }
                        
                        // artist
                        if let artist = dict["artist"] as? String {
                            card.artist = findArtist(with: artist)
                        }
                        
                        // frame
                        if let frame = dict["frame"] as? String {
                            card.frame = findCardFrame(with: frame)
                        }
                        
                        // rarity
                        if let rarity = dict["rarity"] as? String {
                            card.rarity = findRarity(with: rarity)
                        }
                        
                        // watermark
                        if let watermark = dict["watermark"] as? String {
                            card.watermark = findCardWatermark(with: watermark)
                        }
                        
                        count += 1
                        if count % printMilestone == 0 {
                            print("Creating cards: \(count)/\(array.count) \(Date())")
                            try! ManaKit.sharedInstance.dataStack?.mainContext.save()
                        }
                    }
                }
            }
        }
        
        endActivity()
    }
    
    func updateCards() {
        startActivity(name: "updateCards")
        
        guard let path = Bundle.main.path(forResource: fileName, ofType: "zip", inDirectory: "data"),
            let docsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first else {
                return
        }
        let jsonPath = "\(docsPath)/\(fileName)"
        
        SSZipArchive.unzipFile(atPath: path, toDestination: docsPath)
        
        if FileManager.default.fileExists(atPath: jsonPath) {
            let data = try! Data(contentsOf: URL(fileURLWithPath: jsonPath))
            guard let array = try! JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [[String: Any]] else {
                return
            }
            
            var count = 0
            print("Updating cards: \(count)/\(array.count) \(Date())")
            for dict in array {
                if let id = dict["id"] {
                    if let card = ManaKit.sharedInstance.findObject("CMCard",
                                                                    objectFinder: ["id": id] as [String: AnyObject],
                                                                    createIfNotFound: true) as? CMCard {

                        // all parts
                        if let allParts = dict["all_parts"] as? [[String: Any]] {
                            for dict in allParts {
                                if let partId = dict["id"] as? String {
                                    if let part = ManaKit.sharedInstance.findObject("CMCard",
                                                                                    objectFinder: ["id": partId] as [String: AnyObject],
                                                                                    createIfNotFound: true) as? CMCard {
                                        card.addToParts(part)
                                    }
                                }
                            }
                        }
                        
                        // card faces
                        if let cardFacess = dict["card_faces"] as? [[String: Any]] {
                            
                        }
                        
                        // card printings
                        // TODO: implement card printings
                        
                        // card variations
                        // TODO: implement card variations
                        
                        // legalities
                        // TODO: implement card legalities
                        
                        try! ManaKit.sharedInstance.dataStack?.mainContext.save()
                        
                        count += 1
                        if count % printMilestone == 0 {
                            print("Creating cards: \(count)/\(array.count) \(Date())")
                        }
                    }
                }
            }
        }
        
        endActivity()
    }
    
    // rulings
    func createCardRulings() {
        
    }
    
    // MARK: Object creators
//    private func createCardImageURI(withType type: String, andURI uri: String) -> CMCardImageURI? {
//        let id = "\(type)_\(uri)"
//        if let cardImageURI = ManaKit.sharedInstance.findObject("CMCardImageURI",
//                                                                objectFinder: ["id": id] as [String: AnyObject],
//                                                                createIfNotFound: true) as? CMCardImageURI {
//            if cardImageURI.id == nil {
//                cardImageURI.type = type
//                cardImageURI.uri = uri
//                cardImageURI.id = id
//                try! ManaKit.sharedInstance.dataStack?.mainContext.save()
//            }
//            return cardImageURI
//        }
//
//        return nil
//    }

    private func findSet(code: String) -> CMSet? {
        if cachedSets.isEmpty {
            let request: NSFetchRequest<CMSet> = CMSet.fetchRequest()
            if let sets = try! ManaKit.sharedInstance.dataStack?.mainContext.fetch(request) {
                cachedSets = sets
            }
        }
        
        return cachedSets.filter({ $0.code == code}).first
    }
    
    private func findLanguage(with code: String) -> CMLanguage? {
        if let language = cachedLanguages.filter({ $0.code == code}).first {
            return language
        } else {
            if let language = ManaKit.sharedInstance.findObject("CMLanguage",
                                                                objectFinder: ["code": code] as [String: AnyObject],
                                                                createIfNotFound: true) as? CMLanguage {
                if language.code == nil {
                    language.code = code
                    switch code {
                    case "en":
                        language.name = "English"
                    case "es":
                        language.name = "Spanish"
                    case "fr":
                        language.name = "French"
                    case "de":
                        language.name = "German"
                    case "it":
                        language.name = "Italian"
                    case "pt":
                        language.name = "Portuguese"
                    case "ja":
                        language.name = "Japanese"
                    case "ko":
                        language.name = "Korean"
                    case "ru":
                        language.name = "Russian"
                    case "zhs":
                        language.name = "Simplified Chinese"
                    case "zht":
                        language.name = "Traditional Chinese"
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
                    
                    try! ManaKit.sharedInstance.dataStack?.mainContext.save()
                }
                
                cachedLanguages.append(language)
                return language
            }
        }

        return nil
    }
    
    private func findCardColor(with symbol: String) -> CMCardColor? {
        if let color = cachedCardColors.filter({ $0.symbol == symbol}).first {
            return color
        } else {
            if let color = ManaKit.sharedInstance.findObject("CMCardColor",
                                                             objectFinder: ["symbol": symbol] as [String: AnyObject],
                                                             createIfNotFound: true) as? CMCardColor {
                
                if color.symbol == nil {
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
                    
                    try! ManaKit.sharedInstance.dataStack?.mainContext.save()
                }
                
                cachedCardColors.append(color)
                return color
            }
        }
        
        return nil
    }
    
    private func findCardBorderColor(with name: String) -> CMCardBorderColor? {
        let capName = name.prefix(1).uppercased() + name.dropFirst()
        
        if let borderColor = cachedBorderColors.filter({ $0.name == capName}).first {
            return borderColor
        } else {
            if let borderColor = ManaKit.sharedInstance.findObject("CMCardBorderColor",
                                                                   objectFinder: ["name": capName] as [String: AnyObject],
                                                                   createIfNotFound: true) as? CMCardBorderColor {
                if borderColor.name == nil {
                    borderColor.name = capName
                    try! ManaKit.sharedInstance.dataStack?.mainContext.save()
                }
                
                cachedBorderColors.append(borderColor)
                return borderColor
            }
        }
        
        return nil
    }
    
    private func findCardLayout(with name: String) -> CMCardLayout? {
        let capName = name.prefix(1).uppercased() + name.dropFirst()
        
        if let layout = cachedLayouts.filter({ $0.name == capName}).first {
            return layout
        } else {
            if let layout = ManaKit.sharedInstance.findObject("CMCardLayout",
                                                              objectFinder: ["name": capName] as [String: AnyObject],
                                                              createIfNotFound: true) as? CMCardLayout {
                if layout.name == nil {
                    layout.name = capName
                    try! ManaKit.sharedInstance.dataStack?.mainContext.save()
                }
                
                cachedLayouts.append(layout)
                return layout
            }
        }
        
        return nil
    }
    
    private func findCardType(with name: String) -> CMCardType? {
        if let type = cachedCardTypes.filter({ $0.name == name}).first {
            return type
        } else {
            if let type = ManaKit.sharedInstance.findObject("CMCardType",
                                                            objectFinder: ["name": name] as [String: AnyObject],
                                                            createIfNotFound: true) as? CMCardType {
                if type.name == nil {
                    type.name = name
                    try! ManaKit.sharedInstance.dataStack?.mainContext.save()
                }
                
                cachedCardTypes.append(type)
                return type
            }
        }
        
        return nil
    }
    
    private func findArtist(with name: String) -> CMArtist? {
        if let artist = cachedArtists.filter({ $0.name == name}).first {
            return artist
        } else {
            if let artist = ManaKit.sharedInstance.findObject("CMArtist",
                                                              objectFinder: ["name": name] as [String: AnyObject],
                                                              createIfNotFound: true) as? CMArtist {
                if artist.name == nil {
                    artist.name = name
                    try! ManaKit.sharedInstance.dataStack?.mainContext.save()
                }
                
                cachedArtists.append(artist)
                return artist
            }
        }
        
        return nil
    }
    
    private func findCardFrame(with name: String) -> CMCardFrame? {
        let capName = name.prefix(1).uppercased() + name.dropFirst()
        
        if let frame = cachedFrames.filter({ $0.name == capName}).first {
            return frame
        } else {
            if let frame = ManaKit.sharedInstance.findObject("CMCardFrame",
                                                             objectFinder: ["name": capName] as [String: AnyObject],
                                                            createIfNotFound: true) as? CMCardFrame {
                if frame.name == nil {
                    frame.name = capName
                    try! ManaKit.sharedInstance.dataStack?.mainContext.save()
                }
                
                cachedFrames.append(frame)
                return frame
            }
        }
        
        return nil
    }
    
    private func findRarity(with name: String) -> CMRarity? {
        let capName = name.prefix(1).uppercased() + name.dropFirst()
        
        if let rarity = cachedRarities.filter({ $0.name == capName}).first {
            return rarity
        } else {
            if let rarity = ManaKit.sharedInstance.findObject("CMRarity",
                                                              objectFinder: ["name": capName] as [String: AnyObject],
                                                              createIfNotFound: true) as? CMRarity {
                if rarity.name == nil {
                    rarity.name = capName
                    try! ManaKit.sharedInstance.dataStack?.mainContext.save()
                }
                
                cachedRarities.append(rarity)
                return rarity
            }
        }
        
        return nil
    }
    
    private func findCardWatermark(with name: String) -> CMCardWatermark? {
        let capName = name.prefix(1).uppercased() + name.dropFirst()
        
        if let watermark = cachedWatermarks.filter({ $0.name == capName}).first {
            return watermark
        } else {
            if let watermark = ManaKit.sharedInstance.findObject("CMCardWatermark",
                                                                 objectFinder: ["name": capName] as [String: AnyObject],
                                                                 createIfNotFound: true) as? CMCardWatermark {
                if watermark.name == nil {
                    watermark.name = capName
                    try! ManaKit.sharedInstance.dataStack?.mainContext.save()
                }
                
                cachedWatermarks.append(watermark)
                return watermark
            }
        }
        
        return nil
    }
}
