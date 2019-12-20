//
//  Maintainer+CardsPostgres.swift
//  ManaKit_Example
//
//  Created by Vito Royeca on 10/27/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation
import ManaKit
import PromiseKit
import SwiftKuery
import SwiftKueryPostgreSQL

extension Maintainer {
    func createArtistPromise(artist: String, connection: PostgreSQLConnection) -> Promise<Void> {
        let names = artist.components(separatedBy: " ")
        var firstName = ""
        var lastName = ""
        var nameSection = ""
        
        if names.count > 1 {
            if let last = names.last {
                lastName = last
                nameSection = lastName
            }
            
            for i in 0...names.count - 2 {
                firstName.append("\(names[i])")
                if i != names.count - 2 && names.count >= 3 {
                    firstName.append(" ")
                }
            }
            
        } else {
            firstName = names.first ?? "NULL"
            nameSection = firstName
        }
        nameSection = sectionFor(name: nameSection) ?? "NULL"
        
        let query = "SELECT createOrUpdateArtist($1,$2,$3,$4)"
        let parameters = [artist,
                          firstName,
                          lastName,
                          nameSection]
        return createPromise(with: query,
                             parameters: parameters,
                             connection: connection)
    }
    
    func createRarityPromise(rarity: String, connection: PostgreSQLConnection) -> Promise<Void> {
        let capName = capitalize(string: displayFor(name: rarity))
        let nameSection = sectionFor(name: rarity) ?? "NULL"
        
        let query = "SELECT createOrUpdateRarity($1,$2)"
        let parameters = [capName,
                          nameSection]
        return createPromise(with: query,
                             parameters: parameters,
                             connection: connection)
    }
    
    func createLanguagePromise(code: String, displayCode: String, name: String, connection: PostgreSQLConnection) -> Promise<Void> {
        let nameSection = sectionFor(name: name) ?? "NULL"
        
        let query = "SELECT createOrUpdateLanguage($1,$2,$3,$4)"
        let parameters = [code,
                          displayCode,
                          name,
                          nameSection]
        return createPromise(with: query,
                             parameters: parameters,
                             connection: connection)
    }
    
    func createLayoutPromise(name: String, description_: String, connection: PostgreSQLConnection) -> Promise<Void> {
        let capName = capitalize(string: displayFor(name: name))
        let nameSection = sectionFor(name: name) ?? "NULL"
        
        let query = "SELECT createOrUpdateLayout($1,$2,$3)"
        let parameters = [capName,
                          nameSection,
                          description_]
        return createPromise(with: query,
                             parameters: parameters,
                             connection: connection)
    }
    
    func createWatermarkPromise(name: String, connection: PostgreSQLConnection) -> Promise<Void> {
        let capName = capitalize(string: displayFor(name: name))
        let nameSection = sectionFor(name: name) ?? "NULL"
        
        let query = "SELECT createOrUpdateWatermark($1,$2)"
        let parameters = [capName,
                          nameSection]
        return createPromise(with: query,
                             parameters: parameters,
                             connection: connection)
    }
    
    func createFramePromise(name: String, description_: String, connection: PostgreSQLConnection) -> Promise<Void> {
        let capName = capitalize(string: displayFor(name: name))
        let nameSection = sectionFor(name: name) ?? "NULL"
        
        let query = "SELECT createOrUpdateFrame($1,$2,$3)"
        let parameters = [capName,
                          nameSection,
                          description_]
        return createPromise(with: query,
                             parameters: parameters,
                             connection: connection)
    }
    
    func createFrameEffectPromise(id: String, name: String, description_: String, connection: PostgreSQLConnection) -> Promise<Void> {
        let nameSection = sectionFor(name: name) ?? "NULL"
        
        let query = "SELECT createOrUpdateFrameEffect($1,$2,$3,$4)"
        let parameters = [id,
                          name,
                          nameSection,
                          description_]
        return createPromise(with: query,
                             parameters: parameters,
                             connection: connection)
    }
    
