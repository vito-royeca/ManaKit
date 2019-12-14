//
//  CMCard+CoreDataProperties.swift
//  Pods
//
//  Created by Vito Royeca on 11/26/19.
//
//

import Foundation
import CoreData


extension CMCard {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CMCard> {
        return NSFetchRequest<CMCard>(entityName: "CMCard")
    }

    @NSManaged public var arenaId: String?
    @NSManaged public var collectorNumber: String?
    @NSManaged public var cmc: Double
    @NSManaged public var faceOrder: Int32
    @NSManaged public var flavorText: String?
    @NSManaged public var id: String?
    @NSManaged public var illustrationId: String?
    @NSManaged public var imageUris: Data?
    @NSManaged public var isDigital: Bool
    @NSManaged public var isFoil: Bool
    @NSManaged public var isFullArt: Bool
    @NSManaged public var isHighResImage: Bool
    @NSManaged public var isNonFoil: Bool
    @NSManaged public var isOversized: Bool
    @NSManaged public var isReprint: Bool
    @NSManaged public var isReserved: Bool
    @NSManaged public var isStorySpotlight: Bool
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
    @NSManaged public var releasedAt: String?
    @NSManaged public var toughness: String?
    @NSManaged public var tcgPlayerId: Int32
    @NSManaged public var handModifier: String?
    @NSManaged public var lifeModifier: String?
    @NSManaged public var isBooster: Bool
    @NSManaged public var isPromo: Bool
    @NSManaged public var isTextless: Bool
    @NSManaged public var cardBackId: String?
    @NSManaged public var printedTypeLine: String?
    @NSManaged public var typeLine: String?
    @NSManaged public var artist: CMArtist?
    @NSManaged public var formatLegalities: NSSet?
    @NSManaged public var colorIdentities: NSSet?
    @NSManaged public var colorIndicators: NSSet?
    @NSManaged public var colors: NSSet?
    @NSManaged public var faces: NSSet?
    @NSManaged public var frame: CMFrame?
    @NSManaged public var frameEffect: CMFrameEffect?
    @NSManaged public var language: CMLanguage?
    @NSManaged public var layout: CMLayout?
    @NSManaged public var otherLanguages: NSSet?
    @NSManaged public var otherPrintings: NSSet?
    @NSManaged public var rarity: CMRarity?
    @NSManaged public var set: CMSet?
    @NSManaged public var variations: NSSet?
    @NSManaged public var watermark: CMWatermark?
    @NSManaged public var subtypes: NSSet?
    @NSManaged public var supertypes: NSSet?
    @NSManaged public var componentParts: NSSet?

}

// MARK: Generated accessors for formatLegalities
extension CMCard {

    @objc(addFormatLegalitiesObject:)
    @NSManaged public func addToFormatLegalities(_ value: CMCardFormatLegality)

    @objc(removeFormatLegalitiesObject:)
    @NSManaged public func removeFromFormatLegalities(_ value: CMCardFormatLegality)

    @objc(addFormatLegalities:)
    @NSManaged public func addToFormatLegalities(_ values: NSSet)

    @objc(removeFormatLegalities:)
    @NSManaged public func removeFromFormatLegalities(_ values: NSSet)

}

// MARK: Generated accessors for colorIdentities
extension CMCard {

    @objc(addColorIdentitiesObject:)
    @NSManaged public func addToColorIdentities(_ value: CMColor)

    @objc(removeColorIdentitiesObject:)
    @NSManaged public func removeFromColorIdentities(_ value: CMColor)

    @objc(addColorIdentities:)
    @NSManaged public func addToColorIdentities(_ values: NSSet)

    @objc(removeColorIdentities:)
    @NSManaged public func removeFromColorIdentities(_ values: NSSet)

}

// MARK: Generated accessors for colorIndicators
extension CMCard {

    @objc(addColorIndicatorsObject:)
    @NSManaged public func addToColorIndicators(_ value: CMColor)

    @objc(removeColorIndicatorsObject:)
    @NSManaged public func removeFromColorIndicators(_ value: CMColor)

    @objc(addColorIndicators:)
    @NSManaged public func addToColorIndicators(_ values: NSSet)

    @objc(removeColorIndicators:)
    @NSManaged public func removeFromColorIndicators(_ values: NSSet)

}

// MARK: Generated accessors for colors
extension CMCard {

    @objc(addColorsObject:)
    @NSManaged public func addToColors(_ value: CMColor)

