//
//  ManaKit+CoreDataSync.swift
//  ManaKit
//
//  Created by Vito Royeca on 3/10/22.
//

import Foundation
import CoreData

extension ManaKit {
    public func syncToCoreData<T: MEntity>(_ jsonData: [T],
                                           jsonType: T.Type) async throws {
        guard !jsonData.isEmpty else {
            return
        }
        
        let context = newBackgroundContext()

        switch jsonType {
        case is MCard.Type:
            try await syncCards(jsonData: jsonData,
                                jsonType: jsonType,
                                to: context)
        case is MSet.Type:
            try await syncSets(jsonData: jsonData,
                               jsonType: jsonType,
                               to: context)
        case is MArtist.Type,
            is MColor.Type,
            is MGame.Type,
            is MKeyword.Type,
            is MLanguage.Type,
            is MRarity.Type,
            is MCardType.Type:
            let _ = try await batchInsert(jsonData,
                                          jsonType: jsonType)
        default:
            ()
        }
    }

    private func syncSets<T: MEntity>(jsonData: [T], jsonType: T.Type, to context: NSManagedObjectContext) async throws {
        var newEntities = [T]()

        for json in jsonData {
            if let entity = json as? MSet {
                if let newSet = MSet(cardCount: entity.cardCount,
                                     code: entity.code,
                                     isFoilOnly: entity.isFoilOnly,
                                     isOnlineOnly: entity.isOnlineOnly,
                                     logoCode: entity.logoCode,
                                     mtgoCode: entity.mtgoCode,
                                     keyruneUnicode: entity.keyruneUnicode,
                                     keyruneClass: entity.keyruneClass,
                                     nameSection: entity.nameSection,
                                     yearSection: entity.yearSection,
                                     releaseDate: entity.releaseDate,
                                     name: entity.name,
                                     tcgPlayerID: entity.tcgPlayerID,
                                     parent: nil,
                                     setBlock: nil,
                                     setType: nil,
                                     languages: nil,
                                     cards: nil) as? T {
                    newEntities.append(newSet)
                }
            }
        }
        _ = try await batchInsert(newEntities,
                                  jsonType: jsonType,
                                  keyHandlers: ["releaseDate": releaseDateHandler()])

        for json in jsonData {
            if let entity = json as? MSet,
               let set = find(MGSet.self,
                              properties: [:],
                              predicate: NSPredicate(format: "code == %@", entity.code),
                              sortDescriptors: nil,
                              createIfNotFound: false,
                              context: context)?.first {

                try await syncOtherData(of: entity,
                                        to: set,
                                        in: context)
            }
        }
    }