    func createColorPromise(symbol: String, name: String, isManaColor: Bool, connection: PostgreSQLConnection) -> Promise<Void> {
        let nameSection = sectionFor(name: name) ?? "NULL"
        
        let query = "SELECT createOrUpdateColor($1,$2,$3,$4)"
        let parameters = [symbol,
                          name,
                          nameSection,
                          isManaColor] as [Any]
        return createPromise(with: query,
                             parameters: parameters,
                             connection: connection)
    }
    
    func createFormatPromise(name: String, connection: PostgreSQLConnection) -> Promise<Void> {
        let capName = capitalize(string: displayFor(name: name))
        let nameSection = sectionFor(name: name) ?? "NULL"
        
        let query = "SELECT createOrUpdateFormat($1,$2)"
        let parameters = [capName,
                          nameSection]
        return createPromise(with: query,
                             parameters: parameters,
                             connection: connection)
    }
    
    func createLegalityPromise(name: String, connection: PostgreSQLConnection) -> Promise<Void> {
        let capName = capitalize(string: displayFor(name: name))
        let nameSection = sectionFor(name: name) ?? "NULL"
        
        let query = "SELECT createOrUpdateLegality($1,$2)"
        let parameters = [capName,
                          nameSection]
        return createPromise(with: query,
                             parameters: parameters,
                             connection: connection)
    }
    
    func createCardTypePromise(name: String, parent: String, connection: PostgreSQLConnection) -> Promise<Void> {
        let nameSection = sectionFor(name: name) ?? "NULL"
        
        let query = "SELECT createOrUpdateCardType($1,$2,$3)"
        let parameters = [name,
                          nameSection,
                          parent]
        return createPromise(with: query,
                             parameters: parameters,
                             connection: connection)
    }
    
    func createComponentPromise(name: String, connection: PostgreSQLConnection) -> Promise<Void> {
        let capName = capitalize(string: displayFor(name: name))
        let nameSection = sectionFor(name: name) ?? "NULL"
        
        let query = "SELECT createOrUpdateComponent($1,$2)"
        let parameters = [capName,
                          nameSection]
        return createPromise(with: query,
                             parameters: parameters,
                             connection: connection)
    }
    
    func createDeleteFacesPromise(connection: PostgreSQLConnection) -> Promise<Void> {
        let query = "DELETE FROM cmcard_face"
        return createPromise(with: query,
                             parameters: nil,
                             connection: connection)
    }
    
    func createFacePromise(card: String, cardFace: String, connection: PostgreSQLConnection) -> Promise<Void> {
        let query = "SELECT createOrUpdateCardFaces($1,$2)"
        let parameters = [card,
                          cardFace]
        return createPromise(with: query,
                             parameters: parameters,
                             connection: connection)
    }
    
    func createDeletePartsPromise(connection: PostgreSQLConnection) -> Promise<Void> {
        let query = "DELETE FROM cmcard_component_part"
        return createPromise(with: query,
                             parameters: nil,
                             connection: connection)
    }
    
    func createPartPromise(card: String, component: String, cardPart: String, connection: PostgreSQLConnection) -> Promise<Void> {
        let capName = capitalize(string: displayFor(name: component))
        
        let query = "SELECT createOrUpdateCardParts($1,$2,$3)"
        let parameters = [card,
                          capName,
                          cardPart]
        return createPromise(with: query,
                             parameters: parameters,
                             connection: connection)
    }

    func createOtherLanguagesPromise() -> Promise<Void> {
        return createPromise(with: "select createOrUpdateCardOtherLanguages()",
                         parameters: nil,
                         connection: nil)
    }

    func createOtherPrintingsPromise() -> Promise<Void> {
        return createPromise(with: "select createOrUpdateCardOtherPrintings()",
                             parameters: nil,
                             connection: nil)
    }
    