    @objc(removeColorsObject:)
    @NSManaged public func removeFromColors(_ value: CMColor)

    @objc(addColors:)
    @NSManaged public func addToColors(_ values: NSSet)

    @objc(removeColors:)
    @NSManaged public func removeFromColors(_ values: NSSet)

}

// MARK: Generated accessors for faces
extension CMCard {

    @objc(addFacesObject:)
    @NSManaged public func addToFaces(_ value: CMCard)

    @objc(removeFacesObject:)
    @NSManaged public func removeFromFaces(_ value: CMCard)

    @objc(addFaces:)
    @NSManaged public func addToFaces(_ values: NSSet)

    @objc(removeFaces:)
    @NSManaged public func removeFromFaces(_ values: NSSet)

}

// MARK: Generated accessors for otherLanguages
extension CMCard {

    @objc(addOtherLanguagesObject:)
    @NSManaged public func addToOtherLanguages(_ value: CMCard)

    @objc(removeOtherLanguagesObject:)
    @NSManaged public func removeFromOtherLanguages(_ value: CMCard)

    @objc(addOtherLanguages:)
    @NSManaged public func addToOtherLanguages(_ values: NSSet)

    @objc(removeOtherLanguages:)
    @NSManaged public func removeFromOtherLanguages(_ values: NSSet)

}

// MARK: Generated accessors for otherPrintings
extension CMCard {

    @objc(addOtherPrintingsObject:)
    @NSManaged public func addToOtherPrintings(_ value: CMCard)

    @objc(removeOtherPrintingsObject:)
    @NSManaged public func removeFromOtherPrintings(_ value: CMCard)

    @objc(addOtherPrintings:)
    @NSManaged public func addToOtherPrintings(_ values: NSSet)

    @objc(removeOtherPrintings:)
    @NSManaged public func removeFromOtherPrintings(_ values: NSSet)

}

// MARK: Generated accessors for variations
extension CMCard {

    @objc(addVariationsObject:)
    @NSManaged public func addToVariations(_ value: CMCard)

    @objc(removeVariationsObject:)
    @NSManaged public func removeFromVariations(_ value: CMCard)

    @objc(addVariations:)
    @NSManaged public func addToVariations(_ values: NSSet)

    @objc(removeVariations:)
    @NSManaged public func removeFromVariations(_ values: NSSet)

}

// MARK: Generated accessors for subtypes
extension CMCard {

    @objc(addSubtypesObject:)
    @NSManaged public func addToSubtypes(_ value: CMCardType)

    @objc(removeSubtypesObject:)
    @NSManaged public func removeFromSubtypes(_ value: CMCardType)

    @objc(addSubtypes:)
    @NSManaged public func addToSubtypes(_ values: NSSet)

    @objc(removeSubtypes:)
    @NSManaged public func removeFromSubtypes(_ values: NSSet)

}

// MARK: Generated accessors for supertypes
extension CMCard {

    @objc(addSupertypesObject:)
    @NSManaged public func addToSupertypes(_ value: CMCardType)

    @objc(removeSupertypesObject:)
    @NSManaged public func removeFromSupertypes(_ value: CMCardType)

    @objc(addSupertypes:)
    @NSManaged public func addToSupertypes(_ values: NSSet)

    @objc(removeSupertypes:)
    @NSManaged public func removeFromSupertypes(_ values: NSSet)

}

// MARK: Generated accessors for CardComponentParts
extension CMCard {

    @objc(addCardComponentPartsObject:)
    @NSManaged public func addToCardComponentParts(_ value: CMCardComponentPart)

    @objc(removeCardComponentPartsObject:)
    @NSManaged public func removeFromCardComponentParts(_ value: CMCardComponentPart)

    @objc(addCardComponentParts:)
    @NSManaged public func addToCardComponentParts(_ values: NSSet)

    @objc(removeCardComponentParts:)
    @NSManaged public func removeCardComponentParts(_ values: NSSet)

}

// MARK: Generated accessors for PartComponentParts
extension CMCard {

    @objc(addPartComponentPartsObject:)
    @NSManaged public func addToPartComponentParts(_ value: CMCardComponentPart)

    @objc(removePartComponentPartsObject:)
    @NSManaged public func removeFromPartComponentParts(_ value: CMCardComponentPart)

    @objc(addPartComponentParts:)
    @NSManaged public func addToPartComponentParts(_ values: NSSet)

    @objc(removePartComponentParts:)
    @NSManaged public func removePartComponentParts(_ values: NSSet)

}