    private func syncCards<T: MEntity>(jsonData: [T], jsonType: T.Type, to context: NSManagedObjectContext) async throws {
        var newEntities = [T]()

        for json in jsonData {
            if let entity = json as? MCard {
                if let newCard = MCard(artCropURL: entity.artCropURL,
                                       collectorNumber: entity.collectorNumber,
                                       cmc: entity.cmc,
                                       faceOrder: entity.faceOrder,
                                       flavorText: entity.flavorText,
                                       handModifier: entity.handModifier,
                                       lifeModifier: entity.lifeModifier,
                                       isFoil: entity.isFoil,
                                       isFullArt: entity.isFullArt,
                                       isHighResImage: entity.isHighResImage,
                                       isNonFoil: entity.isNonFoil,
                                       isOversized: entity.isOversized,
                                       isReserved: entity.isReserved,
                                       isStorySpotlight: entity.isStorySpotlight,
                                       loyalty: entity.loyalty,
                                       manaCost: entity.manaCost,
                                       nameSection: entity.nameSection,
                                       numberOrder: entity.numberOrder,
                                       name: entity.name,
                                       normalURL: entity.normalURL,
                                       oracleText: entity.oracleText,
                                       power: entity.power,
                                       printedName: entity.printedName,
                                       printedText: entity.printedText,
                                       toughness: entity.toughness,
                                       arenaID: entity.arenaID,
                                       mtgoID: entity.mtgoID,
                                       pngURL: entity.pngURL,
                                       tcgPlayerID: entity.tcgPlayerID,
                                       isBooster: entity.isBooster,
                                       isDigital: entity.isDigital,
                                       isPromo: entity.isPromo,
                                       releaseDate: entity.releaseDate,
                                       isTextless: entity.isTextless,
                                       mtgoFoilID: entity.mtgoFoilID,
                                       isReprint: entity.isReprint,
                                       newID: entity.newID,
                                       printedTypeLine: entity.printedTypeLine,
                                       typeLine: entity.typeLine,
                                       multiverseIDs: entity.multiverseIDs,
                                       rarity: nil,
                                       language: nil,
                                       layout: nil,
                                       watermark: nil,
                                       frame: nil,
                                       artists: nil,
                                       colors: nil,
                                       colorIdentities: nil,
                                       colorIndicators: nil,
                                       componentParts: nil,
                                       faces: nil,
                                       games: nil,
                                       keywords: nil,
                                       otherLanguages: nil,
                                       otherPrintings: nil,
                                       set: nil,
                                       variations: nil,
                                       formatLegalities: nil,
                                       frameEffects: nil,
                                       subtypes: nil,
                                       supertypes: nil,
                                       prices: nil,
                                       rulings: nil) as? T {
                    newEntities.append(newCard)
                }
            }
        }
        _ = try await batchInsert(newEntities,
                                  jsonType: jsonType,
                                  keyHandlers: ["multiverseIDs": multiverseIDsHandler(),
                                                "releaseDate": releaseDateHandler()])
        
        for json in jsonData {
            if let entity = json as? MCard,
               let card = find(MGCard.self,
                               properties: [:],
                               predicate: NSPredicate(format: "newID == %@", entity.newID),
                               sortDescriptors: nil,
                               createIfNotFound: false,
                               context: context)?.first {

                try await syncOtherData(of: entity,
                                        to: card,
                                        in: context)
            }
        }
    }

    private func syncOtherData(of entity: MSet,
                               to set: MGSet,
                               in context: NSManagedObjectContext) async throws {
        // languages
        for language in entity.languages ?? [] {
            let properties = try language.allProperties()
            let predicate = NSPredicate(format: "code == %@", language.code)
        
            if let newLanguage = find(MGLanguage.self,
                                      properties: properties,
                                      predicate: predicate,
                                      sortDescriptors: nil,
                                      createIfNotFound: true,
                                      context: context)?.first {
                set.addToLanguages(newLanguage)
            }
        }

        // parent
        if let parent = entity.parent {
            let properties = ["code": parent]
            let predicate = NSPredicate(format: "code == %@", parent)
        
            set.parent = find(MGSet.self,
                              properties: properties,
                              predicate: predicate,
                              sortDescriptors: nil,
                              createIfNotFound: true,
                              context: context)?.first
        }

        // setBlock
        if let setBlock = entity.setBlock {
            let properties = try setBlock.allProperties()
            let predicate = NSPredicate(format: "code == %@", setBlock.code)
        
            set.setBlock = find(MGSetBlock.self,
                                properties: properties,
                                predicate: predicate,
                                sortDescriptors: nil,
                                createIfNotFound: true,
                                context: context)?.first
        }
        
        // setType
        if let setType = entity.setType {
            let properties = try setType.allProperties()
            let predicate = NSPredicate(format: "name == %@", setType.name)
        
            set.setType = find(MGSetType.self,
                               properties: properties,
                               predicate: predicate,
                               sortDescriptors: nil,
                               createIfNotFound: true,
                               context: context)?.first
        }
    
        try context.save()

        // cards
        if let cards = entity.cards {
            try await syncCards(jsonData: cards,
                                jsonType: MCard.self,
                                to: context)
        }
    }

