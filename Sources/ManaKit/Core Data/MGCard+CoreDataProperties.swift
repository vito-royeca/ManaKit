//
//  MGCard+CoreDataProperties.swift
//  
//
//  Created by Vito Royeca on 12/27/21.
//
//

import Foundation
import CoreData


extension MGCard {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MGCard> {
        let request = NSFetchRequest<MGCard>(entityName: "MGCard")
        
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        return request
    }

    @NSManaged public var artCropURL: String?
    @NSManaged public var arenaID: String?
    @NSManaged public var cardBackID: String?
    @NSManaged public var cmc: Double
    @NSManaged public var collectorNumber: String?
    @NSManaged public var faceOrder: Int32
    @NSManaged public var flavorText: String?
    @NSManaged public var handModifier: String?
    @NSManaged public var illustrationID: String?
    @NSManaged public var isBooster: Bool
    @NSManaged public var isDigital: Bool
    @NSManaged public var isFoil: Bool
    @NSManaged public var isFullArt: Bool
    @NSManaged public var isHighResImage: Bool
    @NSManaged public var isNonFoil: Bool
    @NSManaged public var isOversized: Bool
    @NSManaged public var isPromo: Bool
    @NSManaged public var isReprint: Bool
    @NSManaged public var isReserved: Bool
    @NSManaged public var isStorySpotlight: Bool
    @NSManaged public var isTextless: Bool
    @NSManaged public var lifeModifier: String?
    @NSManaged public var loyalty: String?
    @NSManaged public var manaCost: String?
    @NSManaged public var mtgoFoilID: String?
    @NSManaged public var mtgoID: String?
    @NSManaged public var multiverseIDs: Data?
    @NSManaged public var nameSection: String?
    @NSManaged public var normalURL: String?
    @NSManaged public var numberOrder: Double
    @NSManaged public var name: String?
    @NSManaged public var newID: String
    @NSManaged public var oracleID: String?
    @NSManaged public var oracleText: String?
    @NSManaged public var pngURL: String?
    @NSManaged public var power: String?
    @NSManaged public var printedName: String?
    @NSManaged public var printedText: String?
    @NSManaged public var printedTypeLine: String?
    @NSManaged public var releaseDate: Date?
    @NSManaged public var tcgPlayerID: Int64
    @NSManaged public var toughness: String?
    @NSManaged public var typeLine: String?
    @NSManaged public var artists: NSSet?
    @NSManaged public var componentParts: NSSet?
    @NSManaged public var colorIdentities: NSSet?
    @NSManaged public var colorIndicators: NSSet?
    @NSManaged public var colors: NSSet?
    @NSManaged public var face: MGCard?
    @NSManaged public var faces: NSSet?
    @NSManaged public var formatLegalities: NSSet?
    @NSManaged public var frame: MGFrame?
    @NSManaged public var frameEffects: NSSet?
    @NSManaged public var games: NSSet?
    @NSManaged public var keywords: NSSet?
    @NSManaged public var language: MGLanguage?
    @NSManaged public var layout: MGLayout?
    @NSManaged public var otherLanguages: NSSet?
    @NSManaged public var otherPrintings: NSSet?
    @NSManaged public var otherPrintingInverses: NSSet?
    @NSManaged public var prices: NSSet?
    @NSManaged public var rarity: MGRarity?
    @NSManaged public var rulings: NSSet?
    @NSManaged public var set: MGSet?
    @NSManaged public var subtypes: NSSet?
    @NSManaged public var supertypes: NSSet?
    @NSManaged public var type: MGCardType?
    @NSManaged public var variation: MGCard?
    @NSManaged public var variations: NSSet?
    @NSManaged public var watermark: MGWatermark?
    @NSManaged public var searchResults: NSSet?

}

// MARK: Generated accessors for artists
extension MGCard {

    @objc(addArtistsObject:)
    @NSManaged public func addToArtists(_ value: MGArtist)

    @objc(removeArtistsObject:)
    @NSManaged public func removeFromArtists(_ value: MGArtist)

    @objc(addArtists:)
    @NSManaged public func addToArtists(_ values: NSSet)

    @objc(removeArtists:)
    @NSManaged public func removeFromArtists(_ values: NSSet)

}

// MARK: Generated accessors for colorIdentities
extension MGCard {

    @objc(addColorIdentitiesObject:)
    @NSManaged public func addToColorIdentities(_ value: MGColor)

