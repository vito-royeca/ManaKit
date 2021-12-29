//
//  MGCard+CoreDataClass.swift
//  ManaKit
//
//  Created by Vito Royeca on 12/16/21.
//

import CoreData

public class MGCard: MGEntity {
    enum CodingKeys: CodingKey {
        case arenaId,
             cardBackId,
             cmc,
             collectorNumber,
             faceOrder,
             flavorText,
             handModifier,
             illustrationId,
             imageUris,
             isBooster,
             isDigital,
             isFoil,
             isFullArt,
             isHighResImage,
             isNonFoil,
             isOversized,
             isPromo,
             isReprint,
             isReserved,
             isStorySpotlight,
             isTextless,
             lifeModifier,
             loyalty,
             manaCost,
             mtgoFoilId,
             mtgoId,
             multiverseIds,
             myNameSection,
             myNumberOrder,
             name,
             newId,
             oracleId,
             oracleText,
             power,
             printedName,
             printedText,
             printedTypeLine,
             releasedAt,
             tcgPlayerId,
             toughness,
             typeLine,
             artist,
             cardComponentParts,
             colorIdentities,
             colorIndicators,
             colors,
             faces,
             formatLegalities,
             frame,
             frameEffect,
             language,
             layout,
             otherLanguages,
             otherPrintings,
             partComponentParts,
             prices,
             rarity,
             set,
             subtypes,
             supertypes,
             variations,
             watermark
    }

    public required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
          throw DecoderConfigurationError.missingManagedObjectContext
        }
        
        self.init(context: context)

        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        arenaId = try container.decodeIfPresent(String.self, forKey: .arenaId)
        cardBackId = try container.decodeIfPresent(String.self, forKey: .cardBackId)
        cmc = try container.decodeIfPresent(Double.self, forKey: .cmc) ?? Double(0)
        collectorNumber = try container.decodeIfPresent(String.self, forKey: .collectorNumber)
        faceOrder = try container.decodeIfPresent(Int32.self, forKey: .faceOrder) ?? Int32(0)
        flavorText = try container.decodeIfPresent(String.self, forKey: .flavorText)
        handModifier = try container.decodeIfPresent(String.self, forKey: .handModifier)
        illustrationId = try container.decodeIfPresent(String.self, forKey: .illustrationId)
        if let array = try container.decodeIfPresent([MGImageURI].self, forKey: .imageUris) {
           imageUri = array.first
        }
        isBooster = try container.decodeIfPresent(Bool.self, forKey: .isBooster) ?? false
        isDigital = try container.decodeIfPresent(Bool.self, forKey: .isDigital) ?? false
        isFoil = try container.decodeIfPresent(Bool.self, forKey: .isFoil) ?? false
        isFullArt = try container.decodeIfPresent(Bool.self, forKey: .isFullArt) ?? false
        isHighResImage = try container.decodeIfPresent(Bool.self, forKey: .isHighResImage) ?? false
        isNonFoil = try container.decodeIfPresent(Bool.self, forKey: .isNonFoil) ?? false
        isOversized = try container.decodeIfPresent(Bool.self, forKey: .isOversized) ?? false
        isPromo = try container.decodeIfPresent(Bool.self, forKey: .isPromo) ?? false
        isReprint = try container.decodeIfPresent(Bool.self, forKey: .isReprint) ?? false
        isReserved = try container.decodeIfPresent(Bool.self, forKey: .isReserved) ?? false
        isStorySpotlight = try container.decodeIfPresent(Bool.self, forKey: .isStorySpotlight) ?? false
        isTextless = try container.decodeIfPresent(Bool.self, forKey: .isTextless) ?? false
        lifeModifier = try container.decodeIfPresent(String.self, forKey: .lifeModifier)
        loyalty = try container.decodeIfPresent(String.self, forKey: .loyalty)
        manaCost = try container.decodeIfPresent(String.self, forKey: .manaCost)
        mtgoFoilId = try container.decodeIfPresent(String.self, forKey: .mtgoFoilId)
        mtgoId = try container.decodeIfPresent(String.self, forKey: .mtgoId)
        if let array = try container.decodeIfPresent([Int64].self, forKey: .multiverseIds),
           !array.isEmpty {
            multiverseIds = try NSKeyedArchiver.archivedData(withRootObject: array, requiringSecureCoding: false)
        }
        myNameSection = try container.decodeIfPresent(String.self, forKey: .myNameSection)
        myNumberOrder = try container.decodeIfPresent(Double.self, forKey: .myNumberOrder) ?? Double(0)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        newId = try container.decodeIfPresent(String.self, forKey: .newId)
        oracleId = try container.decodeIfPresent(String.self, forKey: .oracleId)
        oracleText = try container.decodeIfPresent(String.self, forKey: .oracleText)
        power = try container.decodeIfPresent(String.self, forKey: .power)
        printedName = try container.decodeIfPresent(String.self, forKey: .printedName)
        printedText = try container.decodeIfPresent(String.self, forKey: .printedText)
        printedTypeLine = try container.decodeIfPresent(String.self, forKey: .printedTypeLine)
        releasedAt = try container.decodeIfPresent(String.self, forKey: .releasedAt)
        tcgPlayerId = try container.decodeIfPresent(Int64.self, forKey: .tcgPlayerId) ?? Int64(0)
        toughness = try container.decodeIfPresent(String.self, forKey: .toughness)
        typeLine = try container.decodeIfPresent(String.self, forKey: .typeLine)
        
        artist = try container.decodeIfPresent(MGArtist.self, forKey: .artist)
