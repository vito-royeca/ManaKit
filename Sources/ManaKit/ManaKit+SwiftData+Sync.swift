//
//  ManaKit+SwiftData+Sync.swift
//
//
//  Created by Miguel Ponce de Monio III on 2/9/24.
//

import Foundation
import SwiftData

extension ManaKit {
    public func syncToSwiftData<T: MEntity, U: SDEntity>(_ jsonData: [T],
                                                        jsonType: T.Type,
                                                        swiftDataType: U.Type,
                                                        sortDescriptors: [SortDescriptor<U>]?) -> [U]? {
        let context = sdBackgroundContext
        var results = [U]()

        for json in jsonData {
            if let json = json as? MArtist {
                if let entity = self.artist(from: json, context: context, type: SDArtist.self),
                    let result = entity as? U {
                    results.append(result)
                }
            } else if let json = json as? MCard {
                if let entity = self.card(from: json, context: context, type: SDCard.self),
                   let result = entity as? U {
                   results.append(result)
               }
            } /*else if let json = json as? MColor {
                if let entity = self.color(from: json, context: context, type: SDColor.self),
                   let result = entity as? U {
                   results.append(result)
               }
            } else if let json = json as? MComponent {
                if let entity = self.component(from: json, context: context, type: SDComponent.self),
                   let result = entity as? U {
                   results.append(result)
               }
            }*/ /* else if let json = json as? MComponentPart {
              func componentPart<T: MGEntity>(from componentPart: MComponentPart, part: MCard, context: NSManagedObjectContext, type: T.Type)
            }*/ /*else if let json = json as? MFormat {
                if let entity = self.format(from: json, context: context, type: SDFormat.self),
                   let result = entity as? U {
                   results.append(result)
               }
            }*/ /* else if let json = json as? MFormatLegality {
              func formatLegality<T: MGEntity>(from formatLegality: MFormatLegality, part: MCard, context: NSManagedObjectContext, type: T.Type) -> T?
            }*/ /*else if let json = json as? MFrame {
                if let entity = self.frame(from: json, context: context, type: SDFrame.self),
                   let result = entity as? U {
                   results.append(result)
               }
            } else if let json = json as? MFrameEffect {
                if let entity = self.frameEffect(from: json, context: context, type: SDFrameEffect.self),
                   let result = entity as? U {
                   results.append(result)
               }
            } else if let json = json as? MGame {
                if let entity = self.game(from: json, context: context, type: SDGame.self),
                   let result = entity as? U {
                   results.append(result)
               }
            } else if let json = json as? MKeyword {
                if let entity = self.keyword(from: json, context: context, type: SDKeyword.self),
                   let result = entity as? U {
                   results.append(result)
               }
            } */else if let json = json as? MLanguage {
                if let entity = self.language(from: json, context: context, type: SDLanguage.self),
                   let result = entity as? U {
                   results.append(result)
               }
            } /*else if let json = json as? MLayout {
                if let entity = self.layout(from: json, context: context, type: SDLayout.self),
                   let result = entity as? U {
                   results.append(result)
               }
            } else if let json = json as? MLegality {
                if let entity = self.legality(from: json, context: context, type: SDLegality.self),
                   let result = entity as? U {
                   results.append(result)
               }
            } else if let json = json as? MPrice {
                if let entity = self.price(from: json, context: context, type: SDCardPrice.self),
                   let result = entity as? U {
                   results.append(result)
               }
            } else if let json = json as? MRarity {
                if let entity = self.rarity(from: json, context: context, type: SDRarity.self),
                   let result = entity as? U {
                   results.append(result)
               }
            } else if let json = json as? MRuling {
                if let entity = self.ruling(from: json, context: context, type: SDRuling.self),
                   let result = entity as? U {
                   results.append(result)
               }
            } */else if let json = json as? MSet {
                if let entity = self.set(from: json, context: context, type: SDSet.self),
                   let result = entity as? U {
                   results.append(result)
               }
            } else if let json = json as? MSetBlock {
                if let entity = self.setBlock(from: json, context: context, type: SDSetBlock.self),
                   let result = entity as? U {
                   results.append(result)
               }
            } else if let json = json as? MSetType {
                if let entity = self.setType(from: json, context: context, type: SDSetType.self),
                   let result = entity as? U {
                   results.append(result)
               }
            } /*else if let json = json as? MCardType {
                if let entity = self.cardType(from: json, context: context, type: SDCardType.self),
                   let result = entity as? U {
                   results.append(result)
               }
            } else if let json = json as? MWatermark {
                if let entity = self.watermark(from: json, context: context, type: SDWatermark.self),
                   let result = entity as? U {
                   results.append(result)
               }
            }*/
        }
        
//        save(context: context)

//        var descriptor = FetchDescriptor<U>()
//        if let sortDescriptors = sortDescriptors {
//            descriptor = FetchDescriptor<U>(sortBy: sortDescriptors)
//        }
//        results = (try? context.fetch(descriptor)) ?? []

        return results
    }
    
//    func nameSection(for name: String) -> String? {
//        if name.count == 0 {
//            return nil
//        } else {
//            let letters = CharacterSet.letters
//            var prefix = String(name.prefix(1))
//            if prefix.rangeOfCharacter(from: letters) == nil {
//                prefix = "#"
//            }
//            return prefix.uppercased().folding(options: .diacriticInsensitive, locale: .current)
//        }
//    }
    
