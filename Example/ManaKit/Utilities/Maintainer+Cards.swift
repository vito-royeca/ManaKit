//
//  ScryfallMaintainer.swift
//  ManaKit
//
//  Created by Jovito Royeca on 21.10.18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import ManaKit
import PromiseKit
import RealmSwift

extension Maintainer {
    func createCards() -> Promise<Void> {
        return Promise { seal in
            firstly {
                self.fetchAllCards()
            }.then {
                self.saveCards()
            }.then {
                self.updateCards()
            }.then {
                self.updateCards2()
            }.then {
                self.updateCards3()
            }.done {
                seal.fulfill(())
            }.catch { error in
                seal.reject(error)
            }
        }
    }
    
    private func fetchAllCards() -> Promise<Void> {
        return Promise { seal in
            guard let cachePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first else {
                fatalError("Malformed cachePath")
            }
            let cardsPath = "\(cachePath)/\(ManaKit.Constants.ScryfallDate)_\(cardsFileName)"
            let willFetch = !FileManager.default.fileExists(atPath: cardsPath)
            
            if willFetch {
                guard let urlString = "https://archive.scryfall.com/json/\(cardsFileName)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                    let url = URL(string: urlString) else {
                    fatalError("Malformed url")
                }
                var rq = URLRequest(url: url)
                rq.httpMethod = "GET"
                
                print("Fetching Scryfall cards... \(urlString)")
                firstly {
                    URLSession.shared.dataTask(.promise, with:rq)
                }.compactMap {
                    try JSONSerialization.jsonObject(with: $0.data) as? [[String: Any]]
                }.done { json in
                    if let outputStream = OutputStream(toFileAtPath: cardsPath, append: false) {
                        print("Writing Scryfall cards... \(cardsPath)")
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
    
    private func saveCards() -> Promise<Void> {
        return Promise { seal in
            guard let cachePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first else {
                fatalError("Malformed cachePath")
            }
            let cardsPath = "\(cachePath)/\(ManaKit.Constants.ScryfallDate)_\(cardsFileName)"
            
            let data = try! Data(contentsOf: URL(fileURLWithPath: cardsPath))
            guard let array = try! JSONSerialization.jsonObject(with: data,
                                                                options: .mutableContainers) as? [[String: Any]] else {
                fatalError("Malformed data")
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
                seal.fulfill(())
            }
        }
    }
    
    private func processCardData(dict: [String: Any], languageCode: String?) -> CMCard {
        let card = CMCard()
        
        // arena id
        card.arenaID = dict["arena_id"] as? String
        
        // id
        card.id = dict["id"] as? String
        card.internalID = cardPrimaryKey
        cardPrimaryKey += 1

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
        
        // TCGPlayer
        if let tcgPlayerID = dict["tcgplayer_id"] as? Int {
            card.tcgPlayerID = Int32(tcgPlayerID)
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

    private func updateCards() -> Promise<Void> {
        return Promise { seal in
            guard let cachePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first else {
                fatalError("Malformed cachePath")
            }
            let cardsPath = "\(cachePath)/\(ManaKit.Constants.ScryfallDate)_\(cardsFileName)"
            
            let data = try! Data(contentsOf: URL(fileURLWithPath: cardsPath))
            guard let array = try! JSONSerialization.jsonObject(with: data,
                                                                options: .mutableContainers) as? [[String: Any]] else {
                fatalError("Malformed data")
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
                seal.fulfill(())
            }
        }
    }

    func updateCards2() -> Promise<Void> {
        return Promise { seal in
            let predicate = NSPredicate(format: "id != nil")
            let sortDescriptors = [SortDescriptor(keyPath: "set.releaseDate", ascending: true),
                                   SortDescriptor(keyPath: "name", ascending: true)]
            
            var count = 0
            let cards = realm.objects(CMCard.self).filter(predicate).sorted(by: sortDescriptors)
            print("Updating cards2: \(count)/\(cards.count) \(Date())")
            
            try! realm.write {
                for card in cards {
                    // variations
                    createVariations(ofCard: card)
                
                    // other languages
                    createOtherLanguages(ofCard: card)
                    
                    // other printingss
                    createOtherPrintings(ofCard: card)

                    count += 1
                    if count % printMilestone == 0 {
                        print("Updating cards2: \(count)/\(cards.count) \(Date())")
                    }
                }

                seal.fulfill(())
            }
        }
    }

    func updateCards3() -> Promise<Void> {
        return Promise { seal in
            let sortDescriptors = [SortDescriptor(keyPath: "set.releaseDate", ascending: true),
                                   SortDescriptor(keyPath: "name", ascending: true)]
            let cards = realm.objects(CMCard.self).filter("id != nil").sorted(by: sortDescriptors)
            var count = 0
            print("Updating cards3: \(count)/\(cards.count) \(Date())")
            
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
                        for type in CardType.allCases {
                            for n in name.components(separatedBy: " ") {
                                let desc = type.description
                                if n == desc && !types.contains(desc) {
                                    types.append(desc)
                                }
                            }
                        }
                        
                        if types.count == 1 {
                            card.myType = findCardType(with: types.first!,
                                                       language: enLanguage!)
                        } else if types.count > 1 {
                            card.myType = findCardType(with: "Multiple",
                                                       language: enLanguage!)
                        }
                    }
                    
                    // Firebase id = set.code + _ + card.name + _ + number? + _ + languageCode
                    if let _ = card.id,
                        let set = card.set,
                        let setCode = set.code,
                        let language = card.language,
                        let languageCode = language.code,
                        let name = card.name {
                        var firebaseID = "\(setCode.uppercased())_\(name)"
                        
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
                                    firebaseID += "_\(index)"
                                    break
                                } else {
                                    index += 1
                                }
                            }
                        }
                        
                        // add language code for non-english cards
                        if languageCode != "en" {
                            firebaseID += "_\(languageCode)"
                        }
                        
                        card.firebaseID = ManaKit.sharedInstance.encodeFirebase(key: firebaseID)
                    }
                    
                    realm.add(card)
                    
                    count += 1
                    if count % printMilestone == 0 {
                        print("Updating cards3: \(count)/\(cards.count) \(Date())")
                    }
                }
                
                seal.fulfill(())
            }
        }
    }