//        cardComponentParts = try container.decodeIfPresent(Set<MGCardComponentPart>.self, forKey: .cardComponentParts) as NSSet?
        if let colors = try container.decodeIfPresent(Set<MGColor>.self, forKey: .colors) as NSSet? {
            addToColors(colors)
        }
        if let colorIdentities = try container.decodeIfPresent(Set<MGColor>.self, forKey: .colorIdentities) as NSSet? {
            addToColorIdentities(colorIdentities)
        }
        if let colorIndicators = try container.decodeIfPresent(Set<MGColor>.self, forKey: .colorIndicators) as NSSet? {
            addToColorIndicators(colorIndicators)
        }
        if let faces = try container.decodeIfPresent(Set<MGCard>.self, forKey: .faces) as NSSet? {
            addToFaces(faces)
        }
        if let formatLegalities = try container.decodeIfPresent(Set<MGCardFormatLegality>.self, forKey: .formatLegalities) as NSSet? {
            addToFormatLegalities(formatLegalities)
        }
        frame = try container.decodeIfPresent(MGFrame.self, forKey: .frame)
        frameEffect = try container.decodeIfPresent(MGFrameEffect.self, forKey: .frameEffect)
        language = try container.decodeIfPresent(MGLanguage.self, forKey: .language)
        layout = try container.decodeIfPresent(MGLayout.self, forKey: .layout)
        if let otherLanguages = try container.decodeIfPresent(Set<MGCard>.self, forKey: .otherLanguages) as NSSet? {
            addToOtherLanguages(otherLanguages)
        }
        if let otherPrintings = try container.decodeIfPresent(Set<MGCard>.self, forKey: .otherPrintings) as NSSet? {
            addToOtherPrintings(otherPrintings)
        }
//        partComponentParts = try container.decodeIfPresent(Set<MGCard>.self, forKey: .partComponentParts) as NSSet?
        if let prices = try container.decodeIfPresent(Set<MGCardPrice>.self, forKey: .prices) as NSSet? {
            addToPrices(prices)
        }
        rarity = try container.decodeIfPresent(MGRarity.self, forKey: .rarity)
//        set = try container.decodeIfPresent(MGSet.self, forKey: .set)
        if let subtypes = try container.decodeIfPresent(Set<MGCardType>.self, forKey: .subtypes) as NSSet? {
            addToSubtypes(subtypes)
        }
        if let supertypes = try container.decodeIfPresent(Set<MGCardType>.self, forKey: .supertypes) as NSSet? {
            addToSupertypes(supertypes)
        }
        if let variations = try container.decodeIfPresent(Set<MGCard>.self, forKey: .variations) as NSSet? {
            addToVariations(variations)
        }