    // MARK: - Artist

    func artist<T: SDEntity>(from artist: MArtist, context: ModelContext, type: T.Type) -> T? {
        var props = [String: Any]()
        props["name"] = artist.name
        props["firstName"] = artist.firstName
        props["lastName"] = artist.lastName
        props["nameSection"] = artist.nameSection
        props["info"] = artist.info

//        var request = FetchDescriptor<T>()
        let predicate = #Predicate<T> {
            (($0 as? SDArtist)?.name ?? "") == artist.name
        }
//        request.predicate = predicate
        
        return find(type,
                    properties: props,
                    predicate: predicate,
                    sortDescriptors: nil,
                    createIfNotFound: true,
                    context: context)?.first
    }
    
    // MARK: - Card
    func card<T: SDEntity>(from card: MCard, context: ModelContext, type: T.Type) -> T? {
        var props = [String: Any]()

        if let artCropURL = card.artCropURL {
            props["artCropURL"] = artCropURL
        }
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
        if let isHighResImage = card.isHighResImage {
            props["isHighResImage"] = isHighResImage
        }
        if let isNonFoil = card.isNonFoil {
            props["isNonFoil"] = isNonFoil
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
        if let normalURL = card.normalURL {
            props["normalURL"] = normalURL
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
        if let pngURL = card.pngURL {
            props["pngURL"] = pngURL
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
        if let tcgPlayerID = card.tcgPlayerID {
            props["tcgPlayerID"] = tcgPlayerID
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
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSZ"
            
            props["releaseDate"] = formatter.date(from: releaseDate)
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
        
        let predicate = #Predicate<T> { foo in
            if let foo = foo as? SDCard {
                foo.newID == card.newID
            } else {
                false
            }
        }
        
        if let newCard = find(type,
                              properties: props,
                              predicate: predicate,
                              sortDescriptors: nil,
                              createIfNotFound: true,
                              context: context)?.first as? SDCard {
            // artists
            var artists = [SDArtist]()
            for x in card.artists ?? [] {
                if let y = artist(from: x, context: context, type: SDArtist.self) {
                    artists.append(y)
                }
            }
            newCard.artists = artists

            // colors
//            for x in card.colors ?? [] {
//                if let y = color(from: x, context: context, type: MGColor.self) {
//                    newCard.addToColors(y)
//                }
//            }
//            for x in card.colorIdentities ?? [] {
//                if let y = color(from: x, context: context, type: MGColor.self) {
//                    newCard.addToColorIdentities(y)
//                }
//            }
//            for x in card.colorIndicators ?? [] {
//                if let y = color(from: x, context: context, type: MGColor.self) {
//                    newCard.addToColorIndicators(y)
//                }
//            }
            
//            for x in card.componentParts ?? [] {
//                if let y = componentPart(from: x, part: card, context: context, type: MGCardComponentPart.self) {
//                    newCard.addToComponentParts(y)
//                }
//            }

            // faces
            var faces = [SDCard]()
            for x in card.faces ?? [] {
                if let y = self.card(from: x, context: context, type: SDCard.self) {
                    faces.append(y)
                }
            }
            newCard.faces = faces

//            for x in card.formatLegalities ?? [] {
//                if let y = formatLegality(from: x, part: card, context: context, type: MGCardFormatLegality.self) {
//                    newCard.addToFormatLegalities(y)
//                }
//            }
//            if let x = card.frame {
//                newCard.frame = frame(from: x, context: context, type: MGFrame.self)
//            }
//            for x in card.frameEffects ?? [] {
//                if let y = frameEffect(from: x, context: context, type: MGFrameEffect.self) {
//                    newCard.addToFrameEffects(y)
//                }
//            }
//            for x in card.games ?? [] {
//                if let y = game(from: x, context: context, type: MGGame.self) {
//                    newCard.addToGames(y)
//                }
//            }
//            for x in card.keywords ?? [] {
//                if let y = keyword(from: x, context: context, type: MGKeyword.self) {
//                    newCard.addToKeywords(y)
//                }
//            }
            
            // language
            if let x = card.language {
                newCard.language = language(from: x, context: context, type: SDLanguage.self)
            }

//            if let x = card.layout {
//                newCard.layout = layout(from: x, context: context, type: MGLayout.self)
//            }
            
            // otherLanguages
            var otherLanguages = [SDCard]()
            for x in card.otherLanguages ?? [] {
                if let y = self.card(from: x, context: context, type: SDCard.self) {
//                    newCard.addToOtherLanguages(y)
                    otherLanguages.append(y)
                }
            }
            newCard.otherLanguages = otherLanguages

            var otherPrintings = [SDCard]()
            for x in card.otherPrintings ?? [] {
                if let y = self.card(from: x, context: context, type: SDCard.self) {
                    otherPrintings.append(y)
                }
            }
            newCard.otherPrintings = otherPrintings

//            for x in newCard.prices?.allObjects as? [MGCardPrice] ?? [] {
//                newCard.removeFromPrices(x)
//            }
//            for x in card.prices ?? [] {
//                if let y = self.price(from: x, context: context, type: MGCardPrice.self) {
//                    newCard.addToPrices(y)
//                }
//            }
//            if let x = card.rarity {
//                newCard.rarity = rarity(from: x, context: context, type: MGRarity.self)
//            }
//            for x in card.rulings ?? [] {
//                if let y = self.ruling(from: x, context: context, type: MGRuling.self) {
//                    newCard.addToRulings(y)
//                }
//            }
            
            // set
            if let x = card.set {
                newCard.set = set(from: x, context: context, type: SDSet.self)
            }

//            for x in card.subtypes ?? [] {
//                if let y = self.cardType(from: x, context: context, type: MGCardType.self) {
//                    newCard.addToSubtypes(y)
//                }
//            }
//            for x in card.supertypes ?? [] {
//                if let y = self.cardType(from: x, context: context, type: MGCardType.self) {
//                    for subtype in newCard.subtypes?.allObjects as? [MGCardType] ?? [] {
//                        if y.name != subtype.name {
//                            y.addToChildren(subtype)
//                        }
//                    }
//                    newCard.addToSupertypes(y)
//                }
//            }
//            if let x = (card.supertypes ?? []).sorted(by: { $0.name < $1.name }).filter({ $0.name != "Legendary" && $0.name != "Basic" }).first  {
//                if let y = self.type(from: x, context: context, type: MGCardType.self) {
//                    newCard.type = y
//                }
//            }
            var variations = [SDCard]()
            for x in card.variations ?? [] {
                if let y = self.card(from: x, context: context, type: SDCard.self) {
                    variations.append(y)
                }
            }
            newCard.variations = variations
            
//            if let x = card.watermark {
//                newCard.watermark = watermark(from: x, context: context, type: MGWatermark.self)
//            }
            
            return newCard as? T
        } else {
            return nil
        }
    }
    
    // MARK: - CardType

//    func cardType<T: MGEntity>(from cardType: MCardType, context: NSManagedObjectContext, type: T.Type) -> T? {
//        var props = [String: Any]()
//        
//        props["name"] = cardType.name
//        if let nameSection = cardType.nameSection {
//            props["nameSection"] = nameSection
//        } else {
//            props["nameSection"] = nameSection(for: cardType.name)
//        }
//        
//        var predicate = NSPredicate(format: "name = %@", cardType.name)
//        
//        let result = find(type,
//                          properties: props,
//                          predicate: predicate,
//                          sortDescriptors: nil,
//                          createIfNotFound: true,
//                          context: context)?.first
//        
//        if let parent = cardType.parent,
//            let newCardType = result as? MGCardType {
//            props = [String: Any]()
//            predicate = NSPredicate(format: "name = %@", parent)
//            
//            props["name"] = parent
//            props["nameSection"] = nameSection(for: parent)
//            
//            if let newParent = find(type,
//                                    properties: props,
//                                    predicate: predicate,
//                                    sortDescriptors: nil,
//                                    createIfNotFound: true,
//                                    context: context)?.first as? MGCardType {
//                newCardType.parent = newParent
//            }
//            
//            return newCardType as? T
//        }
//        
//        return result
//    }
    
    // MARK: - Color

//    func color<T: MGEntity>(from color: MColor, context: NSManagedObjectContext, type: T.Type) -> T? {
//        var props = [String: Any]()
//        
//        props["name"] = color.name
//        if let nameSection = color.nameSection {
//            props["nameSection"] = nameSection
//        } else {
//            props["nameSection"] = nameSection(for: color.name)
//        }
//        
//        switch color.name {
//        case "Black":
//            props["symbol"] = "B"
//        case "Blue":
//            props["symbol"] = "U"
//        case "Green":
//            props["symbol"] = "G"
//        case "Red":
//            props["symbol"] = "R"
//        case "White":
//            props["symbol"] = "W"
//        default:
//            ()
//        }
//        
//        let predicate = NSPredicate(format: "name = %@", color.name)
//        
//        return find(type,
//                    properties: props,
//                    predicate: predicate,
//                    sortDescriptors: nil,
//                    createIfNotFound: true,
//                    context: context)?.first
//    }
    
    // MARK: - Component

//    func component<T: SDEntity>(from component: MComponent, context: ModelContext, type: T.Type) -> T? {
//        var props = [String: Any]()
//        
//        props["name"] = component.name
//        if let nameSection = component.nameSection {
//            props["nameSection"] = nameSection
//        } else {
//            props["nameSection"] = nameSection(for: component.name)
//        }
//        
//        let predicate = #Predicate<T> { foo in
//            if let foo = foo as? SDArtist {
//                foo.name == artist.name
//            } else {
//                false
//            }
//        }
//        
//        return find(type,
//                    properties: props,
//                    predicate: predicate,
//                    sortDescriptors: nil,
//                    createIfNotFound: true,
//                    context: context)?.first
//    }
    
    // MARK: - ComponentPart

//    func componentPart<T: MGEntity>(from componentPart: MComponentPart, part: MCard, context: NSManagedObjectContext, type: T.Type) -> T? {
//        var props = [String: Any]()
//        
//        let newID = "\(part.newID)_\(componentPart.card.newID)_\(componentPart.component.name)"
//        props["id"] = newID
//        props["part"] = card(from: componentPart.card, context: context, type: MGCard.self)
//        props["component"] = component(from: componentPart.component, context: context, type: MGComponent.self)
//        
//        let predicate = NSPredicate(format: "id = %@", newID)
//        
//        return find(type,
//                    properties: props,
//                    predicate: predicate,
//                    sortDescriptors: nil,
//                    createIfNotFound: true,
//                    context: context)?.first
//    }
    
    // MARK: - Format

//    func format<T: MGEntity>(from format: MFormat, context: NSManagedObjectContext, type: T.Type) -> T? {
//        var props = [String: Any]()
//
//        props["name"] = format.name
//        if let nameSection = format.nameSection {
//            props["nameSection"] = nameSection
//        } else {
//            props["nameSection"] = nameSection(for: format.name)
//        }
//        
//        let predicate = NSPredicate(format: "name = %@", format.name)
//        
//        return find(type,
//                    properties: props,
//                    predicate: predicate,
//                    sortDescriptors: nil,
//                    createIfNotFound: true,
//                    context: context)?.first
//    }
    
    // MARK: - FormatLegality

//    func formatLegality<T: MGEntity>(from formatLegality: MFormatLegality, part: MCard, context: NSManagedObjectContext, type: T.Type) -> T? {
//        var props = [String: Any]()
//        
//        let newID = "\(part.newID)_\(formatLegality.format.name)_\(formatLegality.legality.name)"
//        props["id"] = newID
//        props["format"] = format(from: formatLegality.format, context: context, type: MGFormat.self)
//        props["legality"] = legality(from: formatLegality.legality, context: context, type: MGLegality.self)
//        
//        let predicate = NSPredicate(format: "id = %@", newID)
//        
//        return find(type,
//                    properties: props,
//                    predicate: predicate,
//                    sortDescriptors: nil,
//                    createIfNotFound: true,
//                    context: context)?.first
//    }
    
    // MARK: - Frame

//    func frame<T: MGEntity>(from frame: MFrame, context: NSManagedObjectContext, type: T.Type) -> T? {
//        var props = [String: Any]()
//
//        props["name"] = frame.name
//        if let description_ = frame.description_ {
//            props["description_"] = description_
//        }
//        if let nameSection = frame.nameSection {
//            props["nameSection"] = nameSection
//        } else {
//            props["nameSection"] = nameSection(for: frame.name)
//        }
//        
//        let predicate = NSPredicate(format: "name = %@", frame.name)
//        
//        return find(type,
//                    properties: props,
//                    predicate: predicate,
//                    sortDescriptors: nil,
//                    createIfNotFound: true,
//                    context: context)?.first
//    }
    
    // MARK: - FrameEffect

//    func frameEffect<T: MGEntity>(from frameEffect: MFrameEffect, context: NSManagedObjectContext, type: T.Type) -> T? {
//        var props = [String: Any]()
//
//        props["id"] = frameEffect.id
//        props["description_"] = frameEffect.description_
//        props["name"] = frameEffect.name
//        if let nameSection = frameEffect.nameSection {
//            props["nameSection"] = nameSection
//        } else {
//            props["nameSection"] = nameSection(for: frameEffect.name)
//        }
//        
//        let predicate = NSPredicate(format: "id = %@", frameEffect.id)
//        
//        return find(type,
//                    properties: props,
//                    predicate: predicate,
//                    sortDescriptors: nil,
//                    createIfNotFound: true,
//                    context: context)?.first
//    }
    
    // MARK: - Game

//    func game<T: MGEntity>(from game: MGame, context: NSManagedObjectContext, type: T.Type) -> T? {
//        var props = [String: Any]()
//
//        props["name"] = game.name
//        if let nameSection = game.nameSection {
//            props["nameSection"] = nameSection
//        } else {
//            props["nameSection"] = nameSection(for: game.name)
//        }
//        
//        let predicate = NSPredicate(format: "name = %@", game.name)
//        
//        return find(type,
//                    properties: props,
//                    predicate: predicate,
//                    sortDescriptors: nil,
//                    createIfNotFound: true,
//                    context: context)?.first
//    }
    
    // MARK: - Keyword

//    func keyword<T: MGEntity>(from keyword: MKeyword, context: NSManagedObjectContext, type: T.Type) -> T? {
//        var props = [String: Any]()
//
//        props["name"] = keyword.name
//        if let nameSection = keyword.nameSection {
//            props["nameSection"] = nameSection
//        } else {
//            props["nameSection"] = nameSection(for: keyword.name)
//        }
//        
//        let predicate = NSPredicate(format: "name = %@", keyword.name)
//        
//        return find(type,
//                    properties: props,
//                    predicate: predicate,
//                    sortDescriptors: nil,
//                    createIfNotFound: true,
//                    context: context)?.first
//    }

    // MARK: - Language

    func language<T: SDEntity>(from language: MLanguage, context: ModelContext, type: T.Type) -> T? {
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
        
        let predicate = #Predicate<T> { foo in
            if let foo = foo as? SDLanguage {
                foo.code == language.code
            } else {
                false
            }
        }
        
        return find(type,
                    properties: props,
                    predicate: predicate,
                    sortDescriptors: nil,
                    createIfNotFound: true,
                    context: context)?.first
    }

    // MARK: - Layout

//    func layout<T: MGEntity>(from layout: MLayout, context: NSManagedObjectContext, type: T.Type) -> T? {
//        var props = [String: Any]()
//
//        props["name"] = layout.name
//        if let description_ = layout.description_ {
//            props["description_"] = description_
//        }
//        if let nameSection = layout.nameSection {
//            props["nameSection"] = nameSection
//        } else {
//            props["nameSection"] = nameSection(for: layout.name)
//        }
//        
//        let predicate = NSPredicate(format: "name = %@", layout.name)
//        
//        return find(type,
//                    properties: props,
//                    predicate: predicate,
//                    sortDescriptors: nil,
//                    createIfNotFound: true,
//                    context: context)?.first
//    }
    
    // MARK: - Legality

//    func legality<T: SDEntity>(from legality: MLegality, context: ModelContext, type: T.Type) -> T? {
//        var props = [String: Any]()
//        
//        props["name"] = legality.name
//        if let nameSection = legality.nameSection {
//            props["nameSection"] = nameSection
//        } else {
//            props["nameSection"] = nameSection(for: legality.name)
//        }
//        
//        let predicate = #Predicate<T> { foo in
//            if let foo = foo as? SDLegality {
//                foo.name = legality.name
//            } else {
//                false
//            }
//        }
//        
//        return find(type,
//                    properties: props,
//                    predicate: predicate,
//                    sortDescriptors: nil,
//                    createIfNotFound: true,
//                    context: context)?.first
//    }
    
    // MARK: - Price

//    func price<T: MGEntity>(from price: MPrice, context: NSManagedObjectContext, type: T.Type) -> T? {
//        var props = [String: Any]()
//        
//        if let id = price.id {
//            props["id"] = id
//        }
//        if let low = price.low {
//            props["low"] = low
//        }
//        if let median = price.median {
//            props["median"] = median
//        }
//        if let high = price.high {
//            props["high"] = high
//        }
//        if let market = price.market {
//            props["market"] = market
//        }
//        if let directLow = price.directLow {
//            props["directLow"] = directLow
//        }
//        props["isFoil"] = price.isFoil
//        if let dateUpdated = price.dateUpdated {
//            let formatter = DateFormatter()
//            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSZ"
//            
//            props["dateUpdated"] = formatter.date(from: dateUpdated)
//        }
//        
//        let predicate = NSPredicate(format: "id = %d", price.id ?? "")
//        
//        return find(type,
//                    properties: props,
//                    predicate: predicate,
//                    sortDescriptors: nil,
//                    createIfNotFound: true,
//                    context: context)?.first
//    }
    
    // MARK: - Rarity

//    func rarity<T: MGEntity>(from rarity: MRarity, context: NSManagedObjectContext, type: T.Type) -> T? {
//        var props = [String: Any]()
//        
//        props["name"] = rarity.name
//        if let nameSection = rarity.nameSection {
//            props["nameSection"] = nameSection
//        } else {
//            props["nameSection"] = nameSection(for: rarity.name)
//        }
//        
//        let predicate = NSPredicate(format: "name = %@", rarity.name)
//        
//        return find(type,
//                    properties: props,
//                    predicate: predicate,
//                    sortDescriptors: nil,
//                    createIfNotFound: true,
//                    context: context)?.first
//    }
    
    // MARK: - Ruling

//    func ruling<T: MGEntity>(from ruling: MRuling, context: NSManagedObjectContext, type: T.Type) -> T? {
//        var props = [String: Any]()
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy-MM-dd"
//        
//        props["id"] = ruling.id
//        props["datePublished"] = formatter.date(from: ruling.datePublished)
//        props["text"] = ruling.text
//        
//        let predicate = NSPredicate(format: "id = %d", ruling.id)
//        
//        return find(type,
//                    properties: props,
//                    predicate: predicate,
//                    sortDescriptors: nil,
//                    createIfNotFound: true,
//                    context: context)?.first
//    }
    
    // MARK: - Set

    func set<T: SDEntity>(from set: MSet, context: ModelContext, type: T.Type) -> T? {
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
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            
            props["releaseDate"] = formatter.date(from: releaseDate)
        }
        if let name = set.name {
            props["name"] = name
            props["nameSection"] = nameSection(for: name)
        }
        if let tcgPlayerID = set.tcgPlayerID {
            props["tcgPlayerID"] = tcgPlayerID
        }
        
        let code = set.code
        let predicate = #Predicate<T> {
            if ($0 as? SDSet)?.code == code {
                true
            } else {
                false
            }
//            (($0 as? SDSet)?.code ?? "") == code
        }
        
        if let newSet = find(type,
                             properties: props,
                             predicate: predicate,
                             sortDescriptors: nil,
                             createIfNotFound: true,
                             context: context)?.first as? SDSet {
            
            if let x = set.parent {
                let parent = MSet(cardCount: nil,
                                  code: x,
                                  isFoilOnly: nil,
                                  isOnlineOnly: nil,
                                  logoCode: nil,
                                  mtgoCode: nil,
                                  keyruneUnicode: nil,
                                  keyruneClass: nil,
                                  nameSection: nil,
                                  yearSection: nil,
                                  releaseDate: nil,
                                  name: nil,
                                  tcgPlayerID: nil,
                                  parent: nil,
                                  setBlock: nil,
                                  setType: nil,
                                  languages: nil,
                                  cards: nil)
                newSet.parent = self.set(from: parent,
                                         context: context,
                                         type: SDSet.self)
            }

            if let x = set.setBlock {
                newSet.setBlock = setBlock(from: x, context: context, type: SDSetBlock.self)
            }

            if let x = set.setType {
                newSet.setType = setType(from: x, context: context, type: SDSetType.self)
            }

            // languages
            var languages = [SDLanguage]()
            for x in set.languages ?? [] {
                if let y = language(from: x, context: context, type: SDLanguage.self) {
                    languages.append(y)
                }
            }
            newSet.languages = languages
            
            // cards
            var cards = [SDCard]()
            for x in set.cards ?? [] {
                if let y = card(from: x, context: context, type: SDCard.self) {
                    cards.append(y)
                }
            }
            newSet.cards = cards
            
            return newSet as? T
        } else {
            return nil
        }
    }
    
    // MARK: - SetBlock

    func setBlock<T: SDEntity>(from setBlock: MSetBlock, context: ModelContext, type: T.Type) -> T? {
        var props = [String: Any]()

        props["code"] = setBlock.code
        props["name"] = setBlock.name
        if let nameSection = setBlock.nameSection {
            props["nameSection"] = nameSection
        } else {
            props["nameSection"] = nameSection(for: setBlock.name)
        }
        
        let predicate = #Predicate<T> { foo in
            if let foo = foo as? SDSetBlock {
                foo.code == setBlock.code
            } else {
                false
            }
        }
        
        return find(type,
                    properties: props,
                    predicate: predicate,
                    sortDescriptors: nil,
                    createIfNotFound: true,
                    context: context)?.first
    }
    
    // MARK: - SetType

    func setType<T: SDEntity>(from setType: MSetType, context: ModelContext, type: T.Type) -> T? {
        var props = [String: Any]()

        props["name"] = setType.name
        if let nameSection = setType.nameSection {
            props["nameSection"] = nameSection
        } else {
            props["nameSection"] = nameSection(for: setType.name)
        }
        
        let predicate = #Predicate<T> { foo in
            if let foo = foo as? SDSetType {
                foo.name == setType.name
            } else {
                false
            }
        }
        
        return find(type,
                    properties: props,
                    predicate: predicate,
                    sortDescriptors: nil,
                    createIfNotFound: true,
                    context: context)?.first
    }
    
    // MARK: - Type

