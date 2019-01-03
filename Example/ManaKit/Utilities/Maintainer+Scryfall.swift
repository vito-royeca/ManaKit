//
//  ScryfallMaintainer.swift
//  ManaKit
//
//  Created by Jovito Royeca on 21.10.18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import ManaKit
import PromiseKit
import RealmSwift

extension Maintainer {
    // MARK: Sets
    func fetchSetsAndCreateCards() -> Promise<Void>{
        return Promise { seal in
            guard let urlString = "https://api.scryfall.com/sets".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                let url = URL(string: urlString) else {
                fatalError("Malformed url")
            }
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
                    seal.fulfill(())
                }
            }.catch { error in
                seal.reject(error)
            }
        }
    }
    
    private func processSets(data: [[String: Any]]) {
        try! realm.write {
            for dict in data {
                if let code = dict["code"] as? String,
                    let name = dict["name"] as? String {
                    
                    var set: CMSet?
                    var setType: CMSetType?
                    var setBlock: CMSetBlock?
                    
                    if let x = realm.object(ofType: CMSet.self, forPrimaryKey: code) {
                        set = x
                    } else {
                        set = CMSet()
                        set!.code = code
                    }
                    
                    set!.mtgoCode = dict["mtgo_code"] as? String
                    set!.name = name
                    set!.myNameSection = self.sectionFor(name: name)
                    
                    // setType
                    if let set_type = dict["set_type"] as? String {
                        let capName = capitalize(string: self.displayFor(name: set_type))
                        
                        if let x = realm.object(ofType: CMSetType.self, forPrimaryKey: capName) {
                            setType = x
                        } else {
                            setType = CMSetType()
                            setType!.name = capName
                        }
                        
                        setType!.nameSection = self.sectionFor(name: set_type)
                        realm.add(setType!)
                    }
                    
                    // block
                    if let block = dict["block"] as? String {
                        if let x = realm.object(ofType: CMSetBlock.self, forPrimaryKey: block) {
                            setBlock = x
                        } else {
                            setBlock = CMSetBlock()
                            setBlock!.name = block
                        }
                        
                        setBlock!.code = dict["block_code"] as? String
                        setBlock!.nameSection = self.sectionFor(name: block)
                        realm.add(setBlock!)
                    }
                    
                    // releaseDate
                    if let releaseAt = dict["released_at"] as? String {
                        set!.releaseDate = releaseAt
                        set!.myYearSection = String(releaseAt.prefix(4))
                    } else {
                        set!.myYearSection = "Undated"
                    }

                    if let cardCount = dict["card_count"] as? Int {
                        set!.cardCount = Int32(cardCount)
                    }
                    if let digital = dict["digital"] as? Bool {
                        set!.isOnlineOnly = digital
                    }
                    if let foilOnly = dict["foil_only"] as? Bool {
                        set!.isFoilOnly = foilOnly
                    }
                    set!.setType = setType
                    set!.block = setBlock
                    
                    print("\(code) - \(name)")
                    realm.add(set!)
                }
            }
        
            // parent-child
            for dict in data {
                if let code = dict["code"] as? String,
                    let parentSetCode = dict["parent_set_code"] as? String,
                    let childSet = realm.object(ofType: CMSet.self, forPrimaryKey: code),
                    let parentSet = realm.object(ofType: CMSet.self, forPrimaryKey: parentSetCode) {
                    
                    childSet.parent = parentSet
                    if let releaseDate = parentSet.releaseDate {
                        childSet.releaseDate = releaseDate
                        childSet.myYearSection = String(releaseDate.prefix(4))
                    }
                    
                    childSet.setType = parentSet.setType
                    childSet.block = parentSet.block
                    print("\(parentSetCode) -> \(code)")
                    
                    realm.add(childSet)
                }
            }
        }
    }

    // MARK: Cards
    func createCards() {
        guard let path = Bundle.main.path(forResource: cardsFileName,
                                          ofType: "json",
                                          inDirectory: "data") else {
            return
        }
        
        let data = try! Data(contentsOf: URL(fileURLWithPath: path))
        guard let array = try! JSONSerialization.jsonObject(with: data,
                                                            options: .mutableContainers) as? [[String: Any]] else {
            return
        }
        
        var count = 0
        print("Creating cards: \(count)/\(array.count) \(Date())")
        
        var cards = [CMCard]()
        for dict in array {
            cards.append(processCardData(dict: dict, languageCode: nil))
            count += 1
            
            if count % printMilestone == 0 {
                print("Creating cards: \(count)/\(array.count) \(Date())")
            }
        }

        print("Writing data...")
        try! realm.write {
            for x in cachedLanguages {
                realm.add(x)
            }
            for x in cachedCardTypes {
                realm.add(x)
            }
            for x in cachedSets {
                realm.add(x)
            }
            for x in cachedCardColors {
                realm.add(x)
            }
            for x in cachedBorderColors {
                realm.add(x)
            }
            for x in cachedLayouts {
                realm.add(x)
            }
            for x in cachedArtists {
                realm.add(x)
            }
            for x in cachedFrames {
                realm.add(x)
            }
            for x in cachedFrameEffects {
                realm.add(x)
            }
            for x in cachedRarities {
                realm.add(x)
            }
            for x in cachedWatermarks {
                realm.add(x)
            }
            for x in cachedFormats {
                realm.add(x)
            }
            for x in cachedLegalities {
                realm.add(x)
            }
            for x in cachedRulings {
                realm.add(x)
            }
            for x in cards {
                realm.add(x)
                
                // append card to its set
                if let set = x.set {
                    set.cards.append(x)
                    realm.add(x)
                }
            }
            print("Done writing data. \(Date())")
        }
    }
    
    private func processCardData(dict: [String: Any], languageCode: String? ) -> CMCard {
        let card = CMCard()
        
        // arena id
        card.arenaID = dict["arena_id"] as? String
        
        // id
        card.id = dict["id"] as? String
        card.internalId = UUID().uuidString
        
        // mtgo
        card.mtgoID = dict["mtgo_id"] as? String
        card.mtgoFoilID = dict["mtgo_foil_id"] as? String
        
        // multiverseIds
        if let multiverseIds = dict["multiverse_ids"] as? [Int] {
            card.multiverseIDs = NSKeyedArchiver.archivedData(withRootObject: multiverseIds)
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
            card.imageURIs = binaryImageURIs
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
            if !l.sets.contains(s) {
                l.sets.append(s)
            }
        }
    
        // type line
        if let type = dict["type_line"] as? String {
            if let l = findLanguage(with: languageCode ?? dict["lang"] as? String ?? "en"),
                let x = findCardType(with: type, language: l) {
                card.typeLine = x
            }
        }
    
        // printed type line
        if let type = dict["printed_type_line"] as? String {
            if let l = findLanguage(with: languageCode ?? dict["lang"] as? String ?? "en"),
                let x = findCardType(with: type, language: l) {
                card.printedTypeLine = x
            }
        }
    
        // colors
        if let colors = dict["colors"] as? [String] {
            for color in colors {
                if let x = findCardColor(with: color) {
                    card.colors.append(x)
                }
            }
        }
    
        // color identities
        if let colors = dict["color_identity"] as? [String] {
            for color in colors {
                if let x = findCardColor(with: color) {
                    card.colorIdentities.append(x)
                }
            }
        }
    
        // color identities
        if let colors = dict["color_indicator"] as? [String] {
            for color in colors {
                if let x = findCardColor(with: color) {
                    card.colorIndicators.append(x)
                }
            }
        }
    
        // border color
        if let borderColor = dict["border_color"] as? String,
            let x = findCardBorderColor(with: borderColor) {
            card.borderColor = x
        }
    
        // layout
        if let layout = dict["layout"] as? String,
            let x = findCardLayout(with: layout) {
            card.layout = x
        }
    
        // artist
        if let artist = dict["artist"] as? String,
            let x = findArtist(with: artist) {
            card.artist = x
        }
    
        // frame
        if let frame = dict["frame"] as? String,
            let x = findCardFrame(with: frame){
            card.frame = x
        }
    
        // frame effect
        if let frame = dict["frame_effect"] as? String,
            let x = findCardFrameEffect(with: frame){
            card.frameEffect = x
        }
    
        // rarity
        if let rarity = dict["rarity"] as? String,
            let x = findRarity(with: rarity){
            card.rarity = x
        }
    
        // watermark
        if let watermark = dict["watermark"] as? String,
            let x = findCardWatermark(with: watermark){
            card.watermark = x
        }
    
        // legalities
        if let legalities = dict["legalities"] as? [String: Any] {
            for (k,v) in legalities {
                if let v = v as? String,
                    let format = findFormat(with: k),
                    let legality = findLegality(with: v) {

                    let cardLegality = CMCardLegality()
                    cardLegality.format = format
                    cardLegality.legality = legality
                    cardLegality.card = card
                    card.cardLegalities.append(cardLegality)
                }
            }
        }
        
        return card
        
    }

    private func updateCards() {
        guard let path = Bundle.main.path(forResource: cardsFileName,
                                          ofType: "json",
                                          inDirectory: "data") else {
            return
        }
        
        let data = try! Data(contentsOf: URL(fileURLWithPath: path))
        guard let array = try! JSONSerialization.jsonObject(with: data,
                                                            options: .mutableContainers) as? [[String: Any]] else {
            return
        }
        
        var count = 0
        print("Updating cards: \(count)/\(array.count) \(Date())")
        
        try! realm.write {
            for dict in array {
                if let id = dict["id"] as? String {
                    var card: CMCard?
                    
                    // all parts
                    if let allParts = dict["all_parts"] as? [[String: Any]] {
                        if card == nil {
                            card = realm.objects(CMCard.self).filter("id = %@", id).first
                        }
                        
                        if let c = card {
                            for allPart in allParts {
                                if let allPartId = allPart["id"] as? String,
                                    let name = allPart["name"] as? String,
                                    !allPartId.isEmpty {
                                    
                                    if name == c.name {
                                        continue
                                    }
                                    if let part = realm.objects(CMCard.self).filter("id = %@", allPartId).first {
                                        part.part = c
                                        realm.add(part)
                                        c.parts.append(part)
                                    }
                                }
                            }
                        }
                    }
                    
                    // card faces
                    if let cardFaces = dict["card_faces"] as? [[String: Any]],
                        let lang = dict["lang"] as? String {
                        if card == nil {
                            card = realm.objects(CMCard.self).filter("id = %@", id).first
                        }
                        
                        if let c = card {
                            var index = 0
                            for cardFace in cardFaces {
                                let face = processCardData(dict: cardFace,
                                                           languageCode: lang)
                                face.face = c
                                face.set = c.set
                                face.language = c.language
                                face.faceOrder = Int32(index)
                                realm.add(face)
                                c.faces.append(face)

                                index += 1
                            }
                        }
                    }
                    
                    if let card = card {
                        realm.add(card)
                    }
                    count += 1
                    if count % printMilestone == 0 {
                        print("Updating cards: \(count)/\(array.count) \(Date())")
                    }
                    
                }
            }
        }
    }