//        watermark = try container.decodeIfPresent(MGWatermark.self, forKey: .watermark)
    }
    
    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(arenaId, forKey: .arenaId)
        try container.encode(cardBackId, forKey: .cardBackId)
        try container.encode(cmc, forKey: .cmc)
        try container.encode(collectorNumber, forKey: .collectorNumber)
        try container.encode(faceOrder, forKey: .faceOrder)
        try container.encode(flavorText, forKey: .flavorText)
        try container.encode(handModifier, forKey: .handModifier)
        try container.encode(illustrationId, forKey: .illustrationId)
        if let imageUri = imageUri {
            var set = Set<MGImageURI>()
            set.insert(imageUri)
            try container.encode(set, forKey: .imageUris)
        }
        try container.encode(isBooster, forKey: .isBooster)
        try container.encode(isDigital, forKey: .isDigital)
        try container.encode(isFoil, forKey: .isFoil)
        try container.encode(isFullArt, forKey: .isFullArt)
        try container.encode(isHighResImage, forKey: .isHighResImage)
        try container.encode(isNonFoil, forKey: .isNonFoil)
        try container.encode(isOversized, forKey: .isOversized)
        try container.encode(isPromo, forKey: .isPromo)
        try container.encode(isReprint, forKey: .isReprint)
        try container.encode(isReserved, forKey: .isReserved)
        try container.encode(isStorySpotlight, forKey: .isStorySpotlight)
        try container.encode(isTextless, forKey: .isTextless)
        try container.encode(lifeModifier, forKey: .lifeModifier)
        try container.encode(loyalty, forKey: .loyalty)
        try container.encode(manaCost, forKey: .manaCost)
        try container.encode(mtgoFoilId, forKey: .mtgoFoilId)
        try container.encode(mtgoId, forKey: .mtgoId)
        if let multiverseIds = multiverseIds {
            try container.encode(multiverseIds, forKey: .multiverseIds)
        }
        try container.encode(myNameSection, forKey: .myNameSection)
        try container.encode(myNumberOrder, forKey: .myNumberOrder)
        try container.encode(name, forKey: .name)
        try container.encode(newId, forKey: .newId)
        try container.encode(oracleId, forKey: .oracleId)
        try container.encode(oracleText, forKey: .oracleText)
        try container.encode(power, forKey: .power)
        try container.encode(printedName, forKey: .printedName)
        try container.encode(printedText, forKey: .printedText)
        try container.encode(printedTypeLine, forKey: .printedTypeLine)
        try container.encode(releasedAt, forKey: .releasedAt)
        try container.encode(tcgPlayerId, forKey: .tcgPlayerId)
        try container.encode(toughness, forKey: .toughness)
        try container.encode(typeLine, forKey: .typeLine)
        if let artist = artist {
            try container.encode(artist, forKey: .artist)
        }
        if let cardComponentParts = cardComponentParts as? Set<MGCardComponentPart> {
            try container.encode(cardComponentParts, forKey: .cardComponentParts)
        }
        if let colorIdentities = colorIdentities as? Set<MGColor> {
            try container.encode(colorIdentities, forKey: .colorIdentities)
        }
        if let colorIndicators = colorIndicators as? Set<MGColor> {
            try container.encode(colorIndicators, forKey: .colorIndicators)
        }
        if let colors = colors as? Set<MGColor> {
            try container.encode(colors, forKey: .colors)
        }
        if let faces = faces as? Set<MGCard> {
            try container.encode(faces, forKey: .faces)
        }
        if let formatLegalities = formatLegalities as? Set<MGCardFormatLegality> {
            try container.encode(formatLegalities, forKey: .formatLegalities)
        }
        if let frame = frame {
            try container.encode(frame, forKey: .frame)
        }
        if let frameEffect = frameEffect {
            try container.encode(frameEffect, forKey: .frameEffect)
        }
        if let language = language {
            try container.encode(language, forKey: .language)
        }
        if let layout = layout {
            try container.encode(layout, forKey: .layout)
        }
        if let otherLanguages = otherLanguages as? Set<MGCard> {
            try container.encode(otherLanguages, forKey: .otherLanguages)
        }
        if let otherPrintings = otherPrintings as? Set<MGCard> {
            try container.encode(otherPrintings, forKey: .otherPrintings)
        }
        if let partComponentParts = partComponentParts as? Set<MGCard> {
            try container.encode(partComponentParts, forKey: .partComponentParts)
        }
        if let prices = prices as? Set<MGCardPrice> {
            try container.encode(prices, forKey: .prices)
        }
        if let rarity = rarity {
            try container.encode(rarity, forKey: .rarity)
        }
        if let set = set {
            try container.encode(set, forKey: .set)
        }
        if let subtypes = subtypes as? Set<MGCardType> {
            try container.encode(subtypes, forKey: .subtypes)
        }
        if let supertypes = supertypes as? Set<MGCardType> {
            try container.encode(supertypes, forKey: .supertypes)
        }
        if let variations = variations as? Set<MGCard> {
            try container.encode(variations, forKey: .variations)
        }
        if let watermark = watermark {
            try container.encode(watermark, forKey: .watermark)
        }
    }
}

