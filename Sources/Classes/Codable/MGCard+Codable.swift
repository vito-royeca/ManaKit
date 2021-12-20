//
//  MGCard+Codable.swift
//  ManaKit
//
//  Created by Vito Royeca on 12/16/21.
//

import CoreData

public class MGCard: NSManagedObject, Codable {
    enum CodingKeys: CodingKey {
        case arenaId,
             cardBackId,
             cmc,
             collectorNumber,
             faceOrder,
             flavorText,
             handModifier,
             id,
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
        
        arenaId = try container.decode(String.self, forKey: .arenaId)
        cardBackId = try container.decode(String.self, forKey: .cardBackId)
        cmc = try container.decode(Double.self, forKey: .cmc)
        collectorNumber = try container.decode(String.self, forKey: .collectorNumber)
        faceOrder = try container.decode(Int32.self, forKey: .faceOrder)
        flavorText = try container.decode(String.self, forKey: .flavorText)
        handModifier = try container.decode(String.self, forKey: .handModifier)
        id = try container.decode(String.self, forKey: .id)
        illustrationId = try container.decode(String.self, forKey: .illustrationId)
        imageUris = try container.decode(Data.self, forKey: .imageUris)
        isBooster = try container.decode(Bool.self, forKey: .isBooster)
        isDigital = try container.decode(Bool.self, forKey: .isDigital)
        isFoil = try container.decode(Bool.self, forKey: .isFoil)
        isFullArt = try container.decode(Bool.self, forKey: .isFullArt)
        isHighResImage = try container.decode(Bool.self, forKey: .isHighResImage)
        isNonFoil = try container.decode(Bool.self, forKey: .isNonFoil)
        isOversized = try container.decode(Bool.self, forKey: .isOversized)
        isPromo = try container.decode(Bool.self, forKey: .isPromo)
        isReprint = try container.decode(Bool.self, forKey: .isReprint)
        isReserved = try container.decode(Bool.self, forKey: .isReserved)
        isStorySpotlight = try container.decode(Bool.self, forKey: .isStorySpotlight)
        isTextless = try container.decode(Bool.self, forKey: .isTextless)
        lifeModifier = try container.decode(String.self, forKey: .lifeModifier)
        loyalty = try container.decode(String.self, forKey: .loyalty)
        manaCost = try container.decode(String.self, forKey: .manaCost)
        mtgoFoilId = try container.decode(String.self, forKey: .mtgoFoilId)
        mtgoId = try container.decode(String.self, forKey: .mtgoId)
        multiverseIds = try container.decode(Data.self, forKey: .multiverseIds)
        myNameSection = try container.decode(String.self, forKey: .myNameSection)
        myNumberOrder = try container.decode(Double.self, forKey: .myNumberOrder)
        name = try container.decode(String.self, forKey: .name)
        oracleId = try container.decode(String.self, forKey: .oracleId)
        oracleText = try container.decode(String.self, forKey: .oracleText)
        power = try container.decode(String.self, forKey: .power)
        printedName = try container.decode(String.self, forKey: .printedName)
        printedText = try container.decode(String.self, forKey: .printedText)
        printedTypeLine = try container.decode(String.self, forKey: .printedTypeLine)
        releasedAt = try container.decode(String.self, forKey: .releasedAt)
        tcgPlayerId = try container.decode(Int32.self, forKey: .tcgPlayerId)
        toughness = try container.decode(String.self, forKey: .toughness)
        typeLine = try container.decode(String.self, forKey: .typeLine)
        artist = try container.decode(MGArtist.self, forKey: .artist)
        cardComponentParts = try container.decode(Set<MGCardComponentPart>.self, forKey: .cardComponentParts) as NSSet
        colorIdentities = try container.decode(Set<MGColor>.self, forKey: .colorIdentities) as NSSet
        colorIndicators = try container.decode(Set<MGColor>.self, forKey: .colorIndicators) as NSSet
        colors = try container.decode(Set<MGColor>.self, forKey: .colors) as NSSet
        faces = try container.decode(Set<MGCard>.self, forKey: .faces) as NSSet
        formatLegalities = try container.decode(Set<MGCardFormatLegality>.self, forKey: .formatLegalities) as NSSet
        frame = try container.decode(MGFrame.self, forKey: .frame)
        frameEffect = try container.decode(MGFrameEffect.self, forKey: .frameEffect)
        language = try container.decode(MGLanguage.self, forKey: .language)
        layout = try container.decode(MGLayout.self, forKey: .layout)
        otherLanguages = try container.decode(Set<MGCard>.self, forKey: .otherLanguages) as NSSet
        otherPrintings = try container.decode(Set<MGCard>.self, forKey: .otherPrintings) as NSSet
        partComponentParts = try container.decode(Set<MGCard>.self, forKey: .partComponentParts) as NSSet
        prices = try container.decode(Set<MGCardPrice>.self, forKey: .prices) as NSSet
        rarity = try container.decode(MGRarity.self, forKey: .rarity)
        set = try container.decode(MGSet.self, forKey: .set)
        subtypes = try container.decode(Set<MGCardType>.self, forKey: .subtypes) as NSSet
        supertypes = try container.decode(Set<MGCardType>.self, forKey: .supertypes) as NSSet
        variations = try container.decode(Set<MGCard>.self, forKey: .variations) as NSSet
        watermark = try container.decode(MGWatermark.self, forKey: .watermark)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(arenaId, forKey: .arenaId)
        try container.encode(cardBackId, forKey: .cardBackId)
        try container.encode(cmc, forKey: .cmc)
        try container.encode(collectorNumber, forKey: .collectorNumber)
        try container.encode(faceOrder, forKey: .faceOrder)
        try container.encode(flavorText, forKey: .flavorText)
        try container.encode(handModifier, forKey: .handModifier)
        try container.encode(id, forKey: .id)
        try container.encode(illustrationId, forKey: .illustrationId)
        try container.encode(imageUris, forKey: .imageUris)
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
        try container.encode(multiverseIds, forKey: .multiverseIds)
        try container.encode(myNameSection, forKey: .myNameSection)
        try container.encode(myNumberOrder, forKey: .myNumberOrder)
        try container.encode(name, forKey: .name)
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
        try container.encode(cardComponentParts as! Set<MGCardComponentPart>, forKey: .cardComponentParts)
        try container.encode(colorIdentities as! Set<MGColor>, forKey: .colorIdentities)
        try container.encode(colorIndicators as! Set<MGColor>, forKey: .colorIndicators)
        try container.encode(colors as! Set<MGColor>, forKey: .colors)
        try container.encode(faces as! Set<MGCard>, forKey: .faces)
        try container.encode(formatLegalities as! Set<MGCardFormatLegality>, forKey: .formatLegalities)
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
        try container.encode(otherLanguages as! Set<MGCard>, forKey: .otherLanguages)
        try container.encode(otherPrintings as! Set<MGCard>, forKey: .otherPrintings)
        try container.encode(partComponentParts as! Set<MGCard>, forKey: .partComponentParts)
        try container.encode(prices as! Set<MGCardPrice>, forKey: .prices)
        if let rarity = rarity {
            try container.encode(rarity, forKey: .rarity)
        }
        if let set = set {
            try container.encode(set, forKey: .set)
        }
        try container.encode(subtypes as! Set<MGCardType>, forKey: .subtypes)
        try container.encode(supertypes as! Set<MGCardType>, forKey: .supertypes)
        try container.encode(variations as! Set<MGCard>, forKey: .variations)
        if let watermark = watermark {
            try container.encode(watermark, forKey: .watermark)
        }
    }
}