    func createVariationsPromise() -> Promise<Void> {
        return createPromise(with: "select createOrUpdateCardVariations()",
                             parameters: nil,
                             connection: nil)
    }
    
    func createCardPromise(dict: [String: Any], connection: PostgreSQLConnection) -> Promise<Void> {
        let collectorNumber = dict["collector_number"] ?? "NULL"
        let cmc = dict["cmc"] ?? Double(0)
        let flavorText = dict["flavor_text"] ?? "NULL"
        var imageUris = "{}"
        if let imageUrisDict = dict["image_uris"] as? [String: String] {
            // remove the key (?APIKEY) in the url
            var newImageUris = [String: String]()
            for (k,v) in imageUrisDict {
                newImageUris[k] = v.components(separatedBy: "?").first
            }

            imageUris = "\(newImageUris)"
                .replacingOccurrences(of: "[", with: "{")
                .replacingOccurrences(of: "]", with: "}")
        }
        let isFoil = dict["foil"] ?? false
        let isFullArt = dict["full_art"] ?? false
        let isHighresImage = dict["highres_image"] ?? false
        let isNonfoil = dict["nonfoil"] ?? false
        let isOversized = dict["oversized"] ?? false
        let isReserved = dict["reserved"] ?? false
        let isStorySpotlight = dict["story_spotlight"] ?? false
        let loyalty = dict["loyalty"] ?? "NULL"
        let manaCost = dict["mana_cost"] ?? "NULL"
        var multiverseIds = "{}"
        if let a = dict["multiverse_ids"] as? [Int],
            !a.isEmpty {
            multiverseIds = "\(a)"
                .replacingOccurrences(of: "[", with: "{")
                .replacingOccurrences(of: "]", with: "}")
        }
        var myNameSection = "NULL";
        if let name = dict["name"] as? String {
            myNameSection = self.sectionFor(name: name) ?? "NULL"
        }
        let name = dict["name"] ?? "NULL"
        let oracleText = dict["oracle_text"] ?? "NULL"
        let power = dict["power"] ?? "NULL"
        let printedName = dict["printed_name"] ?? "NULL"
        let printedText = dict["printed_text"] ?? "NULL"
        let toughness = dict["toughness"] ?? "NULL"
        let arenaId = dict["arena_id"] ?? "NULL"
        let mtgoId = dict["mtgo_id"] ?? "NULL"
        let tcgplayerId = dict["tcgplayer_id"] ?? "NULL"
        let handModifier = dict["hand_modifier"] ?? "NULL"
        let lifeModifier = dict["life_modifier"] ?? "NULL"
        let isBooster = dict["booster"] ?? false
        let isDigital = dict["digital"] ?? false
        let isPromo = dict["promo"] ?? false
        let releasedAt = dict["released_at"] ?? "NULL"
        let isTextless = dict["textless"] ?? false
        let mtgoFoilId = dict["mtgo_foil_id"] ?? "NULL"
        let isReprint = dict["reprint"] ?? false
        let id = dict["id"] ?? "NULL"
        let cardBackId = dict["card_back_id"] ?? "NULL"
        let oracleId = dict["oracle_id"] ?? "NULL"
        let illustrationId = dict["illustration_id"] ?? "NULL"
        let artist = dict["artist"] ?? "NULL"
        let set = dict["set"] ?? "NULL"
        let rarity = capitalize(string: dict["rarity"] as? String ?? "NULL")
        let language = dict["lang"] ?? "NULL"
        let layout = capitalize(string: displayFor(name: dict["layout"] as? String ?? "NULL"))
        let watermark = capitalize(string: dict["watermark"] as? String ?? "NULL")
        let frame = capitalize(string: dict["frame"] as? String ?? "NULL")
        var frameEffects = "{}"
        if let a = dict["frame_effects"] as? [String],
            !a.isEmpty {
            frameEffects = "\(a)"
                .replacingOccurrences(of: "[", with: "{")
                .replacingOccurrences(of: "]", with: "}")
        }
        var colors = "{}"
        if let a = dict["colors"] as? [String],
            !a.isEmpty {
            colors = "\(a)"
                .replacingOccurrences(of: "[", with: "{")
                .replacingOccurrences(of: "]", with: "}")
        }
        var colorIdentities = "{}"
        if let a = dict["color_identity"] as? [String],
            !a.isEmpty {
            colorIdentities = "\(a)"
                .replacingOccurrences(of: "[", with: "{")
                .replacingOccurrences(of: "]", with: "}")
        }
        var colorIndicators = "{}"
        if let a = dict["color_indicator"] as? [String],
            !a.isEmpty {
            colorIndicators = "\(a)"
                .replacingOccurrences(of: "[", with: "{")
                .replacingOccurrences(of: "]", with: "}")
        }
        var legalities = "{}"
        if let legalitiesDict = dict["legalities"] as? [String: String] {
            var newLegalities = [String: String]()
            for (k,v) in legalitiesDict {
                newLegalities[capitalize(string: displayFor(name: k))] = capitalize(string: displayFor(name: v))
            }
            legalities = "\(newLegalities)"
                .replacingOccurrences(of: "[", with: "{")
                .replacingOccurrences(of: "]", with: "}")
        }
        let typeLine = dict["type_line"] ?? "NULL"
        let printedTypeLine = dict["printed_type_line"] ?? "NULL"
        var cardtypeSubtypes = "{}"
        if let tl = dict["type_line"] as? String {
            let subtypes = extractSubtypesFrom(tl)
            cardtypeSubtypes = "\(subtypes)"
                .replacingOccurrences(of: "[", with: "{")
                .replacingOccurrences(of: "]", with: "}")
        }
        var cardtypeSupertypes = "{}"
        if let tl = dict["type_line"] as? String {
            let supertypes = extractSupertypesFrom(tl)
            cardtypeSupertypes = "\(supertypes)"
                .replacingOccurrences(of: "[", with: "{")
                .replacingOccurrences(of: "]", with: "}")
        }
        let faceOrder = dict["face_order"] ?? 0
        
        // unhandled...
        // border_color
        // games
        // promo_types
        // preview.previewed_at
        // preview.source_uri
        // preview.source
        let query = "SELECT createOrUpdateCard($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15,$16,$17,$18,$19,$20,$21,$22,$23,$24,$25,$26,$27,$28,$29,$30,$31,$32,$33,$34,$35,$36,$37,$38,$39,$40,$41,$42,$43,$44,$45,$46,$47,$48,$49,$50,$51,$52,$53,$54)"
        let parameters = [collectorNumber,
                          cmc,
                          flavorText,
                          imageUris,
                          isFoil,
                          isFullArt,
                          isHighresImage,
                          isNonfoil,
                          isOversized,
                          isReserved,
                          isStorySpotlight,
                          loyalty,
                          manaCost,
                          multiverseIds,
                          myNameSection,
                          name,
                          oracleText,
                          power,
                          printedName,
                          printedText,
                          toughness,
                          arenaId,
                          mtgoId,
                          tcgplayerId,
                          handModifier,
                          lifeModifier,
                          isBooster,
                          isDigital,
                          isPromo,
                          releasedAt,
                          isTextless,
                          mtgoFoilId,
                          isReprint,
                          id,
                          cardBackId,
                          oracleId,
                          illustrationId,
                          artist,
                          set,
                          rarity,
                          language,
                          layout,
                          watermark,
                          frame,
                          frameEffects,
                          colors,
                          colorIdentities,
                          colorIndicators,
                          legalities,
                          typeLine,
                          printedTypeLine,
                          cardtypeSubtypes,
                          cardtypeSupertypes,
                          faceOrder]
        return createPromise(with: query,
                             parameters: parameters,
                             connection: connection)
    }
}
