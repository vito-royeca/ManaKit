//
//  ManaKit+CoreData+BatchInsert.swift
//  
//
//  Created by Vito Royeca on 2/21/24.
//

import Foundation
import CoreData

extension ManaKit {
    func batchInsertToCoreData<T: MEntity>(_ jsonData: [T],
                                           jsonType: T.Type) async throws -> [NSManagedObjectID] {
        guard !jsonData.isEmpty else {
            return []
        }
        
        let context = newBackgroundContext()
        var objectIDs = [NSManagedObjectID]()

        switch jsonType {
        case is MCard.Type:
            objectIDs = try await batchInsertCards(jsonData: jsonData,
                                                   jsonType: jsonType,
                                                   to: context)
        case is MSet.Type:
            objectIDs = try await batchInsertSets(jsonData: jsonData,
                                                  jsonType: jsonType,
                                                  to: context)
        case is MArtist.Type,
            is MColor.Type,
            is MGame.Type,
            is MKeyword.Type,
            is MLanguage.Type,
            is MRarity.Type,
            is MCardType.Type:
            objectIDs = try await batchInsert(jsonData,
                                              jsonType: jsonType)
        default:
            ()
        }
        
        return objectIDs
    }

    // MARK: - Sets

    private func batchInsertSets<T: MEntity>(jsonData: [T],
                                      jsonType: T.Type,
                                      to context: NSManagedObjectContext) async throws -> [NSManagedObjectID] {
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
        let objectIDs = try await batchInsert(newEntities,
                                              jsonType: jsonType,
                                              keyHandlers: ["releaseDate": releaseDateHandler()])

        for json in jsonData {
            if let entity = json as? MSet {
               try await insert(set: entity)
            }
        }
        
        return objectIDs
    }

    func insert(set: MSet) async throws -> NSManagedObjectID? {
        let properties = try set.allProperties(excluding: ["parent",
                                                           "setBlock",
                                                           "setType",
                                                           "languages",
                                                           "cards"],
                                               keyHandlers: ["releaseDate": releaseDateHandler()])
        let predicate = NSPredicate(format: "code == %@", set.code)
        let context = newBackgroundContext()

        if let object = find(MGSet.self,
                          properties: properties,
                          predicate: predicate,
                          sortDescriptors: nil,
                          createIfNotFound: true,
                          context: context)?.first {
            
            try await syncOtherData(of: set,
                                    to: object,
                                    in: context)
            return object.objectID
        } else {
            return nil
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
            _ = try await batchInsertCards(jsonData: cards,
                                           jsonType: MCard.self,
                                           to: context)
        }
    }

    // MARK: - Cards

    private func batchInsertCards<T: MEntity>(jsonData: [T],
                                              jsonType: T.Type,
                                              to context: NSManagedObjectContext) async throws -> [NSManagedObjectID] {
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
        let objectIDs = try await batchInsert(newEntities,
                                              jsonType: jsonType,
                                              keyHandlers: ["multiverseIDs": multiverseIDsHandler(),
                                                            "releaseDate": releaseDateHandler()])
        
        for json in jsonData {
            if let entity = json as? MCard {
                try await insert(card: entity)
            }
        }
        
        return objectIDs
    }

