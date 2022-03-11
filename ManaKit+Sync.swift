//
//  ManaKit+Sync.swift
//  ManaKit
//
//  Created by Vito Royeca on 3/10/22.
//

import Foundation
import CoreData

extension ManaKit {
    func syncToCoreData<T: MEntity>(_ entities: [T]) {
        if let sets = entities as? [MSet] {
            sync(sets)
        } else if let cards = entities as? [MCard] {
            sync(cards)
        }
    }
    
    func sync(_ sets: [MSet]) {
        let context = persistentContainer.viewContext
        
        for set in sets {
            if let newSet = self.set(from: set, context: context, type: MGSet.self) {
                if let x = set.parent {
                    newSet.parent = setParent(from: x, context: context, type: MGSet.self)
                }
                if let x = set.setBlock {
                    newSet.setBlock = setBlock(from: x, context: context, type: MGSetBlock.self)
                }
                if let x = set.setType {
                    newSet.setType = setType(from: x, context: context, type: MGSetType.self)
                }
                for x in set.languages ?? [] {
                    if let y = language(from: x, context: context, type: MGLanguage.self) {
                        newSet.addToLanguages(y)
                    }
                }
                for x in set.cards ?? [] {
                    if let y = card(from: x, context: context, type: MGCard.self) {
                        newSet.addToCards(y)
                    }
                }
            }
        }
        save(context: context)
    }
    
    func sync(_ cards: [MCard]) {
        let context = persistentContainer.viewContext
        
        for card in cards {
            let _ = self.card(from: card, context: context, type: MGCard.self)
        }
        save(context: context)
    }
    
    // MARK: - Artist
    func artist<T: MGEntity>(from artist: MArtist, context: NSManagedObjectContext, type: T.Type) -> T? {
        var props = [String: Any]()
        props["name"] = artist.name
        
        let predicate = NSPredicate(format: "name = %@", artist.name)
        
        return find(type,
                    properties: props,
                    predicate: predicate,
                    sortDescriptors: nil,
                    createIfNotFound: true,
                    context: context)?.first
    }
    
    // MARK: - SetType
    func card<T: MGEntity>(from card: MCard, context: NSManagedObjectContext, type: T.Type) -> T? {
//        if let baseID = baseID,
//            card.newID == baseID {
//            return nil
//        }

        var props = [String: Any]()
        if let collectorNumber = card.collectorNumber {
            props["collectorNumber"] = collectorNumber
        }
        if let cmc = card.cmc {
            props["cmc"] = cmc
        }
        if let faceOrder = card.faceOrder {
            props["faceOrder"] = faceOrder
        }
        if let flavorText = card.flavorText {
            props["flavorText"] = flavorText
        }
        if let isFoil = card.isFoil {
            props["isFoil"] = isFoil
        }
        if let isFullArt = card.isFullArt {
            props["isFullArt"] = isFullArt
        }
        if let isHighresImage = card.isHighresImage {
            props["isHighResImage"] = isHighresImage
        }
        if let isNonfoil = card.isNonfoil {
            props["isNonFoil"] = isNonfoil
        }
        if let isOversized = card.isOversized {
            props["isOversized"] = isOversized
        }
        if let isReserved = card.isReserved {
            props["isReserved"] = isReserved
        }
        if let isStorySpotlight = card.isStorySpotlight {
            props["isStorySpotlight"] = isStorySpotlight
        }
        if let loyalty = card.loyalty {
            props["loyalty"] = loyalty
        }
        if let manaCost = card.manaCost {
            props["manaCost"] = manaCost
        }
        if let myNameSection = card.myNameSection {
            props["myNameSection"] = myNameSection.rawValue
        }
        if let myNumberOrder = card.myNumberOrder {
            props["myNumberOrder"] = myNumberOrder
        }
        if let name = card.name {
            props["name"] = name
        }
        if let oracleText = card.oracleText {
            props["oracleText"] = oracleText
        }
        if let power = card.power {
            props["power"] = power
        }
        if let printedName = card.printedName {
            props["printedName"] = printedName
        }
        if let printedText = card.printedText {
            props["printedText"] = printedText
        }
        if let toughness = card.toughness {
            props["toughness"] = toughness
        }
        if let arenaID = card.arenaID {
            props["arenaID"] = arenaID
        }
        if let mtgoID = card.mtgoID {
            props["mtgoID"] = mtgoID
        }
        if let tcgplayerID = card.tcgplayerID {
            props["tcgPlayerID"] = tcgplayerID
        }
        if let handModifier = card.handModifier {
            props["handModifier"] = handModifier
        }
        if let lifeModifier = card.lifeModifier {
            props["lifeModifier"] = lifeModifier
        }
        if let isBooster = card.isBooster {
            props["isBooster"] = isBooster
        }
        if let isDigital = card.isDigital {
            props["isDigital"] = isDigital
        }
        if let isPromo = card.isPromo {
            props["isPromo"] = isPromo
        }
        if let releasedAt = card.releasedAt {
            props["releasedAt"] = releasedAt
        }
        if let isTextless = card.isTextless {
            props["isTextless"] = isTextless
        }
        if let mtgoFoilID = card.mtgoFoilID {
            props["mtgoFoilID"] = mtgoFoilID
        }
        if let isReprint = card.isReprint {
            props["isReprint"] = isReprint
        }
        props["newID"] = card.newID
        if let printedTypeLine = card.printedTypeLine {
            props["printedTypeLine"] = printedTypeLine
        }
        if let typeLine = card.typeLine {
            props["typeLine"] = typeLine
        }
        if let multiverseIDs = card.multiverseIDs {
            do {
                props["multiverseIDs"] = try NSKeyedArchiver.archivedData(withRootObject: multiverseIDs, requiringSecureCoding: false)
            } catch {
                print(error)
            }
        }
        
        let predicate = NSPredicate(format: "newID = %@", card.newID)
        
        if let newCard = find(type,
                              properties: props,
                              predicate: predicate,
                              sortDescriptors: nil,
                              createIfNotFound: true,
                              context: context)?.first as? MGCard {
            if let x = card.artist {
                newCard.artist = artist(from: x, context: context, type: MGArtist.self)
            }
//            for x in card.faces ?? [] {
//                if let y = self.card(from: x, context: context, type: MGCard.self) {
//                    newCard.addToFaces(y)
//                }
//            }
            for x in card.imageURIs ?? [] {
                newCard.imageURI = imageURI(from: x, context: context, type: MGImageURI.self)
            }
            if let x = card.language {
                newCard.language = language(from: x, context: context, type: MGLanguage.self)
            }
            if let x = card.layout {
                newCard.layout = layout(from: x, context: context, type: MGLayout.self)
            }
//            for x in card.otherLanguages ?? [] {
//                if let y = self.card(from: x, context: context, type: MGCard.self) {
//                    newCard.addToOtherLanguages(y)
//                }
//            }
//                for x in card.otherPrintings ?? [] {
//                    if let y = self.card(from: x, baseID: card.newID, context: context, type: MGCard.self) {
//                        newCard.addToOtherPrintings(y)
//                    }
//                }
            for x in card.prices ?? [] {
                if let y = price(from: x, context: context, type: MGCardPrice.self) {
                    newCard.addToPrices(y)
                }
            }
            if let x = card.rarity {
                newCard.rarity = rarity(from: x, context: context, type: MGRarity.self)
            }
//            for x in card.variations ?? [] {
//                if let y = self.card(from: x, context: context, type: MGCard.self) {
//                    newCard.addToVariations(y)
//                }
//            }
            if let x = card.watermark {
                newCard.watermark = watermark(from: x, context: context, type: MGWatermark.self)
            }
            
//        let frame: MFrame?
//        let colors, colorIdentities, colorIndicators: [MColor]?
//        let componentParts: [MComponentPart]?
//        let faces: [MCard]?
//        let formatLegalities: [MFormatLegality]?
//        let frameEffects: [MFrameEffect]?
//        let subtypes, supertypes: [MType]?
//        let rulings: [MRuling]?

            return newCard as? T
        } else {
            return nil
        }
    }
    