    private func syncOtherData(of entity: MCard,
                               to card: MGCard,
                               in context: NSManagedObjectContext) async throws {
        // artists
        for artist in entity.artists ?? [] {
            let properties = try artist.allProperties()
            let predicate = NSPredicate(format: "name == %@", artist.name)
        
            if let newArtist = find(MGArtist.self,
                                    properties: properties,
                                    predicate: predicate,
                                    sortDescriptors: nil,
                                    createIfNotFound: true,
                                    context: context)?.first {
                card.addToArtists(newArtist)
            }
        }

        // colors
        for color in entity.colors ?? [] {
            let properties = try color.allProperties()
            let predicate = NSPredicate(format: "name == %@", color.name)
        
            if let newColor = find(MGColor.self,
                                   properties: properties,
                                   predicate: predicate,
                                   sortDescriptors: nil,
                                   createIfNotFound: true,
                                   context: context)?.first {
                card.addToColors(newColor)
            }
        }
        
        // colorIdentities
        for colorIdentity in entity.colorIdentities ?? [] {
            let properties = try colorIdentity.allProperties()
            let predicate = NSPredicate(format: "name == %@", colorIdentity.name)
        
            if let newColor = find(MGColor.self,
                                   properties: properties,
                                   predicate: predicate,
                                   sortDescriptors: nil,
                                   createIfNotFound: true,
                                   context: context)?.first {
                card.addToColorIdentities(newColor)
            }
        }

        // colorIndicators
        for colorIndicator in entity.colorIndicators ?? [] {
            let properties = try colorIndicator.allProperties()
            let predicate = NSPredicate(format: "name == %@", colorIndicator.name)
        
            if let newColor = find(MGColor.self,
                                   properties: properties,
                                   predicate: predicate,
                                   sortDescriptors: nil,
                                   createIfNotFound: true,
                                   context: context)?.first {
                card.addToColorIndicators(newColor)
            }
        }

        // componentParts
        for componentPart in entity.componentParts ?? [] {
            try await syncCards(jsonData: [componentPart.card],
                                jsonType: MCard.self,
                                to: context)
            
            if let part = find(MGCard.self,
                               properties: [:],
                               predicate: NSPredicate(format: "newID == %@", componentPart.card.newID),
                               sortDescriptors: nil,
                               createIfNotFound: false,
                               context: context)?.first,
               let component = find(MGComponent.self,
                                    properties: try componentPart.component.allProperties(),
                                    predicate: NSPredicate(format: "name == %@", componentPart.component.name),
                                    sortDescriptors: nil,
                                    createIfNotFound: true,
                                    context: context)?.first {
                let newID = "\(entity.newID)_\(componentPart.card.newID)_\(componentPart.component.name)"
                let properties: [String: Any] = [
                    "id": newID,
                    "part": part,
                    "component": component
                ]
                let predicate = NSPredicate(format: "id == %@", newID)
            
                if let newComponentPart = find(MGCardComponentPart.self,
                                               properties: properties,
                                               predicate: predicate,
                                               sortDescriptors: nil,
                                               createIfNotFound: true,
                                               context: context)?.first {
                    card.addToComponentParts(newComponentPart)
                }
            }
        }

        // faces
        for face in entity.faces ?? [] {
            try await syncCards(jsonData: [face],
                                jsonType: MCard.self,
                                to: context)
        
            if let newFace = find(MGCard.self,
                                  properties: [:],
                                  predicate: NSPredicate(format: "newID == %@", face.newID),
                                  sortDescriptors: nil,
                                  createIfNotFound: false,
                                  context: context)?.first {
                card.addToFaces(newFace)
            }
        }
        
        // "formatLegalities"
        for formatLegality in entity.formatLegalities ?? [] {
            if let format = find(MGFormat.self,
                                 properties: try formatLegality.format.allProperties(),
                                 predicate: NSPredicate(format: "name == %@", formatLegality.format.name),
                                 sortDescriptors: nil,
                                 createIfNotFound: true,
                                 context: context)?.first,
               let legality = find(MGLegality.self,
                                   properties: try formatLegality.legality.allProperties(),
                                   predicate: NSPredicate(format: "name == %@", formatLegality.legality.name),
                                   sortDescriptors: nil,
                                   createIfNotFound: true,
                                   context: context)?.first {
                let newID = "\(entity.newID)_\(formatLegality.format.name)_\(formatLegality.legality.name)"
                let properties: [String: Any] = [
                    "id": newID,
                    "format": format,
                    "legality": legality
                ]
                let predicate = NSPredicate(format: "id == %@", newID)
                
                if let newFormatLegality = find(MGCardFormatLegality.self,
                                                properties: properties,
                                                predicate: predicate,
                                                sortDescriptors: nil,
                                                createIfNotFound: true,
                                                context: context)?.first {
                    card.addToFormatLegalities(newFormatLegality)
                }
            }
        }
        
        // frame
        if let frame = entity.frame {
            let properties = try frame.allProperties()
            let predicate = NSPredicate(format: "name == %@", frame.name)
        
            card.frame = find(MGFrame.self,
                              properties: properties,
                              predicate: predicate,
                              sortDescriptors: nil,
                              createIfNotFound: true,
                              context: context)?.first
        }

        // "frameEffects",
        for frameEffect in entity.frameEffects ?? [] {
            let properties = try frameEffect.allProperties()
            let predicate = NSPredicate(format: "id == %@", frameEffect.id)
        
            if let newFrameEffect = find(MGFrameEffect.self,
                                         properties: properties,
                                         predicate: predicate,
                                         sortDescriptors: nil,
                                         createIfNotFound: true,
                                         context: context)?.first {
                card.addToFrameEffects(newFrameEffect)
            }
        }
        
        // games
        for game in entity.games ?? [] {
            let properties = try game.allProperties()
            let predicate = NSPredicate(format: "name == %@", game.name)
        
            if let newGame = find(MGGame.self,
                                  properties: properties,
                                  predicate: predicate,
                                  sortDescriptors: nil,
                                  createIfNotFound: true,
                                  context: context)?.first {
                card.addToGames(newGame)
            }
        }

        // keywords
        for keyword in entity.keywords ?? [] {
            let properties = try keyword.allProperties()
            let predicate = NSPredicate(format: "name == %@", keyword.name)
        
            if let newKeyword = find(MGKeyword.self,
                                  properties: properties,
                                  predicate: predicate,
                                  sortDescriptors: nil,
                                  createIfNotFound: true,
                                  context: context)?.first {
                card.addToKeywords(newKeyword)
            }
        }

        // language
        if let language = entity.language {
            let properties = try language.allProperties()
            let predicate = NSPredicate(format: "code == %@", language.code)
        
            card.language = find(MGLanguage.self,
                                 properties: properties,
                                 predicate: predicate,
                                 sortDescriptors: nil,
                                 createIfNotFound: true,
                                 context: context)?.first
        }

        // layout
        if let layout = entity.layout {
            let properties = try layout.allProperties()
            let predicate = NSPredicate(format: "name == %@", layout.name)
        
            card.layout = find(MGLayout.self,
                               properties: properties,
                               predicate: predicate,
                               sortDescriptors: nil,
                               createIfNotFound: true,
                               context: context)?.first
        }

        // "otherLanguages"
        if let otherLanguages = entity.otherLanguages {
            try await syncCards(jsonData: otherLanguages,
                                jsonType: MCard.self,
                                to: context)
            
            for otherLanguage in entity.otherLanguages ?? [] {
                let predicate = NSPredicate(format: "newID == %@", otherLanguage.newID)
                
                if let newOtherLanguage = find(MGCard.self,
                                               properties: [:],
                                               predicate: predicate,
                                               sortDescriptors: nil,
                                               createIfNotFound: false,
                                               context: context)?.first {
                    card.addToOtherLanguages(newOtherLanguage)
                }
            }
        }

        // "otherPrintings"
        if let otherPrintings = entity.otherPrintings {
            try await syncCards(jsonData: otherPrintings,
                                jsonType: MCard.self,
                                to: context)
            
            for otherPrinting in entity.otherPrintings ?? [] {
                let predicate = NSPredicate(format: "newID == %@", otherPrinting.newID)
                
                if let newOtherPrinting = find(MGCard.self,
                                               properties: [:],
                                               predicate: predicate,
                                               sortDescriptors: nil,
                                               createIfNotFound: false,
                                               context: context)?.first {
                    card.addToOtherPrintings(newOtherPrinting)
                }
            }
        }
        
        // "prices"
        for price in card.prices?.allObjects as? [MGCardPrice] ?? [] {
            card.removeFromPrices(price)
        }
        if let prices = entity.prices {
            let _ = try await batchInsert(prices,
                                          jsonType: MPrice.self,
                                          keyHandlers: ["dateUpdated": dateUpdatedHandler()])

            for price in entity.prices ?? [] {
                let predicate = NSPredicate(format: "id == %d", price.id ?? Int32(0))
                
                if let newPrice = find(MGCardPrice.self,
                                       properties: [:],
                                       predicate: predicate,
                                       sortDescriptors: nil,
                                       createIfNotFound: false,
                                       context: context)?.first {
                    card.addToPrices(newPrice)
                }
            }
        }

        // rarity
        if let rarity = entity.rarity {
            let properties = try rarity.allProperties()
            let predicate = NSPredicate(format: "name == %@", rarity.name)
        
            card.rarity = find(MGRarity.self,
                               properties: properties,
                               predicate: predicate,
                               sortDescriptors: nil,
                               createIfNotFound: true,
                               context: context)?.first
        }

        // TODO
        // "rulings"

        //set
        if let set = entity.set {
            let predicate = NSPredicate(format: "code == %@", set.code)
        
            card.set = find(MGSet.self,
                            properties: nil,
                            predicate: predicate,
                            sortDescriptors: nil,
                            createIfNotFound: false,
                            context: context)?.first
        }
        
        // TODO
        // "subtypes"

        // TODO
        // "supertypes"

        // variations
        for variation in entity.variations ?? [] {
            try await syncCards(jsonData: [variation],
                                jsonType: MCard.self,
                                to: context)
            
            if let newVariation = find(MGCard.self,
                                       properties: [:],
                                       predicate: NSPredicate(format: "newID == %@", variation.newID),
                                       sortDescriptors: nil,
                                       createIfNotFound: false,
                                       context: context)?.first {
                    card.addToVariations(newVariation)
            }
        }

        // watermark
        if let watermark = entity.watermark {
            let properties = try watermark.allProperties()
            let predicate = NSPredicate(format: "name == %@", watermark.name)
        
            card.watermark = find(MGWatermark.self,
                                  properties: properties,
                                  predicate: predicate,
                                  sortDescriptors: nil,
                                  createIfNotFound: true,
                                  context: context)?.first
        }
        
        try context.save()
    }

