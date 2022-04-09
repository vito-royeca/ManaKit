//
//  ManaKit+Sync.swift
//  ManaKit
//
//  Created by Vito Royeca on 3/10/22.
//

import Foundation
import CoreData

extension ManaKit {
    public func syncToCoreData<T: MEntity>(_ entities: [T]) {
        if let sets = entities as? [MSet] {
            sync(sets)
        } else if let cards = entities as? [MCard] {
            sync(cards)
        }
    }
    
    func sync(_ sets: [MSet]) {
        let context = viewContext
        
        for set in sets {
            let _ = self.set(from: set, context: context, type: MGSet.self)
        }
        save(context: context)
    }
    
    func sync(_ cards: [MCard]) {
        let context = viewContext
        
        for card in cards {
            let _ = self.card(from: card, context: context, type: MGCard.self)
        }
        save(context: context)
    }
    
    func nameSection(for name: String) -> String? {
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
        if let nameSection = card.nameSection {
            props["nameSection"] = nameSection
        }
        if let numberOrder = card.numberOrder {
            props["numberOrder"] = numberOrder
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
        if let releaseDate = card.releaseDate {
            props["releaseDate"] = releaseDate
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
            for x in card.colors ?? [] {
                if let y = color(from: x, context: context, type: MGColor.self) {
                    newCard.addToColors(y)
                }
            }
            for x in card.colorIdentities ?? [] {
                if let y = color(from: x, context: context, type: MGColor.self) {
                    newCard.addToColorIdentities(y)
                }
            }
            for x in card.colorIndicators ?? [] {
                if let y = color(from: x, context: context, type: MGColor.self) {
                    newCard.addToColorIndicators(y)
                }
            }
            for x in card.componentParts ?? [] {
                if let y = componentPart(from: x, part: card, context: context, type: MGCardComponentPart.self) {
                    newCard.addToComponentParts(y)
                }
            }
            for x in card.faces ?? [] {
                if let y = self.card(from: x, context: context, type: MGCard.self) {
                    newCard.addToFaces(y)
                }
            }
            for x in card.formatLegalities ?? [] {
                if let y = formatLegality(from: x, part: card, context: context, type: MGCardFormatLegality.self) {
                    newCard.addToFormatLegalities(y)
                }
            }
            if let x = card.frame {
                newCard.frame = frame(from: x, context: context, type: MGFrame.self)
            }
            for x in card.frameEffects ?? [] {
                if let y = frameEffect(from: x, context: context, type: MGFrameEffect.self) {
                    newCard.addToFrameEffects(y)
                }
            }
            for x in card.imageURIs ?? [] {
                if let y = imageURI(from: x, context: context, type: MGImageURI.self) {
                    newCard.addToImageURIs(y)
                }
            }
            if let x = card.language {
                newCard.language = language(from: x, context: context, type: MGLanguage.self)
            }
            if let x = card.layout {
                newCard.layout = layout(from: x, context: context, type: MGLayout.self)
            }
            for x in card.otherLanguages ?? [] {
                if let y = self.card(from: x, context: context, type: MGCard.self) {
                    newCard.addToOtherLanguages(y)
                }
            }
            for x in card.otherPrintings ?? [] {
                if let y = self.card(from: x, context: context, type: MGCard.self) {
                    newCard.addToOtherPrintings(y)
                }
            }
            for x in newCard.prices?.allObjects as? [MGCardPrice] ?? [] {
                newCard.removeFromPrices(x)
            }
            for x in card.prices ?? [] {
                if let y = self.price(from: x, context: context, type: MGCardPrice.self) {
                    newCard.addToPrices(y)
                }
            }
            if let x = card.rarity {
                newCard.rarity = rarity(from: x, context: context, type: MGRarity.self)
            }
            for x in card.rulings ?? [] {
                if let y = self.ruling(from: x, context: context, type: MGRuling.self) {
                    newCard.addToRulings(y)
                }
            }
            if let x = card.set {
                newCard.set = set(from: x, context: context, type: MGSet.self)
            }
            for x in card.subtypes ?? [] {
                if let y = self.cardType(from: x, context: context, type: MGCardType.self) {
                    newCard.addToSubtypes(y)
                }
            }
            for x in card.supertypes ?? [] {
                if let y = self.cardType(from: x, context: context, type: MGCardType.self) {
                    newCard.addToSupertypes(y)
                }
            }
            if let x = (card.supertypes ?? []).sorted(by: { $0.name < $1.name }).filter({ $0.name != "Legendary" && $0.name != "Basic" }).first  {
                if let y = self.type(from: x, context: context, type: MGCardType.self) {
                    newCard.type = y
                }
            }
            for x in card.variations ?? [] {
                if let y = self.card(from: x, context: context, type: MGCard.self) {
                    newCard.addToVariations(y)
                }
            }
            if let x = card.watermark {
                newCard.watermark = watermark(from: x, context: context, type: MGWatermark.self)
            }
            
            return newCard as? T
        } else {
            return nil
        }
    }
    
    // MARK: - CardType
    func cardType<T: MGEntity>(from cardType: MCardType, context: NSManagedObjectContext, type: T.Type) -> T? {
        var props = [String: Any]()
        
        props["name"] = cardType.name
        if let nameSection = cardType.nameSection {
            props["nameSection"] = nameSection
        } else {
            props["nameSection"] = nameSection(for: cardType.name)
        }
        
        let predicate = NSPredicate(format: "name = %@", cardType.name)
        
        return find(type,
                    properties: props,
                    predicate: predicate,
                    sortDescriptors: nil,
                    createIfNotFound: true,
                    context: context)?.first
    }
    
    // MARK: - Color
    func color<T: MGEntity>(from color: MColor, context: NSManagedObjectContext, type: T.Type) -> T? {
        var props = [String: Any]()
        
        props["name"] = color.name
        if let nameSection = color.nameSection {
            props["nameSection"] = nameSection
        } else {
            props["nameSection"] = nameSection(for: color.name)
        }
        
        switch color.name {
        case "Black":
            props["symbol"] = "B"
        case "Blue":
            props["symbol"] = "U"
        case "Green":
            props["symbol"] = "G"
        case "Red":
            props["symbol"] = "R"
        case "White":
            props["symbol"] = "W"
        default:
            ()
        }
        
        let predicate = NSPredicate(format: "name = %@", color.name)
        
        return find(type,
                    properties: props,
                    predicate: predicate,
                    sortDescriptors: nil,
                    createIfNotFound: true,
                    context: context)?.first
    }
    
    // MARK: - Component
    func component<T: MGEntity>(from component: MComponent, context: NSManagedObjectContext, type: T.Type) -> T? {
        var props = [String: Any]()
        
        props["name"] = component.name
        if let nameSection = component.nameSection {
            props["nameSection"] = nameSection
        } else {
            props["nameSection"] = nameSection(for: component.name)
        }
        
        let predicate = NSPredicate(format: "name = %@", component.name)
        
        return find(type,
                    properties: props,
                    predicate: predicate,
                    sortDescriptors: nil,
                    createIfNotFound: true,
                    context: context)?.first
    }
    
    // MARK: - ComponentPart
    func componentPart<T: MGEntity>(from componentPart: MComponentPart, part: MCard, context: NSManagedObjectContext, type: T.Type) -> T? {
        var props = [String: Any]()
        
        let newID = "\(part.newID)_\(componentPart.card.newID)_\(componentPart.component.name)"
        props["id"] = newID
        props["part"] = card(from: componentPart.card, context: context, type: MGCard.self)
        props["component"] = component(from: componentPart.component, context: context, type: MGComponent.self)
        
        let predicate = NSPredicate(format: "id = %@", newID)
        
        return find(type,
                    properties: props,
                    predicate: predicate,
                    sortDescriptors: nil,
                    createIfNotFound: true,
                    context: context)?.first
    }
    
    // MARK: - Format
    func format<T: MGEntity>(from format: MFormat, context: NSManagedObjectContext, type: T.Type) -> T? {
        var props = [String: Any]()

        props["name"] = format.name
        if let nameSection = format.nameSection {
            props["nameSection"] = nameSection
        } else {
            props["nameSection"] = nameSection(for: format.name)
        }
        
        let predicate = NSPredicate(format: "name = %@", format.name)
        
        return find(type,
                    properties: props,
                    predicate: predicate,
                    sortDescriptors: nil,
                    createIfNotFound: true,
                    context: context)?.first
    }
    
    // MARK: - FormatLegality
    func formatLegality<T: MGEntity>(from formatLegality: MFormatLegality, part: MCard, context: NSManagedObjectContext, type: T.Type) -> T? {
        var props = [String: Any]()
        
        let newID = "\(part.newID)_\(formatLegality.format.name)_\(formatLegality.legality.name)"
        props["id"] = newID
        props["format"] = format(from: formatLegality.format, context: context, type: MGFormat.self)
        props["legality"] = legality(from: formatLegality.legality, context: context, type: MGLegality.self)
        
        let predicate = NSPredicate(format: "id = %@", newID)
        
        return find(type,
                    properties: props,
                    predicate: predicate,
                    sortDescriptors: nil,
                    createIfNotFound: true,
                    context: context)?.first
    }
    
    // MARK: - Frame
    func frame<T: MGEntity>(from frame: MFrame, context: NSManagedObjectContext, type: T.Type) -> T? {
        var props = [String: Any]()

        props["name"] = frame.name
        if let description_ = frame.description_ {
            props["description_"] = description_
        }
        if let nameSection = frame.nameSection {
            props["nameSection"] = nameSection
        } else {
            props["nameSection"] = nameSection(for: frame.name)
        }
        
        let predicate = NSPredicate(format: "name = %@", frame.name)
        
        return find(type,
                    properties: props,
                    predicate: predicate,
                    sortDescriptors: nil,
                    createIfNotFound: true,
                    context: context)?.first
    }
    
    // MARK: - FrameEffect
    func frameEffect<T: MGEntity>(from frameEffect: MFrameEffect, context: NSManagedObjectContext, type: T.Type) -> T? {
        var props = [String: Any]()

        props["id"] = frameEffect.id
        props["description_"] = frameEffect.description_
        props["name"] = frameEffect.name
        if let nameSection = frameEffect.nameSection {
            props["nameSection"] = nameSection
        } else {
            props["nameSection"] = nameSection(for: frameEffect.name)
        }
        
        let predicate = NSPredicate(format: "id = %@", frameEffect.id)
        
        return find(type,
                    properties: props,
                    predicate: predicate,
                    sortDescriptors: nil,
                    createIfNotFound: true,
                    context: context)?.first
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
            var newDisplayCode: String?
            
            switch language.code {
            case "zhs":
                newDisplayCode = "汉语"
            case "zht":
                newDisplayCode = "漢語"
            default:
                newDisplayCode = displayCode
            }
            props["displayCode"] = newDisplayCode
        }
        if let name = language.name {
            props["name"] = name
        }
        if let nameSection = language.nameSection {
            props["nameSection"] = nameSection
        } else {
            props["nameSection"] = nameSection(for: language.name ?? "")
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
            props["nameSection"] = nameSection
        } else {
            props["nameSection"] = nameSection(for: layout.name)
        }
        
        let predicate = NSPredicate(format: "name = %@", layout.name)
        
        return find(type,
                    properties: props,
                    predicate: predicate,
                    sortDescriptors: nil,
                    createIfNotFound: true,
                    context: context)?.first
    }
    
