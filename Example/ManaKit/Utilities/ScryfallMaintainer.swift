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
    
    // MARK: Variables
    var cachedLanguages = [CMLanguage]()
    var cachedSets = [CMSet]()
    var cachedCardColors = [CMCardColor]()
    var cachedBorderColors = [CMCardBorderColor]()
    var cachedLayouts = [CMCardLayout]()
    var cachedCardTypes = [CMCardType]()
    var cachedArtists = [CMCardArtist]()
    var cachedFrames = [CMCardFrame]()
    var cachedRarities = [CMCardRarity]()
    var cachedWatermarks = [CMCardWatermark]()
    var cachedFormats = [CMCardFormat]()
    var cachedLegalities = [CMLegality]()
    var cachedCards = [CMCard]()
    
    // MARK: Sets
    func fetchSetsAndCreateCards() {
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
                    self.createCards()
                    self.updateCards()
//                    self.updateCards2()
                    self.createCardRulings()
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
                        let capName = capitalize(string: self.displayFor(name: setType))
                        if let st = ManaKit.sharedInstance.findObject("CMSetType",
                                                                      objectFinder: ["name": capName] as [String: AnyObject],
                                                                      createIfNotFound: true) as? CMSetType {
                            st.name = capName
                            st.nameSection = self.sectionFor(name: setType)
                            set.setType = st
                        }
                    }
                    
                    // block
                    if let block = dict["block"] as? String {
                        if let b = ManaKit.sharedInstance.findObject("CMSetBlock",
                                                                     objectFinder: ["name": block] as [String: AnyObject],
                                                                     createIfNotFound: true) as? CMSetBlock {
                            b.code = dict["block_code"] as? String
                            b.name = block
                            b.nameSection = self.sectionFor(name: block)
                            set.block = b
                        }
                    }
                    
                    // releaseDate
                    if let releaseAt = dict["released_at"] as? String {
                        set.releaseDate = releaseAt
                        set.myYearSection = String(releaseAt.prefix(4))
                    } else {
                        set.myYearSection = "Undated"
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
                    if let releaseDate = parentSet.releaseDate {
                        childSet.releaseDate = releaseDate
                        childSet.myYearSection = String(releaseDate.prefix(4))
                    }
                    
                    childSet.setType = parentSet.setType
                    childSet.block = parentSet.block
                    print("\(parentSetSode) -> \(code)")
                }
            }
        }
        
        try! context.save()
    }
    
    // MARK: Cards
    func createCards() {
        startActivity(name: "createCards")
        
        guard let path = Bundle.main.path(forResource: cardsFileName, ofType: "zip", inDirectory: "data"),
            let docsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first else {
            return
        }
        let jsonPath = "\(docsPath)/\(cardsFileName)"
        
        
        if !FileManager.default.fileExists(atPath: jsonPath) {
            SSZipArchive.unzipFile(atPath: path, toDestination: docsPath)
        }
        
        let data = try! Data(contentsOf: URL(fileURLWithPath: jsonPath))
        guard let array = try! JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [[String: Any]] else {
            return
        }
        
        var count = 0
        print("Creating cards: \(count)/\(array.count) \(Date())")
        for dict in array {
            let _ = processCardData(dict: dict, languageCode: nil)
            count += 1
            
            if count % printMilestone == 0 {
                print("Creating cards: \(count)/\(array.count) \(Date())")
            }
        }

        try! context.save()
        endActivity()
    }
    
    private func processCardData(dict: [String: Any], languageCode: String?) -> CMCard? {
        if let desc = NSEntityDescription.entity(forEntityName: "CMCard", in: context),
            let card = NSManagedObject(entity: desc, insertInto: context) as? CMCard {
            // arena id
            card.arenaID = dict["arena_id"] as? String
            
            // id
            card.id = dict["id"] as? String
            
            // mtgo
            card.mtgoID = dict["mtgo_id"] as? String
            card.mtgoFoilID = dict["mtgo_foil_id"] as? String
            
            // multiverseIds
            if let multiverseIds = dict["multiverse_ids"] as? [Int] {
                card.multiverseIDs = NSKeyedArchiver.archivedData(withRootObject: multiverseIds) as NSData
            }
            
            card.oracleID = dict["oracle_id"] as? String
            
            // converted mana cost
            if let convertedManaCost = dict["cmc"] as? Double {
                card.convertedManaCost = convertedManaCost
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
            card.illustrationID = dict["illustration_id"] as? String
            
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
                
                let binaryImageURIs = NSKeyedArchiver.archivedData(withRootObject: newImageUris)
                card.imageURIs = binaryImageURIs as NSData
            }
            
            /// cached data here ///
            
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
                
                // add the card to set
                s.addToCards(card)
            }
            
            // type line
            if let type = dict["type_line"] as? String {
                if let l = findLanguage(with: languageCode ?? dict["lang"] as? String ?? "en") {
                    card.typeLine = findCardType(with: type, language: l)
                }
            }
            
            // printed type line
            if let type = dict["printed_type_line"] as? String {
                if let l = findLanguage(with: languageCode ?? dict["lang"] as? String ?? "en") {
                    card.printedTypeLine = findCardType(with: type, language: l)
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
            
            // legalities
            if let legalities = dict["legalities"] as? [String: Any] {
                for (k,v) in legalities {
                    if let v = v as? String,
                        let format = findFormat(with: k),
                        let legality = findLegality(with: v) {
                        
                        if let desc = NSEntityDescription.entity(forEntityName: "CMCardLegality",
                                                                 in: context),
                            let cardLegality = NSManagedObject(entity: desc,
                                                               insertInto: context) as? CMCardLegality {
                            cardLegality.format = format
                            cardLegality.legality = legality
                            cardLegality.card = card
                            card.addToCardLegalities(cardLegality)
                        }
                    }
                }
            }

            return card
        }
        
        return nil
    }

    func updateCards() {
        startActivity(name: "updateCards")
        
        guard let path = Bundle.main.path(forResource: cardsFileName, ofType: "zip", inDirectory: "data"),
            let docsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first else {
                return
        }
        let jsonPath = "\(docsPath)/\(cardsFileName)"
        
        if !FileManager.default.fileExists(atPath: jsonPath) {
           SSZipArchive.unzipFile(atPath: path, toDestination: docsPath)
        }
        
        let data = try! Data(contentsOf: URL(fileURLWithPath: jsonPath))
        guard let array = try! JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [[String: Any]] else {
            return
        }
        
        var count = 0
        print("Updating cards: \(count)/\(array.count) \(Date())")
        
        reloadCachedCards()
        for dict in array {
            if let id = dict["id"] as? String {
                
                // all parts
                if let allParts = dict["all_parts"] as? [[String: Any]] {
                    if let card = cachedCards.filter({ $0.id == id }).first {
                        for allPart in allParts {
                            if let allPartId = allPart["id"] as? String,
                                let name = allPart["name"] as? String {
                                
                                if name == card.name {
                                    continue
                                }
                                if let part = cachedCards.filter({ $0.id == allPartId }).first {
                                    part.part = card
                                    card.addToParts(part)
                                }
                            }
                        }
                    }
                }
                
                // card faces
                if let cardFaces = dict["card_faces"] as? [[String: Any]] {
                    if let card = cachedCards.filter({ $0.id == id }).first {
                        var index = 0
                        for cardFace in cardFaces {
                            if let face = processCardData(dict: cardFace,
                                                          languageCode: dict["lang"] as? String) {
                                face.face = card
                                face.set = card.set
                                face.language = card.language
                                face.faceOrder = Int32(index)
                                card.addToFaces(face)
                                index += 1
                            }
                        }
                    }
                }
                
                count += 1
                if count % printMilestone == 0 {
                    print("Updating cards: \(count)/\(array.count) \(Date())")
                }
            }
        }

        try! context.save()
        endActivity()
    }
    
    func updateCards2() {
        startActivity(name: "updateCards2")
        
        let request: NSFetchRequest<CMCard> = CMCard.fetchRequest()
        request.predicate = NSPredicate(format: "id != nil")
        request.sortDescriptors = [NSSortDescriptor(key: "set.releaseDate", ascending: true),
                                   NSSortDescriptor(key: "name", ascending: true)]
        let cards = try! context.fetch(request)
        var count = 0
        print("Updating cards: \(count)/\(cards.count) \(Date())")
        
        reloadCachedCards()
        for card in cards {
            // variations
            createVariations(ofCard: card)
        
            // other languages
            createOtherLanguages(ofCard: card)
            
            // other printings
            createOtherPrintings(ofCard: card)

            count += 1
            if count % printMilestone == 0 {
                print("Updating cards: \(count)/\(cards.count) \(Date())")
            }
        }

        try! context.save()
        endActivity()
    }
    
    private func createVariations(ofCard card: CMCard) {
        if let set = card.set,
            let code = set.code,
            let language = card.language,
            let languageCode = language.code,
            let cachedSet = findSet(code: code),
            let cardSets = cachedSet.cards,
            let cards = cardSets.allObjects as? [CMCard] {
            
            let filteredCards = cards.filter({ $0.language!.code == languageCode
                                               && $0.id != card.id
                                               && $0.name == card.name })
            for c in filteredCards {
                card.addToVariations(c)
            }
        }
    }

    private func createOtherLanguages(ofCard card: CMCard) {
        if let language = card.language,
            let languageCode = language.code,
            let name = card.name {
            
            let filteredCards = cachedCards.filter({ $0.language!.code != languageCode
                                                     && $0.id != card.id
                                                     && $0.name == name })
            for c in filteredCards {
                card.addToOtherLanguages(c)
            }
        }
    }

    private func createOtherPrintings(ofCard card: CMCard) {
        if let set = card.set,
            let setCode = set.code,
            let language = card.language,
            let languageCode = language.code,
            let name = card.name {
            
            let filteredCards = cachedCards.filter({ $0.set!.code != setCode
                                                     && $0.language!.code == languageCode
                                                     && $0.id != card.id
                                                     && $0.name == name })
            for c in filteredCards {
                card.addToOtherPrintings(c)
            }
        }
    }
    
    // MARK: Rulings
    func createCardRulings() {
        startActivity(name: "createCardRulings")
        
        guard let path = Bundle.main.path(forResource: rulingsFileName, ofType: "zip", inDirectory: "data"),
            let docsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first else {
                return
        }
        let jsonPath = "\(docsPath)/\(rulingsFileName)"
        
        if !FileManager.default.fileExists(atPath: jsonPath) {
            SSZipArchive.unzipFile(atPath: path, toDestination: docsPath)
        }
        
        let data = try! Data(contentsOf: URL(fileURLWithPath: jsonPath))
        guard let array = try! JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [[String: Any]] else {
            return
        }
        
        var count = 0
        print("Creating rulings: \(count)/\(array.count) \(Date())")
        
        reloadCachedCards()
        for dict in array {
            if let oracleID = dict["oracle_id"] as? String,
                let publishedAt = dict["published_at"] as? String,
                let comment = dict["comment"] as? String {
                
                if let desc = NSEntityDescription.entity(forEntityName: "CMCardRuling", in: context),
                    let ruling = NSManagedObject(entity: desc, insertInto: context) as? CMCardRuling {
                    
                    ruling.text = comment
                    ruling.date = publishedAt
                    
                    for card in cachedCards.filter({ $0.oracleID == oracleID }) {
                        ruling.card = card
                        card.addToRulings(ruling)
                    }
                }
                
                count += 1
                if count % printMilestone == 0 {
                    print("Creating rulings: \(count)/\(array.count) \(Date())")
                }
            }
        }
        
        try! context.save()
        endActivity()
    }
    
    // MARK: Object finders
    private func findSet(code: String) -> CMSet? {
        if cachedSets.isEmpty {
            let request: NSFetchRequest<CMSet> = CMSet.fetchRequest()
            cachedSets = try! context.fetch(request)
        }
        
        return cachedSets.first(where: { $0.code == code})
    }
    
    private func reloadCachedCards() {
        cachedSets.removeAll()
        cachedCards.removeAll()
        
        let request: NSFetchRequest<CMSet> = CMSet.fetchRequest()
        cachedSets = try! context.fetch(request)
        
        for set in cachedSets {
            if let cards = set.cards,
                let array = cards.allObjects as? [CMCard] {
                cachedCards.append(contentsOf: array.filter({ $0.id != nil }))
            }
        }
    }
    
    private func findLanguage(with code: String) -> CMLanguage? {
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
    
    private func findCardColor(with symbol: String) -> CMCardColor? {
        if let color = cachedCardColors.first(where: { $0.symbol == symbol}) {
            return color
        } else {
            if let desc = NSEntityDescription.entity(forEntityName: "CMCardColor", in: context),
                let color = NSManagedObject(entity: desc, insertInto: context) as? CMCardColor {
                
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
        
        return nil
    }
    
    private func findCardBorderColor(with name: String) -> CMCardBorderColor? {
        let capName = capitalize(string: name)
        
        if let borderColor = cachedBorderColors.first(where: { $0.name == capName}) {
            return borderColor
        } else {
            if let desc = NSEntityDescription.entity(forEntityName: "CMCardBorderColor", in: context),
                let borderColor = NSManagedObject(entity: desc, insertInto: context) as? CMCardBorderColor {
                
                borderColor.name = capName
                borderColor.nameSection = sectionFor(name: name)
                
                cachedBorderColors.append(borderColor)
                return borderColor
            }
        }
        
        return nil
    }
    
    private func findCardLayout(with name: String) -> CMCardLayout? {
        let capName = capitalize(string: name)
        
        if let layout = cachedLayouts.first(where: { $0.name == capName}) {
            return layout
        } else {
            if let desc = NSEntityDescription.entity(forEntityName: "CMCardLayout", in: context),
                let layout = NSManagedObject(entity: desc, insertInto: context) as? CMCardLayout {
                
                layout.name = capName
                layout.nameSection = sectionFor(name: name)
                
                cachedLayouts.append(layout)
                return layout
            }
        }
        
        return nil
    }
    
    private func findCardType(with name: String, language: CMLanguage) -> CMCardType? {
        if let type = cachedCardTypes.first(where: { $0.name == name}) {
            return type
        } else {
            if let desc = NSEntityDescription.entity(forEntityName: "CMCardType", in: context),
                let type = NSManagedObject(entity: desc, insertInto: context) as? CMCardType {
                
                type.name = name
                type.language = language
                
                cachedCardTypes.append(type)
                return type
            }
        }
        
        return nil
    }
    
    private func findArtist(with name: String) -> CMCardArtist? {
        if let artist = cachedArtists.first(where: { $0.name == name}) {
            return artist
        } else {
            if let desc = NSEntityDescription.entity(forEntityName: "CMCardArtist", in: context),
                let artist = NSManagedObject(entity: desc, insertInto: context) as? CMCardArtist {
                
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
        
        return nil
    }
    
    private func findCardFrame(with name: String) -> CMCardFrame? {
        let capName = capitalize(string: name)
        
        if let frame = cachedFrames.first(where: { $0.name == capName}) {
            return frame
        } else {
            if let desc = NSEntityDescription.entity(forEntityName: "CMCardFrame", in: context),
                let frame = NSManagedObject(entity: desc, insertInto: context) as? CMCardFrame {
                
                frame.name = capName
                frame.nameSection = sectionFor(name: name)
                
                cachedFrames.append(frame)
                return frame
            }
        }
        
        return nil
    }
    
    private func findRarity(with name: String) -> CMCardRarity? {
        let capName = capitalize(string: name)
        
        if let rarity = cachedRarities.first(where: { $0.name == capName}) {
            return rarity
        } else {
            if let desc = NSEntityDescription.entity(forEntityName: "CMCardRarity", in: context),
                let rarity = NSManagedObject(entity: desc, insertInto: context) as? CMCardRarity {
                
                rarity.name = capName
                rarity.nameSection = sectionFor(name: name)
                
                cachedRarities.append(rarity)
                return rarity
            }
        }
        
        return nil
    }
    
    private func findCardWatermark(with name: String) -> CMCardWatermark? {
        let capName = capitalize(string: name)
        
        if let watermark = cachedWatermarks.first(where: { $0.name == capName}) {
            return watermark
        } else {
            if let desc = NSEntityDescription.entity(forEntityName: "CMCardWatermark", in: context),
                let watermark = NSManagedObject(entity: desc, insertInto: context) as? CMCardWatermark {
                
                watermark.name = capName
                watermark.nameSection = sectionFor(name: name)
                
                cachedWatermarks.append(watermark)
                return watermark
            }
        }
        
        return nil
    }
    
    private func findFormat(with name: String) -> CMCardFormat? {
        let capName = capitalize(string: name)
        
        if let format = cachedFormats.first(where: { $0.name == capName}) {
            return format
        } else {
            if let desc = NSEntityDescription.entity(forEntityName: "CMCardFormat", in: context),
                let format = NSManagedObject(entity: desc, insertInto: context) as? CMCardFormat {
                
                format.name = capName
                format.nameSection = sectionFor(name: name)
                
                cachedFormats.append(format)
                return format
            }
        }
        
        return nil
    }
    
    private func findLegality(with name: String) -> CMLegality? {
        let capName = capitalize(string: name)
        
        if let legality = cachedLegalities.first(where: { $0.name == capName}) {
            return legality
        } else {
            if let desc = NSEntityDescription.entity(forEntityName: "CMLegality", in: context),
                let legality = NSManagedObject(entity: desc, insertInto: context) as? CMLegality {
                
                legality.name = capName
                legality.nameSection = sectionFor(name: name)
                
                cachedLegalities.append(legality)
                return legality
            }
        }
        
        return nil
    }
}
