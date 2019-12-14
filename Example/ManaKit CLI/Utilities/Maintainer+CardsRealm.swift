//
//  Maintainer+CardsRealm.swift
//  ManaKit_Example
//
//  Created by Vito Royeca on 10/27/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation
import ManaKit
import PromiseKit
import RealmSwift

extension Maintainer {
    func processCardData(dict: [String: Any], languageCode: String?) -> CMCard {
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