    // MARK: - Legality
    func legality<T: MGEntity>(from legality: MLegality, context: NSManagedObjectContext, type: T.Type) -> T? {
        var props = [String: Any]()
        props["name"] = legality.name
        if let nameSection = legality.nameSection {
            props["nameSection"] = nameSection
        } else {
            props["nameSection"] = nameSection(for: legality.name)
        }
        
        let predicate = NSPredicate(format: "name = %@", legality.name)
        
        return find(type,
                    properties: props,
                    predicate: predicate,
                    sortDescriptors: nil,
                    createIfNotFound: true,
                    context: context)?.first
    }
    
    // MARK: - Price
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
            props["nameSection"] = nameSection
        } else {
            props["nameSection"] = nameSection(for: rarity.name)
        }
        
        let predicate = NSPredicate(format: "name = %@", rarity.name)
        
        return find(type,
                    properties: props,
                    predicate: predicate,
                    sortDescriptors: nil,
                    createIfNotFound: true,
                    context: context)?.first
    }
    
    // MARK: - Ruling
    func ruling<T: MGEntity>(from ruling: MRuling, context: NSManagedObjectContext, type: T.Type) -> T? {
        var props = [String: Any]()
        props["id"] = ruling.id
        props["datePublished"] = ruling.datePublished
        props["text"] = ruling.text
        
        let predicate = NSPredicate(format: "id = %d", ruling.id)
        
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
        if let logoCode = set.logoCode {
            props["logoCode"] = logoCode
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
        if let nameSection = set.nameSection {
            props["nameSection"] = nameSection
        }
        if let yearSection = set.yearSection {
            props["yearSection"] = yearSection
        }
        if let releaseDate = set.releaseDate {
            props["releaseDate"] = releaseDate
        }
        if let name = set.name {
            props["name"] = name
            props["nameSection"] = nameSection(for: name)
        }
        if let tcgplayerID = set.tcgplayerID {
            props["tcgPlayerID"] = tcgplayerID
        }
        
        let predicate = NSPredicate(format: "code = %@", set.code)
        
        if let newSet = find(type,
                             properties: props,
                             predicate: predicate,
                             sortDescriptors: nil,
                             createIfNotFound: true,
                             context: context)?.first as? MGSet {
            
            if let x = set.parent {
                let parent = MSet(cardCount: nil, code: x, isFoilOnly: nil, isOnlineOnly: nil, logoCode: nil, mtgoCode: nil, keyruneUnicode: nil, keyruneClass: nil, nameSection: nil, yearSection: nil, releaseDate: nil, name: nil, tcgplayerID: nil, parent: nil, setBlock: nil, setType: nil, languages: nil, cards: nil)
                newSet.parent = self.set(from: parent, context: context, type: MGSet.self)
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
            
            return newSet as? T
        } else {
            return nil
        }
    }
    
    // MARK: - SetBlock
    func setBlock<T: MGEntity>(from setBlock: MSetBlock, context: NSManagedObjectContext, type: T.Type) -> T? {
        var props = [String: Any]()
        props["code"] = setBlock.code
        if let displayCode = setBlock.displayCode {
            props["displayCode"] = displayCode
        }
        props["name"] = setBlock.name
        if let nameSection = setBlock.nameSection {
            props["nameSection"] = nameSection
        } else {
            props["nameSection"] = nameSection(for: setBlock.name)
        }
        
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
        if let nameSection = setType.nameSection {
            props["nameSection"] = nameSection
        } else {
            props["nameSection"] = nameSection(for: setType.name)
        }
        
        let predicate = NSPredicate(format: "name = %@", setType.name)
        
        return find(type,
                    properties: props,
                    predicate: predicate,
                    sortDescriptors: nil,
                    createIfNotFound: true,
                    context: context)?.first
    }
    
    // MARK: - Type
    func type<T: MGEntity>(from cardType: MCardType, context: NSManagedObjectContext, type: T.Type) -> T? {
        var props = [String: Any]()
        let name = cardType.name.replacingOccurrences(of: "Legendary", with: "")
            .replacingOccurrences(of: "Basic", with: "")
            .trimmingCharacters(in: .whitespacesAndNewlines)
        
        props["name"] = name
        if let nameSection = cardType.nameSection {
            props["nameSection"] = nameSection
        } else {
            props["nameSection"] = nameSection(for: name)
        }
        
        let predicate = NSPredicate(format: "name = %@", name)
        
        return find(type,
                    properties: props,
                    predicate: predicate,
                    sortDescriptors: nil,
                    createIfNotFound: true,
                    context: context)?.first
    }
    
    // MARK: - Watermark
    func watermark<T: MGEntity>(from watermark: MWatermark, context: NSManagedObjectContext, type: T.Type) -> T? {
        var props = [String: Any]()
        props["name"] = watermark.name
        if let nameSection = watermark.nameSection {
            props["nameSection"] = nameSection
        } else {
            props["nameSection"] = nameSection(for: watermark.name)
        }
        
        let predicate = NSPredicate(format: "name = %@", watermark.name)
        
        return find(type,
                    properties: props,
                    predicate: predicate,
                    sortDescriptors: nil,
                    createIfNotFound: true,
                    context: context)?.first
    }
}

