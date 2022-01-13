//
//  MGCard+CoreDataClass.swift
//  ManaKit
//
//  Created by Vito Royeca on 12/16/21.
//

import CoreData

// MARK: - Temporary structs

struct tempArtist: Decodable {
    let name: String
}

struct tempFrame: Decodable {
    let name: String
}

struct tempLanguage: Decodable {
    let name: String
    let code: String
}

struct tempLayout: Decodable {
    let name: String
}

struct tempRarity: Decodable {
    let name: String
    let nameSection: String
}

struct tempSet: Decodable {
    let code: String
    let name: String
    let keyruneClass: String
    let keyruneUnicode: String
}

struct tempWatermark: Decodable {
    let name: String
    let nameSection: String
}

// MARK: - MGCard
class MGCard: MGEntity {
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
             frameEffects,
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

    required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
          throw DecoderConfigurationError.missingManagedObjectContext
        }
        
        self.init(context: context)

        let container = try decoder.container(keyedBy: CodingKeys.self)
        try updateAttributes(container: container)
        try updateRelationships(container: container)
    }
    
    override func encode(to encoder: Encoder) throws {
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
        if let frameEffects = frameEffects as? Set<MGFrameEffect> {
            try container.encode(frameEffects, forKey: .frameEffects)
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
    
    func toModel() -> MCard {
        return MCard(arenaId: arenaId,
                     cardBackId: cardBackId,
                     cmc: cmc,
                     collectorNumber: collectorNumber,
                     faceOrder: faceOrder,
                     flavorText: flavorText,
                     handModifier: handModifier,
                     illustrationId: illustrationId,
                     isBooster: isBooster,
                     isDigital: isDigital,
                     isFoil: isFoil,
                     isFullArt: isFullArt,
                     isHighResImage: isHighResImage,
                     isNonFoil: isNonFoil,
                     isOversized: isOversized,
                     isPromo: isPromo,
                     isReprint: isReprint,
                     isReserved: isReserved,
                     isStorySpotlight: isStorySpotlight,
                     isTextless: isTextless,
                     lifeModifier: lifeModifier,
                     loyalty: loyalty,
                     manaCost: manaCost,
                     mtgoFoilId: mtgoFoilId,
                     mtgoId: mtgoId,
                     multiverseIds: multiverseIds,
                     myNameSection: myNameSection,
                     myNumberOrder: myNumberOrder,
                     name: name,
                     newId: newId,
                     oracleId: oracleId,
                     oracleText: oracleText,
                     power: power,
                     printedName: printedName,
                     printedText: printedText,
                     printedTypeLine: printedTypeLine,
                     releasedAt: releasedAt,
                     tcgPlayerId: tcgPlayerId,
                     toughness: toughness,
                     typeLine: typeLine,
                     artist: artist?.toModel(),
                     cardComponentParts: (cardComponentParts?.allObjects as? [MGCardComponentPart] ?? []).map { $0.toModel() },
                     colorIdentities: (colorIdentities?.allObjects as? [MGColor] ?? []).map { $0.toModel() },
                     colorIndicators: (colorIndicators?.allObjects as? [MGColor] ?? []).map { $0.toModel() },
                     colors: (colors?.allObjects as? [MGColor] ?? [MGColor]()).map { $0.toModel() },
                     faces: (faces?.allObjects as? [MGCard] ?? [MGCard]()).map { $0.toModel() },
                     formatLegalities: (formatLegalities?.allObjects as? [MGCardFormatLegality] ?? []).map { $0.toModel() },
                     frame: frame?.toModel(),
                     frameEffects: (frameEffects?.allObjects as? [MGFrameEffect] ?? []).map { $0.toModel() },
                     imageUri: imageUri?.toModel(),
                     language: language?.toModel(),
                     layout: layout?.toModel(),
                     otherLanguages: (otherLanguages?.allObjects as? [MGLanguage] ?? [MGLanguage]()).map { $0.toModel() },
                     otherPrintings: (otherPrintings?.allObjects as? [MGCard] ?? [MGCard]()).map { $0.toModel() },
                     partComponentParts: (partComponentParts?.allObjects as? [MGCardComponentPart] ?? [MGCardComponentPart]()).map { $0.toModel() },
                     prices: (prices?.allObjects as? [MGCardPrice] ?? [MGCardPrice]()).map { $0.toModel() },
                     rarity: rarity?.toModel(),
                     set: set?.toModel(),
                     subtypes: (subtypes?.allObjects as? [MGCardType] ?? [MGCardType]()).map { $0.toModel() },
                     supertypes: (subtypes?.allObjects as? [MGCardType] ?? [MGCardType]()).map { $0.toModel() },
                     variations: (variations?.allObjects as? [MGCard] ?? [MGCard]()).map { $0.toModel() },
                     watermark: watermark?.toModel())
    }
    
    // MARK: - Attributes
    
    func updateAttributes(container: KeyedDecodingContainer<CodingKeys>) throws {
        // arenaId
        if let arenaId = try container.decodeIfPresent(String.self, forKey: .arenaId),
           self.arenaId != arenaId {
            self.arenaId = arenaId
        }
        
        // cardBackId
        if let cardBackId = try container.decodeIfPresent(String.self, forKey: .cardBackId),
           self.cardBackId != cardBackId {
            self.cardBackId = cardBackId
        }
        
        // cmc
        if let cmc = try container.decodeIfPresent(Double.self, forKey: .cmc),
           self.cmc != cmc {
            self.cmc = cmc
        }
        
        // collectorNumber
        if let collectorNumber = try container.decodeIfPresent(String.self, forKey: .collectorNumber),
           self.collectorNumber != collectorNumber {
            self.collectorNumber = collectorNumber
        }
        
        // faceOrder
        if let faceOrder = try container.decodeIfPresent(Int32.self, forKey: .faceOrder),
           self.faceOrder != faceOrder {
            self.faceOrder = faceOrder
        }
        
        // flavorText
        if let flavorText = try container.decodeIfPresent(String.self, forKey: .flavorText),
           self.flavorText != flavorText {
            self.flavorText = flavorText
        }
        
        // handModifier
        if let handModifier = try container.decodeIfPresent(String.self, forKey: .handModifier),
           self.handModifier != handModifier {
            self.handModifier = handModifier
        }
        
        // illustrationId
        if let illustrationId = try container.decodeIfPresent(String.self, forKey: .illustrationId),
           self.illustrationId != illustrationId {
            self.illustrationId = illustrationId
        }
        
        // imageUri
        if let array = try container.decodeIfPresent([MGImageURI].self, forKey: .imageUris),
           let imageUri = array.first,
           self.imageUri != imageUri {
            self.imageUri = imageUri
        }
        
        // isBooster
        if let isBooster = try container.decodeIfPresent(Bool.self, forKey: .isBooster),
           self.isBooster != isBooster {
            self.isBooster = isBooster
        }
        
        // isDigital
        if let isDigital = try container.decodeIfPresent(Bool.self, forKey: .isDigital),
           self.isDigital != isDigital {
            self.isDigital = isDigital
        }
        
        // is Foil
        if let isFoil = try container.decodeIfPresent(Bool.self, forKey: .isFoil),
           self.isFoil != isFoil {
            self.isFoil = isFoil
        }
        
        // isFullArt
        if let isFullArt = try container.decodeIfPresent(Bool.self, forKey: .isFullArt),
           self.isFullArt != isFullArt {
            self.isFullArt = isFullArt
        }
        
        // isHighResImage
        if let isHighResImage = try container.decodeIfPresent(Bool.self, forKey: .isHighResImage),
           self.isHighResImage != isHighResImage {
            self.isHighResImage = isHighResImage
        }
        
        // isNonFoil
        if let isNonFoil = try container.decodeIfPresent(Bool.self, forKey: .isNonFoil),
           self.isNonFoil != isNonFoil {
            self.isNonFoil = isNonFoil
        }
        
        // isOversized
        if let isOversized = try container.decodeIfPresent(Bool.self, forKey: .isOversized),
           self.isOversized != isOversized {
            self.isOversized = isOversized
        }
        
        // isPromo
        if let isPromo = try container.decodeIfPresent(Bool.self, forKey: .isPromo),
           self.isPromo != isPromo {
            self.isPromo = isPromo
        }
        
        // isReprint
        if let isReprint = try container.decodeIfPresent(Bool.self, forKey: .isReprint),
           self.isReprint != isReprint {
            self.isReprint = isReprint
        }
        
        // isReserved
        if let isReserved = try container.decodeIfPresent(Bool.self, forKey: .isReserved),
           self.isReserved != isReserved {
            self.isReserved = isReserved
        }
        
        // isStorySpotlight
        if let isStorySpotlight = try container.decodeIfPresent(Bool.self, forKey: .isStorySpotlight),
           self.isStorySpotlight != isStorySpotlight {
            self.isStorySpotlight = isStorySpotlight
        }
        
        // isTextless
        if let isTextless = try container.decodeIfPresent(Bool.self, forKey: .isTextless),
           self.isTextless != isTextless {
            self.isTextless = isTextless
        }
        
        // lifeModifier
        if let lifeModifier = try container.decodeIfPresent(String.self, forKey: .lifeModifier),
            self.lifeModifier != lifeModifier {
            self.lifeModifier = lifeModifier
        }
        
        // loyalty
        if let loyalty = try container.decodeIfPresent(String.self, forKey: .loyalty),
           self.loyalty != loyalty {
            self.loyalty = loyalty
        }
        
        // manaCost
        if let manaCost = try container.decodeIfPresent(String.self, forKey: .manaCost),
           self.manaCost != manaCost {
            self.manaCost = manaCost
        }
        
        // mtgoFoilId
        if let mtgoFoilId = try container.decodeIfPresent(String.self, forKey: .mtgoFoilId),
           self.mtgoFoilId != mtgoFoilId {
            self.mtgoFoilId = mtgoFoilId
        }
        
        // mtgoId
        if let mtgoId = try container.decodeIfPresent(String.self, forKey: .mtgoId),
           self.mtgoId != mtgoId {
            self.mtgoId = mtgoId
        }
        
        // multiverseIds
        if let array = try container.decodeIfPresent([Int64].self, forKey: .multiverseIds),
           !array.isEmpty {
            multiverseIds = try NSKeyedArchiver.archivedData(withRootObject: array, requiringSecureCoding: false)
        }
        
        // myNameSection
        if let myNameSection = try container.decodeIfPresent(String.self, forKey: .myNameSection),
           self.myNameSection != myNameSection {
            self.myNameSection = myNameSection
        }
        
        // myNumberOrder
        if let myNumberOrder = try container.decodeIfPresent(Double.self, forKey: .myNumberOrder),
           self.myNumberOrder != myNumberOrder {
            self.myNumberOrder = myNumberOrder
        }
        
        // name
        if let name = try container.decodeIfPresent(String.self, forKey: .name),
           self.name != name {
            self.name = name
        }
        
        // newId
        if let newId = try container.decodeIfPresent(String.self, forKey: .newId),
           self.newId != newId {
            self.newId = newId
        }
        
        // oracleId
        if let oracleId = try container.decodeIfPresent(String.self, forKey: .oracleId),
           self.oracleId != oracleId {
            self.oracleId = oracleId
        }
        
        // oracleText
        if let oracleText = try container.decodeIfPresent(String.self, forKey: .oracleText),
           self.oracleText != oracleText {
            self.oracleText = oracleText
        }
        
        // power
        if let power = try container.decodeIfPresent(String.self, forKey: .power),
           self.power != power {
            self.power = power
        }
        
        // printedName
        if let printedName = try container.decodeIfPresent(String.self, forKey: .printedName),
           self.printedName != printedName {
            self.printedName = printedName
        }
        
        // printedText
        if let printedText = try container.decodeIfPresent(String.self, forKey: .printedText),
           self.printedText != printedText {
            self.printedText = printedText
        }
        
        // printedTypeLine
        if let printedTypeLine = try container.decodeIfPresent(String.self, forKey: .printedTypeLine),
           self.printedTypeLine != printedTypeLine {
            self.printedTypeLine = printedTypeLine
        }
        
        // releasedAt
        if let releasedAt = try container.decodeIfPresent(String.self, forKey: .releasedAt),
           self.releasedAt != releasedAt {
            self.releasedAt = releasedAt
        }
        
        // tcgPlayerId
        if let tcgPlayerId = try container.decodeIfPresent(Int64.self, forKey: .tcgPlayerId),
           self.tcgPlayerId != tcgPlayerId {
            self.tcgPlayerId = tcgPlayerId
        }
        
        // toughness
        if let toughness = try container.decodeIfPresent(String.self, forKey: .toughness),
           self.toughness != toughness {
            self.toughness = toughness
        }
        
        // typeline
        if let typeLine = try container.decodeIfPresent(String.self, forKey: .typeLine),
           self.typeLine != typeLine {
            self.typeLine = typeLine
        }
    }

    // MARK: - Relationships
    
    func updateRelationships(container: KeyedDecodingContainer<CodingKeys>) throws {
        // artist
        if let artist = try container.decodeIfPresent(MGArtist.self, forKey: .artist) {
            self.artist = artist
        }
//        try updateArtist(container: container)

        // cardComponentParts
//        cardComponentParts = try container.decodeIfPresent(Set<MGCardComponentPart>.self, forKey: .cardComponentParts) as NSSet?
        
        // colors
        if let colors = try container.decodeIfPresent(Set<MGColor>.self, forKey: .colors) {
            for color in self.colors?.allObjects as? [MGColor] ?? [] {
                self.removeFromColors(color)
            }
            
            colors.forEach {
                $0.addToCards(self)
            }
            addToColors(colors as NSSet)
        }
        
        // colorIdentities
        if let colorIdentities = try container.decodeIfPresent(Set<MGColor>.self, forKey: .colorIdentities) {
            for color in self.colorIdentities?.allObjects as? [MGColor] ?? [] {
                self.removeFromColorIdentities(color)
            }

            colorIdentities.forEach {
                $0.addToCards(self)
            }
            addToColorIdentities(colorIdentities as NSSet)
        }
        
        // colorIndicators
        if let colorIndicators = try container.decodeIfPresent(Set<MGColor>.self, forKey: .colorIndicators) {
            for color in self.colorIndicators?.allObjects as? [MGColor] ?? [] {
                self.removeFromColorIndicators(color)
            }

            colorIndicators.forEach {
                $0.addToCards(self)
            }
            addToColorIndicators(colorIndicators as NSSet)
        }

        // faces
//        if let faces = try container.decodeIfPresent(Set<MGCard>.self, forKey: .faces) {
//            for face in self.faces?.allObjects as? [MGCard] ?? [] {
//                self.removeFromFaces(face)
//            }
//
//            faces.forEach {
//                $0.face = self
//            }
//            addToFaces(faces as NSSet)
//        }
        
        // formatLegalities
//        if let formatLegalities = try container.decodeIfPresent(Set<MGCardFormatLegality>.self, forKey: .formatLegalities) {
//            for formatLegality in self.formatLegalities?.allObjects as? [MGCardFormatLegality] ?? [] {
//                self.removeFromFormatLegalities(formatLegality)
//            }
//
//            formatLegalities.forEach {
//                $0.card = self
//            }
//            addToFormatLegalities(formatLegalities as NSSet)
//        }
        
        // frame
        if let frame = try container.decodeIfPresent(MGFrame.self, forKey: .frame) {
            self.frame = frame
        }
//        try updateFrame(container: container)
        
        // frameEffect
        if let frameEffects = try container.decodeIfPresent(Set<MGFrameEffect>.self, forKey: .frameEffects) {
            for frameEffect in self.frameEffects?.allObjects as? [MGFrameEffect] ?? [] {
                self.removeFromFrameEffects(frameEffect)
            }
            addToFrameEffects(frameEffects as NSSet)
        }
        
        // language
        if let language = try container.decodeIfPresent(MGLanguage.self, forKey: .language) {
            self.language = language
        }
//        try updateLanguage(container: container)
        
        // layout
        if let layout = try container.decodeIfPresent(MGLayout.self, forKey: .layout) {
            self.layout = layout
        }
//        try updateLayout(container: container)

        // otherLanguages
//        if let otherLanguages = try container.decodeIfPresent(Set<MGCard>.self, forKey: .otherLanguages)  {
//            for otherLanguage in self.otherLanguages?.allObjects as? [MGCard] ?? [] {
//                self.removeFromOtherLanguages(otherLanguage)
//            }
//            addToOtherLanguages(otherLanguages as NSSet)
//        }
        
        // otherPrintings
        if let otherPrintings = try container.decodeIfPresent(Set<MGCard>.self, forKey: .otherPrintings) {
            for otherPrinting in self.otherPrintings?.allObjects as? [MGCard] ?? [] {
                self.removeFromOtherPrintings(otherPrinting)
            }

//            otherPrintings.forEach {
//                $0.otherPrinting = self
//            }
            addToOtherPrintings(otherPrintings as NSSet)
        }
        
        // partComponentParts
//        partComponentParts = try container.decodeIfPresent(Set<MGCard>.self, forKey: .partComponentParts) as NSSet?
        
        // prices
        if let prices = try container.decodeIfPresent(Set<MGCardPrice>.self, forKey: .prices) {
            for price in self.prices?.allObjects as? [MGCardPrice] ?? [] {
                self.removeFromPrices(price)
            }
            
            prices.forEach {
                $0.card = self
            }
            addToPrices(prices as NSSet)
        }
        
        // rarity
        if let rarity = try container.decodeIfPresent(MGRarity.self, forKey: .rarity) {
            self.rarity = rarity
        }
//        try updateRarity(container: container)

        // set
        if let set = try container.decodeIfPresent(MGSet.self, forKey: .set) {
            self.set = set
        }
//        try self.updateSet(container: container)

        // subtypes
        if let subtypes = try container.decodeIfPresent(Set<MGCardType>.self, forKey: .subtypes) {
            for subtype in self.subtypes?.allObjects as? [MGCardType] ?? [] {
                self.removeFromSubtypes(subtype)
            }
            addToSubtypes(subtypes as NSSet)
        }

        // supertypes
        if let supertypes = try container.decodeIfPresent(Set<MGCardType>.self, forKey: .supertypes) {
            for supertype in self.supertypes?.allObjects as? [MGCardType] ?? [] {
                self.removeFromSupertypes(supertype)
            }
            addToSupertypes(supertypes as NSSet)
        }
        
        // variations
//        if let variations = try container.decodeIfPresent(Set<MGCard>.self, forKey: .variations) {
//            for variation in self.variations?.allObjects as? [MGCard] ?? [] {
//                self.removeFromVariations(variation)
//            }
//
//            variations.forEach {
//                $0.variation = self
//            }
//            addToVariations(variations as NSSet)
//        }

        // watermark
        if let watermark = try container.decodeIfPresent(MGWatermark.self, forKey: .watermark) {
            self.watermark = watermark
        }
//        try updateWatermark(container: container)
 
    }
    
    func updateArtist(container: KeyedDecodingContainer<CodingKeys>) throws {
        guard let tempArtist = try container.decodeIfPresent(tempArtist.self, forKey: .artist) else {
            return
        }
        
        if let artist = ManaKit.shared.find(MGArtist.self,
                                            properties: ["name": tempArtist.name],
                                            predicate: NSPredicate(format: "name == %@", tempArtist.name),
                                            sortDescriptors: nil,
                                            createIfNotFound: true)?.first {
            self.artist = artist
        }
    }
    
    func updateFrame(container: KeyedDecodingContainer<CodingKeys>) throws {
        guard let tempFrame = try container.decodeIfPresent(tempFrame.self, forKey: .frame) else {
            return
        }
        
        if let frame = ManaKit.shared.find(MGFrame.self,
                                           properties: ["name": tempFrame.name],
                                           predicate: NSPredicate(format: "name == %@", tempFrame.name),
                                           sortDescriptors: nil,
                                           createIfNotFound: true)?.first {
            self.frame = frame
        }
    }
    
    func updateLanguage(container: KeyedDecodingContainer<CodingKeys>) throws {
        guard let tempLanguage = try container.decodeIfPresent(tempLanguage.self, forKey: .language) else {
            return
        }
        
        if let language = ManaKit.shared.find(MGLanguage.self,
                                              properties: ["name": tempLanguage.name,
                                                           "code": tempLanguage.code],
                                              predicate: NSPredicate(format: "name == %@ AND code == %@", tempLanguage.name, tempLanguage.code),
                                              sortDescriptors: nil,
                                              createIfNotFound: true)?.first {
            self.language = language
        }
    }
    
    func updateLayout(container: KeyedDecodingContainer<CodingKeys>) throws {
        guard let tempLayout = try container.decodeIfPresent(tempLayout.self, forKey: .layout) else {
            return
        }
        
        if let layout = ManaKit.shared.find(MGLayout.self,
                                            properties: ["name": tempLayout.name],
                                            predicate: NSPredicate(format: "name == %@", tempLayout.name),
                                            sortDescriptors: nil,
                                            createIfNotFound: true)?.first {
            self.layout = layout
        }
    }
    
    func updateRarity(container: KeyedDecodingContainer<CodingKeys>) throws {
        guard let tempRarity = try container.decodeIfPresent(tempRarity.self, forKey: .rarity) else {
            return
        }
        
        if let rarity = ManaKit.shared.find(MGRarity.self,
                                            properties: ["name": tempRarity.name,
                                                         "nameSection": tempRarity.nameSection],
                                            predicate: NSPredicate(format: "name == %@", tempRarity.name),
                                            sortDescriptors: nil,
                                            createIfNotFound: true)?.first {
            self.rarity = rarity
        }
    }
    
    func updateSet(container: KeyedDecodingContainer<CodingKeys>) throws {
        guard let tempSet = try container.decodeIfPresent(tempSet.self, forKey: .set) else {
            return
        }

        if let set = ManaKit.shared.find(MGSet.self,
                                         properties: ["code": tempSet.code,
                                                      "name": tempSet.name,
                                                      "keyruneClass": tempSet.keyruneClass,
                                                      "keyruneUnicode": tempSet.keyruneUnicode],
                                         predicate: NSPredicate(format: "code == %@", tempSet.code),
                                         sortDescriptors: nil,
                                         createIfNotFound: true)?.first {
            self.set = set
        }
    }
    
    func updateWatermark(container: KeyedDecodingContainer<CodingKeys>) throws {
        guard let tempWatermark = try container.decodeIfPresent(tempWatermark.self, forKey: .watermark) else {
            return
        }
        
        if let watermark = ManaKit.shared.find(MGWatermark.self,
                                               properties: ["name": tempWatermark.name,
                                                            "nameSection": tempWatermark.nameSection],
                                               predicate: NSPredicate(format: "name == %@", tempWatermark.name),
                                               sortDescriptors: nil,
                                               createIfNotFound: true)?.first {
            self.watermark = watermark
        }
    }
}