    @objc(removeColorIdentitiesObject:)
    @NSManaged public func removeFromColorIdentities(_ value: MGColor)

    @objc(addColorIdentities:)
    @NSManaged public func addToColorIdentities(_ values: NSSet)

    @objc(removeColorIdentities:)
    @NSManaged public func removeFromColorIdentities(_ values: NSSet)

}

// MARK: Generated accessors for colorIndicators
extension MGCard {

    @objc(addColorIndicatorsObject:)
    @NSManaged public func addToColorIndicators(_ value: MGColor)

    @objc(removeColorIndicatorsObject:)
    @NSManaged public func removeFromColorIndicators(_ value: MGColor)

    @objc(addColorIndicators:)
    @NSManaged public func addToColorIndicators(_ values: NSSet)

    @objc(removeColorIndicators:)
    @NSManaged public func removeFromColorIndicators(_ values: NSSet)

}

// MARK: Generated accessors for colors
extension MGCard {

    @objc(addColorsObject:)
    @NSManaged public func addToColors(_ value: MGColor)

    @objc(removeColorsObject:)
    @NSManaged public func removeFromColors(_ value: MGColor)

    @objc(addColors:)
    @NSManaged public func addToColors(_ values: NSSet)

    @objc(removeColors:)
    @NSManaged public func removeFromColors(_ values: NSSet)

}

// MARK: Generated accessors for componentParts
extension MGCard {

    @objc(addComponentPartsObject:)
    @NSManaged public func addToComponentParts(_ value: MGCardComponentPart)

    @objc(removeComponentPartsObject:)
    @NSManaged public func removeFromComponentParts(_ value: MGCardComponentPart)

    @objc(addComponentParts:)
    @NSManaged public func addToComponentParts(_ values: NSSet)

    @objc(removeComponentParts:)
    @NSManaged public func removeFromComponentParts(_ values: NSSet)

}

// MARK: Generated accessors for faces
extension MGCard {

    @objc(addFacesObject:)
    @NSManaged public func addToFaces(_ value: MGCard)

    @objc(removeFacesObject:)
    @NSManaged public func removeFromFaces(_ value: MGCard)

    @objc(addFaces:)
    @NSManaged public func addToFaces(_ values: NSSet)

    @objc(removeFaces:)
    @NSManaged public func removeFromFaces(_ values: NSSet)

}

// MARK: Generated accessors for formatLegalities
extension MGCard {

    @objc(addFormatLegalitiesObject:)
    @NSManaged public func addToFormatLegalities(_ value: MGCardFormatLegality)

    @objc(removeFormatLegalitiesObject:)
    @NSManaged public func removeFromFormatLegalities(_ value: MGCardFormatLegality)

    @objc(addFormatLegalities:)
    @NSManaged public func addToFormatLegalities(_ values: NSSet)

    @objc(removeFormatLegalities:)
    @NSManaged public func removeFromFormatLegalities(_ values: NSSet)

}

// MARK: Generated accessors for frameEffects
extension MGCard {

    @objc(addFrameEffectsObject:)
    @NSManaged public func addToFrameEffects(_ value: MGFrameEffect)

    @objc(removeFrameEffectsObject:)
    @NSManaged public func removeFromFrameEffects(_ value: MGFrameEffect)

    @objc(addFrameEffects:)
    @NSManaged public func addToFrameEffects(_ values: NSSet)

    @objc(removeFrameEffects:)
    @NSManaged public func removeFromFrameEffects(_ values: NSSet)

}

// MARK: Generated accessors for games
extension MGCard {

    @objc(addGamesObject:)
    @NSManaged public func addToGames(_ value: MGGame)

    @objc(removeGamesObject:)
    @NSManaged public func removeFromGames(_ value: MGGame)

    @objc(addGames:)
    @NSManaged public func addToGames(_ values: NSSet)

    @objc(removeGames:)
    @NSManaged public func removeFromGames(_ values: NSSet)

}

// MARK: Generated accessors for keywords
extension MGCard {

    @objc(addKeywordsObject:)
    @NSManaged public func addToKeywords(_ value: MGKeyword)

    @objc(removeKeywordsObject:)
    @NSManaged public func removeFromKeywords(_ value: MGKeyword)

    @objc(addKeywords:)
    @NSManaged public func addToKeywords(_ values: NSSet)

    @objc(removeKeywords:)
    @NSManaged public func removeFromKeywords(_ values: NSSet)

}

// MARK: Generated accessors for otherLanguages
extension MGCard {