//    func type<T: MGEntity>(from cardType: MCardType, context: NSManagedObjectContext, type: T.Type) -> T? {
//        var props = [String: Any]()
//
//        let name = cardType.name/*.replacingOccurrences(of: "Legendary", with: "")
//            .replacingOccurrences(of: "Basic", with: "")
//            .trimmingCharacters(in: .whitespacesAndNewlines)*/
//        
//        props["name"] = name
//        if let nameSection = cardType.nameSection {
//            props["nameSection"] = nameSection
//        } else {
//            props["nameSection"] = nameSection(for: name)
//        }
//        
//        let predicate = NSPredicate(format: "name = %@", name)
//        
//        return find(type,
//                    properties: props,
//                    predicate: predicate,
//                    sortDescriptors: nil,
//                    createIfNotFound: true,
//                    context: context)?.first
//    }
    
    // MARK: - Watermark

//    func watermark<T: MGEntity>(from watermark: MWatermark, context: NSManagedObjectContext, type: T.Type) -> T? {
//        var props = [String: Any]()
//
//        props["name"] = watermark.name
//        if let nameSection = watermark.nameSection {
//            props["nameSection"] = nameSection
//        } else {
//            props["nameSection"] = nameSection(for: watermark.name)
//        }
//        
//        let predicate = NSPredicate(format: "name = %@", watermark.name)
//        
//        return find(type,
//                    properties: props,
//                    predicate: predicate,
//                    sortDescriptors: nil,
//                    createIfNotFound: true,
//                    context: context)?.first
//    }
}