    func insert(card: MCard) async throws -> NSManagedObjectID? {
        let properties = try card.allProperties(excluding: ["rarity",
                                                            "language",
                                                            "layout",
                                                            "watermark",
                                                            "frame",
                                                            "artists",
                                                            "colors",
                                                            "colorIdentities",
                                                            "colorIndicators",
                                                            "componentParts",
                                                            "faces",
                                                            "games",
                                                            "keywords",
                                                            "otherLanguages",
                                                            "otherPrintings",
                                                            "set",
                                                            "variations",
                                                            "formatLegalities",
                                                            "frameEffects",
                                                            "subtypes",
                                                            "supertypes",
                                                            "prices",
                                                            "rulings"],
                                               keyHandlers: ["multiverseIDs": multiverseIDsHandler(),
                                                             "releaseDate": releaseDateHandler()])
        let predicate = NSPredicate(format: "newID == %@", card.newID)
        let context = newBackgroundContext()

        if let object = find(MGCard.self,
                          properties: properties,
                          predicate: predicate,
                          sortDescriptors: nil,
                          createIfNotFound: true,
                          context: context)?.first {
            
            try await syncOtherData(of: card,
                                    to: object,
                                    in: context)
            return object.objectID
        } else {
            return nil
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
            _ = try await batchInsertCards(jsonData: [componentPart.card],
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
        if let faces = entity.faces,
           !faces.isEmpty {
            _ = try await batchInsertCards(jsonData: faces,
                                           jsonType: MCard.self,
                                           to: context)
        }
        for face in entity.faces ?? [] {
            let predicate = NSPredicate(format: "newID == %@", face.newID)

            if let newFace = find(MGCard.self,
                                  properties: [:],
                                  predicate: predicate,
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
        if let otherLanguages = entity.otherLanguages,
           !otherLanguages.isEmpty {
            _ = try await batchInsertCards(jsonData: otherLanguages,
                                           jsonType: MCard.self,
                                           to: context)
        }
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

        // "otherPrintings"
        if let otherPrintings = entity.otherPrintings,
           !otherPrintings.isEmpty {
            _ = try await batchInsertCards(jsonData: otherPrintings,
                                           jsonType: MCard.self,
                                           to: context)
        }
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

        // "prices"
        for price in card.prices?.allObjects as? [MGCardPrice] ?? [] {
            // TODO: batch delete
            try await delete(MGCardPrice.self,
                             predicate: NSPredicate(format: "id == %d", price.id))
        }
        if let prices = entity.prices,
           !prices.isEmpty {
            let _ = try await batchInsert(prices,
                                          jsonType: MPrice.self,
                                          keyHandlers: ["dateUpdated": dateUpdatedHandler()])
        }
        for price in entity.prices ?? [] {
            let predicate = NSPredicate(format: "id == %d", price.id)
            
            if let newPrice = find(MGCardPrice.self,
                                   properties: [:],
                                   predicate: predicate,
                                   sortDescriptors: nil,
                                   createIfNotFound: false,
                                   context: context)?.first {
                card.addToPrices(newPrice)
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

        // "rulings"
        for ruling in entity.rulings ?? [] {
            let properties = try ruling.allProperties(keyHandlers: ["datePublished":
                                                                        releaseDateHandler()])
            let predicate = NSPredicate(format: "id == %d", ruling.id)
        
            if let newRuling = find(MGRuling.self,
                                    properties: properties,
                                    predicate: predicate,
                                    sortDescriptors: nil,
                                    createIfNotFound: true,
                                    context: context)?.first {
                card.addToRulings(newRuling)
            }
        }

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
        
        // "subtypes"
        for subtype in entity.subtypes ?? [] {
            let properties = try subtype.allProperties()
            let predicate = NSPredicate(format: "name == %@", subtype.name)
        
            if let newSubtype = find(MGCardType.self,
                                     properties: properties,
                                     predicate: predicate,
                                     sortDescriptors: nil,
                                     createIfNotFound: true,
                                     context: context)?.first {
                card.addToSubtypes(newSubtype)
            }
        }

        // "supertypes"
        for supertype in entity.supertypes ?? [] {
            let properties = try supertype.allProperties()
            let predicate = NSPredicate(format: "name == %@", supertype.name)

            if let newSupertype = find(MGCardType.self,
                                       properties: properties,
                                       predicate: predicate,
                                       sortDescriptors: nil,
                                       createIfNotFound: true,
                                       context: context)?.first {
                for subtype in card.subtypes?.allObjects as? [MGCardType] ?? [] {
                    if newSupertype.name != subtype.name {
                        newSupertype.addToChildren(subtype)
                    }
                }
                card.addToSupertypes(newSupertype)
            }
        }
        if let type = (entity.supertypes ?? []).sorted(by: { $0.name < $1.name })
            .filter({ $0.name != "Legendary" && $0.name != "Basic" }).first {
            
            let properties = try type.allProperties()
            let predicate = NSPredicate(format: "name == %@", type.name)
            
            card.type = find(MGCardType.self,
                             properties: properties,
                             predicate: predicate,
                             sortDescriptors: nil,
                             createIfNotFound: true,
                             context: context)?.first
        }
        
        // variations
        if let variations = entity.variations,
           !variations.isEmpty {
            _ = try await batchInsertCards(jsonData: variations,
                                           jsonType: MCard.self,
                                           to: context)
        }
        for variation in entity.variations ?? [] {
            let predicate = NSPredicate(format: "newID == %@", variation.newID)
            if let newVariation = find(MGCard.self,
                                       properties: [:],
                                       predicate: predicate,
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
}