    @objc(addOtherLanguagesObject:)
    @NSManaged public func addToOtherLanguages(_ value: MGCard)

    @objc(removeOtherLanguagesObject:)
    @NSManaged public func removeFromOtherLanguages(_ value: MGCard)

    @objc(addOtherLanguages:)
    @NSManaged public func addToOtherLanguages(_ values: NSSet)

    @objc(removeOtherLanguages:)
    @NSManaged public func removeFromOtherLanguages(_ values: NSSet)

}

// MARK: Generated accessors for otherPrintings
extension MGCard {

    @objc(addOtherPrintingsObject:)
    @NSManaged public func addToOtherPrintings(_ value: MGCard)

    @objc(removeOtherPrintingsObject:)
    @NSManaged public func removeFromOtherPrintings(_ value: MGCard)

    @objc(addOtherPrintings:)
    @NSManaged public func addToOtherPrintings(_ values: NSSet)

    @objc(removeOtherPrintings:)
    @NSManaged public func removeFromOtherPrintings(_ values: NSSet)

}

// MARK: Generated accessors for parts
extension MGCard {

    @objc(addPartsObject:)
    @NSManaged public func addToParts(_ value: MGCard)

    @objc(removePartsObject:)
    @NSManaged public func removeFromParts(_ value: MGCard)

    @objc(addParts:)
    @NSManaged public func addToParts(_ values: NSSet)

    @objc(removeParts:)
    @NSManaged public func removeFromParts(_ values: NSSet)

}

// MARK: Generated accessors for prices
extension MGCard {

    @objc(addPricesObject:)
    @NSManaged public func addToPrices(_ value: MGCardPrice)

    @objc(removePricesObject:)
    @NSManaged public func removeFromPrices(_ value: MGCardPrice)

    @objc(addPrices:)
    @NSManaged public func addToPrices(_ values: NSSet)

    @objc(removePrices:)
    @NSManaged public func removeFromPrices(_ values: NSSet)

}

// MARK: Generated accessors for rulings
extension MGCard {

    @objc(addRulingsObject:)
    @NSManaged public func addToRulings(_ value: MGRuling)

    @objc(removeRulingsObject:)
    @NSManaged public func removeFromRulings(_ value: MGRuling)

    @objc(addRulings:)
    @NSManaged public func addToRulings(_ values: NSSet)

    @objc(removeRulings:)
    @NSManaged public func removeFromRulings(_ values: NSSet)

}

// MARK: Generated accessors for subtypes
extension MGCard {

    @objc(addSubtypesObject:)
    @NSManaged public func addToSubtypes(_ value: MGCardType)

    @objc(removeSubtypesObject:)
    @NSManaged public func removeFromSubtypes(_ value: MGCardType)

    @objc(addSubtypes:)
    @NSManaged public func addToSubtypes(_ values: NSSet)

    @objc(removeSubtypes:)
    @NSManaged public func removeFromSubtypes(_ values: NSSet)

}

// MARK: Generated accessors for supertypes
extension MGCard {

    @objc(addSupertypesObject:)
    @NSManaged public func addToSupertypes(_ value: MGCardType)

    @objc(removeSupertypesObject:)
    @NSManaged public func removeFromSupertypes(_ value: MGCardType)

    @objc(addSupertypes:)
    @NSManaged public func addToSupertypes(_ values: NSSet)

    @objc(removeSupertypes:)
    @NSManaged public func removeFromSupertypes(_ values: NSSet)

}

// MARK: Generated accessors for variations
extension MGCard {

    @objc(addVariationsObject:)
    @NSManaged public func addToVariations(_ value: MGCard)

    @objc(removeVariationsObject:)
    @NSManaged public func removeFromVariations(_ value: MGCard)

    @objc(addVariations:)
    @NSManaged public func addToVariations(_ values: NSSet)

    @objc(removeVariations:)
    @NSManaged public func removeFromVariations(_ values: NSSet)

}

// MARK: Generated accessors for searchResults
extension MGCard {

    @objc(addSearchResultsObject:)
    @NSManaged public func addToSearchResults(_ value: SearchResult)

    @objc(removeSearchResultsObject:)
    @NSManaged public func removeFromSearchResults(_ value: SearchResult)

    @objc(addSearchResults:)
    @NSManaged public func addToSearchResults(_ values: NSSet)

    @objc(removeSearchResults:)
    @NSManaged public func removeFromSearchResults(_ values: NSSet)

}
