//
//  SDCard.swift
//
//
//  Created by Vito Royeca on 2/8/24.
//

import Foundation
import SwiftData

@Model
public class SDCard {
    // MARK: - Properties

    public var artCropURL: String?
    public var arenaID: String?
    public var cardBackID: String?
    public var cmc: Double
    public var collectorNumber: String?
    public var faceOrder: Int32
    public var flavorText: String?
    public var handModifier: String?
    public var illustrationID: String?
    public var isBooster: Bool
    public var isDigital: Bool
    public var isFoil: Bool
    public var isFullArt: Bool
    public var isHighResImage: Bool
    public var isNonFoil: Bool
    public var isOversized: Bool
    public var isPromo: Bool
    public var isReprint: Bool
    public var isReserved: Bool
    public var isStorySpotlight: Bool
    public var isTextless: Bool
    public var lifeModifier: String?
    public var loyalty: String?
    public var manaCost: String?
    public var mtgoFoilID: String?
    public var mtgoID: String?
    public var multiverseIDs: Data?
    public var nameSection: String?
    public var normalURL: String?
    public var numberOrder: Double
    public var name: String?
    
    @Attribute(.unique)
    public var newID: String

    public var oracleID: String?
    public var oracleText: String?
    public var pngURL: String?
    public var power: String?
    public var printedName: String?
    public var printedText: String?
    public var printedTypeLine: String?
    public var releaseDate: Date?
    public var tcgPlayerID: Int64
    public var toughness: String?
    public var typeLine: String?

    // MARK: - Relationships

    @Relationship(inverse: \SDArtist.cards)
    public var artists: [SDArtist]

//    public var componentParts: NSSet?
//    public var colorIdentities: NSSet?
//    public var colorIndicators: NSSet?
//    public var colors: NSSet?
//    public var face: MGCard?
//    public var faces: NSSet?
//    public var formatLegalities: NSSet?
//    public var frame: MGFrame?
//    public var frameEffects: NSSet?
//    public var games: NSSet?
//    public var keywords: NSSet?

    public var language: SDLanguage?

//    public var layout: MGLayout?

    @Relationship(inverse: \SDLanguage.cardOtherLanguagess)
    public var otherLanguages: [SDLanguage]

//    public var otherPrintings: NSSet?
//    public var otherPrintingInverses: NSSet?
//    public var prices: NSSet?
//    public var rarity: MGRarity?
//    public var rulings: NSSet?
    
    public var set: SDSet?

//    public var subtypes: NSSet?
//    public var supertypes: NSSet?
//    public var type: MGCardType?
//    public var variation: MGCard?
//    public var variations: NSSet?
//    public var watermark: MGWatermark?

    // MARK: - Initializers

    init(artCropURL: String?,
         arenaID: String?,
         cardBackID: String?,
         cmc: Double,
         collectorNumber: String?,
         faceOrder: Int32,
         flavorText: String?,
         handModifier: String?,
         illustrationID: String?,
         isBooster: Bool,
         isDigital: Bool,
         isFoil: Bool,
         isFullArt: Bool,
         isHighResImage: Bool,
         isNonFoil: Bool,
         isOversized: Bool,
         isPromo: Bool,
         isReprint: Bool,
         isReserved: Bool,
         isStorySpotlight: Bool,
         isTextless: Bool,
         lifeModifier: String?,
         loyalty: String?,
         manaCost: String?,
         mtgoFoilID: String?,
         mtgoID: String?,
         multiverseIDs: Data?,
         nameSection: String?,
         normalURL: String?,
         numberOrder: Double,
         name: String?,
         newID: String,
         oracleID: String?,
         oracleText: String?,
         pngURL: String?,
         power: String?,
         printedName: String?,
         printedText: String?,
         printedTypeLine: String?,
         releaseDate: Date?,
         tcgPlayerID: Int64,
         toughness: String?,
         typeLine: String?,
         artists: [SDArtist],
//         componentParts: NSSet?,
//         colorIdentities: NSSet?,
//         colorIndicators: NSSet?,
//         colors: NSSet?,
//         face: MGCard?,
//         faces: NSSet?,
//         formatLegalities: NSSet?,
//         frame: MGFrame?,
//         frameEffects: NSSet?,
//         games: NSSet?,
//         keywords: NSSet?,
         language: SDLanguage?,
//         layout: MGLayout?,
         otherLanguages: [SDLanguage],
//         otherPrintings: NSSet?,
//         otherPrintingInverses: NSSet?,
//         prices: NSSet?,
//         rarity: MGRarity?,
//         rulings: NSSet?,
         set: SDSet?
//         subtypes: NSSet?,
//         supertypes: NSSet?,
//         type: MGCardType?,
//         variation: MGCard?,
//         variations: NSSet?,
         /*watermark: MGWatermark?*/) {
        self.artCropURL = artCropURL
        self.arenaID = arenaID
        self.cardBackID = cardBackID
        self.cmc = cmc
        self.collectorNumber = collectorNumber
        self.faceOrder = faceOrder
        self.flavorText = flavorText
        self.handModifier = handModifier
        self.illustrationID = illustrationID
        self.isBooster = isBooster
        self.isDigital = isDigital
        self.isFoil = isFoil
        self.isFullArt = isFullArt
        self.isHighResImage = isHighResImage
        self.isNonFoil = isNonFoil
        self.isOversized = isOversized
        self.isPromo = isPromo
        self.isReprint = isReprint
        self.isReserved = isReserved
        self.isStorySpotlight = isStorySpotlight
        self.isTextless = isTextless
        self.lifeModifier = lifeModifier
        self.loyalty = loyalty
        self.manaCost = manaCost
        self.mtgoFoilID = mtgoFoilID
        self.mtgoID = mtgoID
        self.multiverseIDs = multiverseIDs
        self.nameSection = name
        self.normalURL = normalURL
        self.numberOrder = numberOrder
        self.name = name
        self.newID = newID
        self.oracleID = oracleID
        self.oracleText = oracleText
        self.pngURL = pngURL
        self.power = power
        self.printedName = printedName
        self.printedText = printedText
        self.printedTypeLine = printedTypeLine
        self.releaseDate = releaseDate
        self.tcgPlayerID = tcgPlayerID
        self.toughness = toughness
        self.typeLine = typeLine
        self.artists = artists
//         componentParts: NSSet?,
//         colorIdentities: NSSet?,
//         colorIndicators: NSSet?,
//         colors: NSSet?,
//         face: MGCard?,
//         faces: NSSet?,
//         formatLegalities: NSSet?,
//         frame: MGFrame?,
//         frameEffects: NSSet?,
//         games: NSSet?,
//         keywords: NSSet?,
        self.language = language
//         layout: MGLayout?,
        self.otherLanguages = otherLanguages
//         otherPrintings: NSSet?,
//         otherPrintingInverses: NSSet?,
//         prices: NSSet?,
//         rarity: MGRarity?,
//         rulings: NSSet?,
        self.set = set
//         subtypes: NSSet?,
//         supertypes: NSSet?,
//         type: MGCardType?,
//         variation: MGCard?,
//         variations: NSSet?,
         /*watermark: MGWatermark?*/
        
    }
}
