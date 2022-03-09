//
//  MGCard+CoreDataProperties.swift
//  
//
//  Created by Vito Royeca on 01/08/22.
//
//

import Foundation

public struct MCard {

    public var arenaId: String?
    public var cardBackId: String?
    public var cmc: Double
    public var collectorNumber: String?
    public var faceOrder: Int32
    public var flavorText: String?
    public var handModifier: String?
    public var illustrationId: String?
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
    public var mtgoFoilId: String?
    public var mtgoId: String?
    public var multiverseIds: Data?
    public var myNameSection: String?
    public var myNumberOrder: Double
    public var name: String?
    public var newId: String
    public var oracleId: String?
    public var oracleText: String?
    public var power: String?
    public var printedName: String?
    public var printedText: String?
    public var printedTypeLine: String?
    public var releasedAt: String?
    public var tcgPlayerId: Int64
    public var toughness: String?
    public var typeLine: String?
    public var artist: MArtist?
    public var componentParts: [MCardComponentPart]
    public var colorIdentities: [MColor]
    public var colorIndicators: [MColor]
    public var colors: [MColor]
    public var faces: [MCard]
    public var formatLegalities: [MCardFormatLegality]
    public var frame: MFrame?
    public var frameEffects: [MFrameEffect]
    public var imageUri: MImageURI?
    public var language: MLanguage?
    public var layout: MLayout?
    public var otherLanguages: [MLanguage]
    public var otherPrintings: [MCard]
    public var prices: [MCardPrice]
    public var rarity: MRarity?
    public var set: MSet?
    public var subtypes: [MCardType]
    public var supertypes: [MCardType]
    public var variations: [MCard]
    public var watermark: MWatermark?

}

// MARK: - Identifiable

extension MCard: MEntity {
    public var id: String {
        return newId
    }
}