    // MARK: - ImageURI
    func imageURI<T: MGEntity>(from imageURI: MImageURI, context: NSManagedObjectContext, type: T.Type) -> T? {
        var props = [String: Any]()
        props["artCrop"] = imageURI.artCrop
        props["normal"] = imageURI.normal
        props["png"] = imageURI.png
        
        let predicate = NSPredicate(format: "artCrop = %@ AND normal = %@ AND png = %@", imageURI.artCrop, imageURI.normal, imageURI.png)
        
        return find(type,
                    properties: props,
                    predicate: predicate,
                    sortDescriptors: nil,
                    createIfNotFound: true,
                    context: context)?.first
    }
    
    // MARK: - Language
    func language<T: MGEntity>(from language: MLanguage, context: NSManagedObjectContext, type: T.Type) -> T? {
        var props = [String: Any]()
        props["code"] = language.code
        if let displayCode = language.displayCode {
            props["displayCode"] = displayCode.rawValue
        }
        if let name = language.name {
            props["name"] = name
        }
        if let nameSection = language.nameSection {
            props["nameSection"] = nameSection.rawValue
        }
        
        let predicate = NSPredicate(format: "code = %@", language.code)
        
        return find(type,
                    properties: props,
                    predicate: predicate,
                    sortDescriptors: nil,
                    createIfNotFound: true,
                    context: context)?.first
    }

    // MARK: - Layout
    func layout<T: MGEntity>(from layout: MLayout, context: NSManagedObjectContext, type: T.Type) -> T? {
        var props = [String: Any]()
        props["name"] = layout.name
        if let description_ = layout.description_ {
            props["description_"] = description_
        }
        if let nameSection = layout.nameSection {
            props["nameSection"] = nameSection.rawValue
        }
        
        let predicate = NSPredicate(format: "name = %@", layout.name)
        
        return find(type,
                    properties: props,
                    predicate: predicate,
                    sortDescriptors: nil,
                    createIfNotFound: true,
                    context: context)?.first
    }
    
