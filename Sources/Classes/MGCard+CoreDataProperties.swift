//
//  MGCard+CoreDataProperties.swift
//  Pods
//
//  Created by Vito Royeca on 12/14/19.
//
//

import Foundation
import CoreData


extension MGCard {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MGCard> {
        return NSFetchRequest<MGCard>(entityName: "MGCard")
    }

    @NSManaged public var arenaId: String?
    @NSManaged public var cardBackId: String?
    @NSManaged public var cmc: Double
    @NSManaged public var collectorNumber: String?
    @NSManaged public var faceOrder: Int32
    @NSManaged public var flavorText: String?
    @NSManaged public var handModifier: String?
    @NSManaged public var id: String?
    @NSManaged public var illustrationId: String?
    @NSManaged public var imageUris: Data?
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
    @NSManaged public var mtgoFoilId: String?
    @NSManaged public var mtgoId: String?
    @NSManaged public var multiverseIds: Data?
    @NSManaged public var myNameSection: String?
    @NSManaged public var myNumberOrder: Double
    @NSManaged public var name: String?
    @NSManaged public var oracleId: String?
    @NSManaged public var oracleText: String?
    @NSManaged public var power: String?
    @NSManaged public var printedName: String?
    @NSManaged public var printedText: String?
    @NSManaged public var printedTypeLine: String?
    @NSManaged public var releasedAt: String?
    @NSManaged public var tcgPlayerId: Int32
    @NSManaged public var toughness: String?
    @NSManaged public var typeLine: String?
    @NSManaged public var artist: MGArtist?
    @NSManaged public var cardComponentParts: NSSet?
    @NSManaged public var colorIdentities: NSSet?
    @NSManaged public var colorIndicators: NSSet?
    @NSManaged public var colors: NSSet?
    @NSManaged public var faces: NSSet?
    @NSManaged public var formatLegalities: NSSet?
    @NSManaged public var frame: MGFrame?
    @NSManaged public var frameEffect: MGFrameEffect?
    @NSManaged public var language: MGLanguage?
    @NSManaged public var layout: MGLayout?
    @NSManaged public var otherLanguages: NSSet?
    @NSManaged public var otherPrintings: NSSet?
    @NSManaged public var partComponentParts: NSSet?
    @NSManaged public var rarity: MGRarity?
    @NSManaged public var set: MGSet?
    @NSManaged public var subtypes: NSSet?
    @NSManaged public var supertypes: NSSet?
    @NSManaged public var variations: NSSet?
    @NSManaged public var watermark: MGWatermark?

}

// MARK: Generated accessors for cardComponentParts
extension MGCard {

    @objc(addCardComponentPartsObject:)
    @NSManaged public func addToCardComponentParts(_ value: MGCardComponentPart)

    @objc(removeCardComponentPartsObject:)
    @NSManaged public func removeFromCardComponentParts(_ value: MGCardComponentPart)

    @objc(addCardComponentParts:)
    @NSManaged public func addToCardComponentParts(_ values: NSSet)

    @objc(removeCardComponentParts:)
    @NSManaged public func removeFromCardComponentParts(_ values: NSSet)

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

// MARK: Generated accessors for partComponentParts
extension MGCard {

    @objc(addPartComponentPartsObject:)
    @NSManaged public func addToPartComponentParts(_ value: MGCardComponentPart)

    @objc(removePartComponentPartsObject:)
    @NSManaged public func removeFromPartComponentParts(_ value: MGCardComponentPart)

    @objc(addPartComponentParts:)
    @NSManaged public func addToPartComponentParts(_ values: NSSet)

    @objc(removePartComponentParts:)
    @NSManaged public func removeFromPartComponentParts(_ values: NSSet)

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