    private func batchInsert<T: MEntity>(_ jsonData: [T],
                                         jsonType: T.Type,
                                         keyHandlers: [String: (Any) -> Any?]? = nil) async throws -> [NSManagedObjectID] {
        let context = newBackgroundContext()
        context.name = "\(jsonType)ImportContext"
        context.transactionAuthor = "import(\(jsonType))"

        do {
            var objectIDs = [NSManagedObjectID]()

            try await context.perform {
                let batchInsertRequest = try self.newBatchInsertRequest(jsonData,
                                                                        jsonType: jsonType,
                                                                        keyHandlers: keyHandlers)
                if let fetchResult = try? context.execute(batchInsertRequest),
                   let batchInsertResult = fetchResult as? NSBatchInsertResult,
                   let ids = batchInsertResult.result as? [NSManagedObjectID] {
                    objectIDs = ids
                    return
                }
            }
            return objectIDs
        } catch {
            print(error)
            throw ManaKitError.batchInsertError
        }
    }

    private func newBatchInsertRequest<T: MEntity>(_ jsonData: [T],
                                                   jsonType: T.Type,
                                                   keyHandlers: [String: (Any) -> Any?]? = nil) throws -> NSBatchInsertRequest {
        
        let total = jsonData.count
        var index = 0
        

        let entityDescription = entityDescription(for: jsonType)
        let batchInsertRequest = NSBatchInsertRequest(entity: entityDescription) { dictionary in
            guard index < total else {
                return true
            }
            
            do {
                let allProperties = try jsonData[index].allProperties(keyHandlers: keyHandlers)
                dictionary.addEntries(from: allProperties)
                index += 1
                return false
            } catch {
                print(error)
                return true
            }
        }
        batchInsertRequest.resultType = .objectIDs
        return batchInsertRequest
    }
    