    // MARK: - Layout
    func price<T: MGEntity>(from price: MPrice, context: NSManagedObjectContext, type: T.Type) -> T? {
        var props = [String: Any]()
        if let id = price.id {
            props["id"] = id
        }
        if let low = price.low {
            props["low"] = low
        }
        if let median = price.median {
            props["median"] = median
        }
        if let high = price.high {
            props["high"] = high
        }
        if let market = price.market {
            props["market"] = market
        }
        if let directLow = price.directLow {
            props["directLow"] = directLow
        }
        props["isFoil"] = price.isFoil
        if let dateUpdated = price.dateUpdated {
            props["dateUpdated"] = dateUpdated
        }
        
        let predicate = NSPredicate(format: "id = %d", price.id ?? "")
        
        return find(type,
                    properties: props,
                    predicate: predicate,
                    sortDescriptors: nil,
                    createIfNotFound: true,
                    context: context)?.first
    }
    
    // MARK: - Rarity
    func rarity<T: MGEntity>(from rarity: MRarity, context: NSManagedObjectContext, type: T.Type) -> T? {
        var props = [String: Any]()
        props["name"] = rarity.name
        if let nameSection = rarity.nameSection {
            props["nameSection"] = nameSection.rawValue
        }
        
        let predicate = NSPredicate(format: "name = %@", rarity.name)
        
        return find(type,
                    properties: props,
                    predicate: predicate,
                    sortDescriptors: nil,
                    createIfNotFound: true,
                    context: context)?.first
    }
    
    // MARK: - Set
    func set<T: MGEntity>(from set: MSet, context: NSManagedObjectContext, type: T.Type) -> T? {
        var props = [String: Any]()
        if let cardCount = set.cardCount {
            props["cardCount"] = cardCount
        }
        props["code"] = set.code
        if let isFoilOnly = set.isFoilOnly {
            props["isFoilOnly"] = isFoilOnly
        }
        if let isOnlineOnly = set.isOnlineOnly {
            props["isOnlineOnly"] = isOnlineOnly
        }
        if let mtgoCode = set.mtgoCode {
            props["mtgoCode"] = mtgoCode
        }
        if let keyruneUnicode = set.keyruneUnicode {
            props["keyruneUnicode"] = keyruneUnicode
        }
        if let keyruneClass = set.keyruneClass {
            props["keyruneClass"] = keyruneClass
        }
        if let myNameSection = set.myNameSection {
            props["myNameSection"] = myNameSection.rawValue
        }
        if let myYearSection = set.myYearSection {
            props["myYearSection"] = myYearSection
        }
        if let releaseDate = set.releaseDate {
            props["releaseDate"] = releaseDate
        }
        props["name"] = set.name
        if let tcgplayerID = set.tcgplayerID {
            props["tcgPlayerID"] = tcgplayerID
        }
        
        let predicate = NSPredicate(format: "code = %@", set.code)
        
        return find(type,
                    properties: props,
                    predicate: predicate,
                    sortDescriptors: nil,
                    createIfNotFound: true,
                    context: context)?.first
    }
    
    // MARK: - SetParent
    func setParent<T: MGEntity>(from setParent: MParent, context: NSManagedObjectContext, type: T.Type) -> T? {
        var props = [String: Any]()
        props["code"] = setParent.code
        
        let predicate = NSPredicate(format: "code = %@", setParent.code)
        
        return find(type,
                    properties: props,
                    predicate: predicate,
                    sortDescriptors: nil,
                    createIfNotFound: true,
                    context: context)?.first
    }
    
    // MARK: - SetBlock
    func setBlock<T: MGEntity>(from setBlock: MSetBlock, context: NSManagedObjectContext, type: T.Type) -> T? {
        var props = [String: Any]()
        props["code"] = setBlock.code
        if let displayCode = setBlock.displayCode {
            props["displayCode"] = displayCode
        }
        props["name"] = setBlock.name
        props["nameSection"] = setBlock.nameSection.rawValue
        
        let predicate = NSPredicate(format: "code = %@", setBlock.code)
        
        return find(type,
                    properties: props,
                    predicate: predicate,
                    sortDescriptors: nil,
                    createIfNotFound: true,
                    context: context)?.first
    }
    
    // MARK: - SetType
    func setType<T: MGEntity>(from setType: MSetType, context: NSManagedObjectContext, type: T.Type) -> T? {
        var props = [String: Any]()
        props["name"] = setType.name
        props["nameSection"] = setType.nameSection.rawValue
        
        let predicate = NSPredicate(format: "name = %@", setType.name)
        
        return find(type,
                    properties: props,
                    predicate: predicate,
                    sortDescriptors: nil,
                    createIfNotFound: true,
                    context: context)?.first
    }
    
    // MARK: - Layout
    func watermark<T: MGEntity>(from watermark: MWatermark, context: NSManagedObjectContext, type: T.Type) -> T? {
        var props = [String: Any]()
        props["name"] = watermark.name
        props["nameSection"] = watermark.nameSection.rawValue
        
        let predicate = NSPredicate(format: "name = %@", watermark.name)
        
        return find(type,
                    properties: props,
                    predicate: predicate,
                    sortDescriptors: nil,
                    createIfNotFound: true,
                    context: context)?.first
    }
}