    private func createVariations(ofCard card: CMCard) {
        if let set = card.set,
            let code = set.code,
            let language = card.language,
            let languageCode = language.code,
            let id = card.id,
            let name = card.name {
            let predicate = NSPredicate(format: "set.code = %@ AND language.code = %@ AND id != %@ AND name = %@",
                                        code,
                                        languageCode,
                                        id,
                                        name)
            let sortDescriptors = [SortDescriptor(keyPath: "set.releaseDate", ascending: true),
                                   SortDescriptor(keyPath: "name", ascending: true)]
            let filteredCards = realm.objects(CMCard.self).filter(predicate).sorted(by: sortDescriptors)
            
            for card in filteredCards {
                card.variations.append(card)
                realm.add(card)
            }
        }
    }

    private func createOtherLanguages(ofCard card: CMCard) {
        if let language = card.language,
            let languageCode = language.code,
            let id = card.id,
            let name = card.name {
            let predicate = NSPredicate(format: "language.code != %@ AND id != %@ AND name = %@",
                                        languageCode,
                                        id,
                                        name)
            let sortDescriptors = [SortDescriptor(keyPath: "set.releaseDate", ascending: true),
                                   SortDescriptor(keyPath: "name", ascending: true)]
            let filteredCards = realm.objects(CMCard.self).filter(predicate).sorted(by: sortDescriptors)
            
            for card in filteredCards {
                card.otherLanguages.append(card)
                realm.add(card)
            }
        }
    }

    private func createOtherPrintings(ofCard card: CMCard) {
        if let set = card.set,
            let setCode = set.code,
            let language = card.language,
            let languageCode = language.code,
            let id = card.id,
            let name = card.name {
            let predicate = NSPredicate(format: "set.code != %@ AND language.code == %@ AND id != %@ && name == %@",
                                        setCode,
                                        languageCode,
                                        id,
                                        name)
            let sortDescriptors = [SortDescriptor(keyPath: "set.releaseDate", ascending: true),
                                   SortDescriptor(keyPath: "name", ascending: true)]
            let filteredCards = realm.objects(CMCard.self).filter(predicate).sorted(by: sortDescriptors)
            
            for card in filteredCards {
                card.otherPrintings.append(card)
                realm.add(card)
            }
        }
    }
}