    private func entityDescription<T: MEntity>(for jsonType: T.Type) -> NSEntityDescription {
        switch jsonType {
        case is MArtist.Type:
            MGArtist.entity()
        case is MCard.Type:
            MGCard.entity()
        case is MColor.Type:
            MGColor.entity()
        case is MComponent.Type:
            MGComponent.entity()
//        case is MComponentPart.Type:
//            MGComponentPart.entity()
        case is MFormat.Type:
            MGFormat.entity()
//        case is MFormatLegality.Type:
//            MGFormatLegality.entity()
        case is MFrame.Type:
            MGFrame.entity()
        case is MFrameEffect.Type:
            MGFrameEffect.entity()
        case is MGame.Type:
            MGGame.entity()
        case is MKeyword.Type:
            MGKeyword.entity()
        case is MLanguage.Type:
            MGLanguage.entity()
        case is MLayout.Type:
            MGLayout.entity()
        case is MLegality.Type:
            MGLegality.entity()
        case is MPrice.Type:
            MGCardPrice.entity()
        case is MRarity.Type:
            MGRarity.entity()
        case is MRuling.Type:
            MGRuling.entity()
        case is MSet.Type:
            MGSet.entity()
        case is MSetBlock.Type:
            MGSetBlock.entity()
        case is MSetType.Type:
            MGSetType.entity()
        case is MCardType.Type:
            MGCardType.entity()
        case is MWatermark.Type:
            MGWatermark.entity()
        default:
            NSEntityDescription()
        }
    }