/*
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
*/
    // MARK: Rulings
    func createCardRulings() {
        guard let path = Bundle.main.path(forResource: rulingsFileName,
                                          ofType: "json",
                                          inDirectory: "data") else {
            return
        }
        
        let data = try! Data(contentsOf: URL(fileURLWithPath: path))
        guard let array = try! JSONSerialization.jsonObject(with: data,
                                                            options: .mutableContainers) as? [[String: Any]] else {
            return
        }
        
        var count = 0
        print("Creating rulings: \(count)/\(array.count) \(Date())")
        
        
        try! realm.write {
            // delete existing cardRulings first
            for object in realm.objects(CMCardRuling.self) {
                realm.delete(object)
            }
            for object in realm.objects(CMRuling.self) {
                realm.delete(object)
            }
        
            for dict in array {
                if let oracleID = dict["oracle_id"] as? String,
                    let publishedAt = dict["published_at"] as? String,
                    let comment = dict["comment"] as? String {
                    
                    let ruling = findRuling(withDate: publishedAt, andText: comment)
                    
                    for card in realm.objects(CMCard.self).filter("oracleID == %@", oracleID) {
                        let cardRuling = CMCardRuling()
                            
                        cardRuling.ruling = ruling
                        cardRuling.card = card
                        card.cardRulings.append(cardRuling)
                    }
                
                    count += 1
                    if count % printMilestone == 0 {
                        print("Creating rulings: \(count)/\(array.count) \(Date())")
                    }
                }
            }
        }
    }
}