    private func multiverseIDsHandler() -> (Any) -> Any? {
        { (multiverseIDs: Any) -> Any? in
            guard let multiverseIDs = multiverseIDs as? [Int] else {
                return nil
            }
            
            do {
                return try NSKeyedArchiver.archivedData(withRootObject: multiverseIDs,
                                                        requiringSecureCoding: false)
            } catch {
                print(error)
                return nil
            }
        }
    }

    private func releaseDateHandler() -> (Any) -> Any? {
        { (releaseDate: Any) -> Any? in
            guard let releaseDate = releaseDate as? String else {
                return nil
            }
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            
            return formatter.date(from: releaseDate)
        }
    }

    private func dateUpdatedHandler() -> (Any) -> Any? {
        { (dateUpdated: Any) -> Any? in
            guard let dateUpdated = dateUpdated as? String else {
                return nil
            }
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSZ"
            
            return formatter.date(from: dateUpdated)
        }
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
    
    // MARK: - Legacy code

    public func syncToCoreData<T: MEntity, U: MGEntity>(_ jsonData: [T],
                                                        jsonType: T.Type,
                                                        coreDataType: U.Type,
                                                        sortDescriptors: [NSSortDescriptor]?) -> [U]? {
        let context = newBackgroundContext()
        var results = [U]()

        for json in jsonData {
            if let json = json as? MArtist {
                if let entity = self.artist(from: json, context: context, type: MGArtist.self),
                    let result = entity as? U {
                    results.append(result)
                }
            } else if let json = json as? MCard {
                if let entity = self.card(from: json, context: context, type: MGCard.self),
                   let result = entity as? U {
                   results.append(result)
               }
            } else if let json = json as? MColor {
                if let entity = self.color(from: json, context: context, type: MGColor.self),
                   let result = entity as? U {
                   results.append(result)
               }
            } else if let json = json as? MComponent {
                if let entity = self.component(from: json, context: context, type: MGComponent.self),
                   let result = entity as? U {
                   results.append(result)
               }
            }/* else if let json = json as? MComponentPart {
              func componentPart<T: MGEntity>(from componentPart: MComponentPart, part: MCard, context: NSManagedObjectContext, type: T.Type)
            }*/ else if let json = json as? MFormat {
                if let entity = self.format(from: json, context: context, type: MGFormat.self),
                   let result = entity as? U {
                   results.append(result)
               }
            }/* else if let json = json as? MFormatLegality {
              func formatLegality<T: MGEntity>(from formatLegality: MFormatLegality, part: MCard, context: NSManagedObjectContext, type: T.Type) -> T?
            }*/ else if let json = json as? MFrame {
                if let entity = self.frame(from: json, context: context, type: MGFrame.self),
                   let result = entity as? U {
                   results.append(result)
               }
            } else if let json = json as? MFrameEffect {
                if let entity = self.frameEffect(from: json, context: context, type: MGFrameEffect.self),
                   let result = entity as? U {
                   results.append(result)
               }
            } else if let json = json as? MGame {
                if let entity = self.game(from: json, context: context, type: MGGame.self),
                   let result = entity as? U {
                   results.append(result)
               }
            } else if let json = json as? MKeyword {
                if let entity = self.keyword(from: json, context: context, type: MGKeyword.self),
                   let result = entity as? U {
                   results.append(result)
               }
            } else if let json = json as? MLanguage {
                if let entity = self.language(from: json, context: context, type: MGLanguage.self),
                   let result = entity as? U {
                   results.append(result)
               }
            } else if let json = json as? MLayout {
                if let entity = self.layout(from: json, context: context, type: MGLayout.self),
                   let result = entity as? U {
                   results.append(result)
               }
            } else if let json = json as? MLegality {
                if let entity = self.legality(from: json, context: context, type: MGLegality.self),
                   let result = entity as? U {
                   results.append(result)
               }
            } else if let json = json as? MPrice {
                if let entity = self.price(from: json, context: context, type: MGCardPrice.self),
                   let result = entity as? U {
                   results.append(result)
               }
            } else if let json = json as? MRarity {
                if let entity = self.rarity(from: json, context: context, type: MGRarity.self),
                   let result = entity as? U {
                   results.append(result)
               }
            } else if let json = json as? MRuling {
                if let entity = self.ruling(from: json, context: context, type: MGRuling.self),
                   let result = entity as? U {
                   results.append(result)
               }
            } else if let json = json as? MSet {
                if let entity = self.set(from: json, context: context, type: MGSet.self),
                   let result = entity as? U {
                   results.append(result)
               }
            } else if let json = json as? MSetBlock {
                if let entity = self.setBlock(from: json, context: context, type: MGSetBlock.self),
                   let result = entity as? U {
                   results.append(result)
               }
            } else if let json = json as? MSetType {
                if let entity = self.setType(from: json, context: context, type: MGSetType.self),
                   let result = entity as? U {
                   results.append(result)
               }
            } else if let json = json as? MCardType {
                if let entity = self.cardType(from: json, context: context, type: MGCardType.self),
                   let result = entity as? U {
                   results.append(result)
               }
            } else if let json = json as? MWatermark {
                if let entity = self.watermark(from: json, context: context, type: MGWatermark.self),
                   let result = entity as? U {
                   results.append(result)
               }
            }
        }
        
        save(context: context)

        return results
    }

    // MARK: - Artist
    func artist<T: MGEntity>(from artist: MArtist, context: NSManagedObjectContext, type: T.Type) -> T? {
        var props = [String: Any]()
        props["name"] = artist.name
        props["firstName"] = artist.firstName
        props["lastName"] = artist.lastName
        props["nameSection"] = artist.nameSection
        props["info"] = artist.info

        let predicate = NSPredicate(format: "name = %@", artist.name)
        
        return find(type,
                    properties: props,
                    predicate: predicate,
                    sortDescriptors: nil,
                    createIfNotFound: true,
                    context: context)?.first
    }
    
    // MARK: - Card
    func card<T: MGEntity>(from card: MCard, context: NSManagedObjectContext, type: T.Type) -> T? {
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
        
        let predicate = NSPredicate(format: "newID = %@", card.newID)
        
        if let newCard = find(type,
                              properties: props,
                              predicate: predicate,
                              sortDescriptors: nil,
                              createIfNotFound: true,
                              context: context)?.first as? MGCard {
            for x in card.artists ?? [] {
                if let y = artist(from: x, context: context, type: MGArtist.self) {
                    newCard.addToArtists(y)
                }
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
            for x in card.games ?? [] {
                if let y = game(from: x, context: context, type: MGGame.self) {
                    newCard.addToGames(y)
                }
            }
            for x in card.keywords ?? [] {
                if let y = keyword(from: x, context: context, type: MGKeyword.self) {
                    newCard.addToKeywords(y)
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
                    for subtype in newCard.subtypes?.allObjects as? [MGCardType] ?? [] {
                        if y.name != subtype.name {
                            y.addToChildren(subtype)
                        }
                    }
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
        
        var predicate = NSPredicate(format: "name = %@", cardType.name)
        
        let result = find(type,
                          properties: props,
                          predicate: predicate,
                          sortDescriptors: nil,
                          createIfNotFound: true,
                          context: context)?.first
        
        if let parent = cardType.parent,
            let newCardType = result as? MGCardType {
            props = [String: Any]()
            predicate = NSPredicate(format: "name = %@", parent)
            
            props["name"] = parent
            props["nameSection"] = nameSection(for: parent)
            
            if let newParent = find(type,
                                    properties: props,
                                    predicate: predicate,
                                    sortDescriptors: nil,
                                    createIfNotFound: true,
                                    context: context)?.first as? MGCardType {
                newCardType.parent = newParent
            }
            
            return newCardType as? T
        }
        
        return result
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
    
    // MARK: - Game
    func game<T: MGEntity>(from game: MGame, context: NSManagedObjectContext, type: T.Type) -> T? {
        var props = [String: Any]()

        props["name"] = game.name
        if let nameSection = game.nameSection {
            props["nameSection"] = nameSection
        } else {
            props["nameSection"] = nameSection(for: game.name)
        }
        
        let predicate = NSPredicate(format: "name = %@", game.name)
        
        return find(type,
                    properties: props,
                    predicate: predicate,
                    sortDescriptors: nil,
                    createIfNotFound: true,
                    context: context)?.first
    }
    
    // MARK: - Keyword
    func keyword<T: MGEntity>(from keyword: MKeyword, context: NSManagedObjectContext, type: T.Type) -> T? {
        var props = [String: Any]()

        props["name"] = keyword.name
        if let nameSection = keyword.nameSection {
            props["nameSection"] = nameSection
        } else {
            props["nameSection"] = nameSection(for: keyword.name)
        }
        
        let predicate = NSPredicate(format: "name = %@", keyword.name)
        
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
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSZ"
            
            props["dateUpdated"] = formatter.date(from: dateUpdated)
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
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        props["id"] = ruling.id
        props["datePublished"] = formatter.date(from: ruling.datePublished)
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
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            
            props["releaseDate"] = formatter.date(from: releaseDate)
        }
        if let name = set.name {
            props["name"] = name
            props["nameSection"] = nameSection(for: name)
        }
        if let tcgplayerID = set.tcgPlayerID {
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
                let parent = MSet(cardCount: nil, code: x, isFoilOnly: nil, isOnlineOnly: nil, logoCode: nil, mtgoCode: nil, keyruneUnicode: nil, keyruneClass: nil, nameSection: nil, yearSection: nil, releaseDate: nil, name: nil, tcgPlayerID: nil, parent: nil, setBlock: nil, setType: nil, languages: nil, cards: nil)
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

        let name = cardType.name/*.replacingOccurrences(of: "Legendary", with: "")
            .replacingOccurrences(of: "Basic", with: "")
            .trimmingCharacters(in: .whitespacesAndNewlines)*/
        
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

