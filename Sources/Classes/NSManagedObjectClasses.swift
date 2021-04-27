//
//  NSManagedObjectClasses.swift
//  ManaKit
//
//  Created by Vito Royeca on 12/20/20.
//

import CoreData

extension CodingUserInfoKey {
  static let managedObjectContext = CodingUserInfoKey(rawValue: "managedObjectContext")!
}

// MARK: - MGArtist

public class MGArtist: NSManagedObject, Codable {
    enum CodingKeys: CodingKey {
      case firstName,
           lastName,
           name,
           nameSection,
           cards
    }

    required convenience public init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
          throw ManaKitError.missingManagedObjectContext
        }

        self.init(context: context)

        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.firstName = try container.decode(String.self, forKey: .firstName)
        self.lastName = try container.decode(String.self, forKey: .lastName)
        self.cards = try container.decode(Set<MGCard>.self, forKey: .cards) as NSSet
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(firstName, forKey: .firstName)
        try container.encode(lastName, forKey: .lastName)
        try container.encode(name, forKey: .name)
        try container.encode(nameSection, forKey: .nameSection)
        try container.encode(cards as! Set<MGCard>, forKey: .cards)
    }
}

// MARK: - MGCard

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
        // relations
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

    required convenience public init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
          throw ManaKitError.missingManagedObjectContext
        }

        self.init(context: context)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.arenaId = try container.decode(String.self, forKey: .arenaId)
        self.cardBackId = try container.decode(String.self, forKey: .cardBackId)
        self.cmc = try container.decode(Double.self, forKey: .cmc)
        self.collectorNumber = try container.decode(String.self, forKey: .collectorNumber)
        self.faceOrder = try container.decode(Int32.self, forKey: .faceOrder)
        self.flavorText = try container.decode(String.self, forKey: .flavorText)
        self.handModifier = try container.decode(String.self, forKey: .handModifier)
        self.id = try container.decode(String.self, forKey: .id)
        self.illustrationId = try container.decode(String.self, forKey: .illustrationId)
        self.imageUris = try container.decode(Data.self, forKey: .imageUris)
        self.isBooster = try container.decode(Bool.self, forKey: .isBooster)
        self.isDigital = try container.decode(Bool.self, forKey: .isDigital)
        self.isFoil = try container.decode(Bool.self, forKey: .isFoil)
        self.isFullArt = try container.decode(Bool.self, forKey: .isFullArt)
        self.isHighResImage = try container.decode(Bool.self, forKey: .isHighResImage)
        self.isNonFoil = try container.decode(Bool.self, forKey: .isNonFoil)
        self.isOversized = try container.decode(Bool.self, forKey: .isOversized)
        self.isPromo = try container.decode(Bool.self, forKey: .isPromo)
        self.isReprint = try container.decode(Bool.self, forKey: .isReprint)
        self.isReserved = try container.decode(Bool.self, forKey: .isReserved)
        self.isStorySpotlight = try container.decode(Bool.self, forKey: .isStorySpotlight)
        self.isTextless = try container.decode(Bool.self, forKey: .isTextless)
        self.lifeModifier = try container.decode(String.self, forKey: .lifeModifier)
        self.loyalty = try container.decode(String.self, forKey: .loyalty)
        self.manaCost = try container.decode(String.self, forKey: .manaCost)
        self.mtgoFoilId = try container.decode(String.self, forKey: .mtgoFoilId)
        self.mtgoId = try container.decode(String.self, forKey: .mtgoId)
        self.multiverseIds = try container.decode(Data.self, forKey: .multiverseIds)
        self.myNameSection = try container.decode(String.self, forKey: .myNameSection)
        self.myNumberOrder = try container.decode(Double.self, forKey: .myNumberOrder)
        self.name = try container.decode(String.self, forKey: .name)
        self.oracleId = try container.decode(String.self, forKey: .oracleId)
        self.oracleText = try container.decode(String.self, forKey: .oracleText)
        self.power = try container.decode(String.self, forKey: .power)
        self.printedName = try container.decode(String.self, forKey: .printedName)
        self.printedText = try container.decode(String.self, forKey: .printedText)
        self.printedTypeLine = try container.decode(String.self, forKey: .printedTypeLine)
        self.releasedAt = try container.decode(String.self, forKey: .releasedAt)
        self.tcgPlayerId = try container.decode(Int32.self, forKey: .tcgPlayerId)
        self.toughness = try container.decode(String.self, forKey: .toughness)
        self.typeLine = try container.decode(String.self, forKey: .typeLine)
        self.artist = try container.decode(MGArtist.self, forKey: .artist)
        self.cardComponentParts = try container.decode(Set<MGCardComponentPart>.self, forKey: .cardComponentParts) as NSSet
        self.colorIdentities = try container.decode(Set<MGColor>.self, forKey: .colorIdentities) as NSSet
        self.colorIndicators = try container.decode(Set<MGColor>.self, forKey: .colorIndicators) as NSSet
        self.colors = try container.decode(Set<MGColor>.self, forKey: .colors) as NSSet
        self.faces = try container.decode(Set<MGCard>.self, forKey: .faces) as NSSet
        self.formatLegalities = try container.decode(Set<MGCardFormatLegality>.self, forKey: .formatLegalities) as NSSet
        self.frame = try container.decode(MGFrame.self, forKey: .frame)
        self.frameEffect = try container.decode(MGFrameEffect.self, forKey: .frameEffect)
        self.language = try container.decode(MGLanguage.self, forKey: .language)
        self.layout = try container.decode(MGLayout.self, forKey: .layout)
        self.otherLanguages = try container.decode(Set<MGCard>.self, forKey: .otherLanguages) as NSSet
        self.otherPrintings = try container.decode(Set<MGCard>.self, forKey: .otherPrintings) as NSSet
        self.partComponentParts = try container.decode(Set<MGCardComponentPart>.self, forKey: .partComponentParts) as NSSet
        self.prices = try container.decode(Set<MGCardPrice>.self, forKey: .prices) as NSSet
        self.rarity = try container.decode(MGRarity.self, forKey: .rarity)
        self.set = try container.decode(MGSet.self, forKey: .set)
        self.subtypes = try container.decode(Set<MGCardType>.self, forKey: .subtypes) as NSSet
        self.supertypes = try container.decode(Set<MGCardType>.self, forKey: .supertypes) as NSSet
        self.variations = try container.decode(Set<MGCard>.self, forKey: .variations) as NSSet
        self.watermark = try container.decode(MGWatermark.self, forKey: .watermark)
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
        try container.encode(artist, forKey: .artist)
        try container.encode(cardComponentParts as! Set<MGCardComponentPart>, forKey: .cardComponentParts)
        try container.encode(colorIdentities as! Set<MGColor>, forKey: .colorIdentities)
        try container.encode(colorIndicators as! Set<MGColor>, forKey: .colorIndicators)
        try container.encode(colors as! Set<MGColor>, forKey: .colors)
        try container.encode(faces as! Set<MGCard>, forKey: .faces)
        try container.encode(formatLegalities as! Set<MGCardFormatLegality>, forKey: .formatLegalities)
        try container.encode(frame, forKey: .frame)
        try container.encode(frameEffect, forKey: .frameEffect)
        try container.encode(language, forKey: .language)
        try container.encode(layout, forKey: .layout)
        try container.encode(otherLanguages as! Set<MGCard>, forKey: .otherLanguages)
        try container.encode(otherPrintings as! Set<MGCard>, forKey: .otherPrintings)
        try container.encode(partComponentParts as! Set<MGCardComponentPart>, forKey: .partComponentParts)
        try container.encode(prices as! Set<MGCardPrice>, forKey: .prices)
        try container.encode(rarity, forKey: .rarity)
        try container.encode(set, forKey: .set)
        try container.encode(subtypes as! Set<MGCardType>, forKey: .subtypes)
        try container.encode(supertypes as! Set<MGCardType>, forKey: .supertypes)
        try container.encode(variations as! Set<MGCard>, forKey: .variations)
        try container.encode(watermark, forKey: .watermark)
    }
}

// MARK: - MGCardComponentPart

public class MGCardComponentPart: NSManagedObject, Codable {
    enum CodingKeys: CodingKey {
      case id,
           card,
           part,
           component
    }

    required convenience public init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
          throw ManaKitError.missingManagedObjectContext
        }

        self.init(context: context)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int32.self, forKey: .id)
        self.card = try container.decode(MGCard.self, forKey: .card)
        self.part = try container.decode(MGCard.self, forKey: .part)
        self.component = try container.decode(MGComponent.self, forKey: .component)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(card, forKey: .card)
        try container.encode(part, forKey: .part)
        try container.encode(component, forKey: .component)
    }
}

// MARK: - MGCArdFormatLegality

public class MGCardFormatLegality: NSManagedObject, Codable {
    enum CodingKeys: CodingKey {
        case id, card, format, legality
    }

    required convenience public init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
          throw ManaKitError.missingManagedObjectContext
        }

        self.init(context: context)

        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int32.self, forKey: .id)
        self.card = try container.decode(MGCard.self, forKey: .card)
        self.format = try container.decode(MGFormat.self, forKey: .format)
        self.legality = try container.decode(MGLegality.self, forKey: .legality)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(card, forKey: .card)
        try container.encode(format, forKey: .format)
        try container.encode(legality, forKey: .legality)
    }
}

// MARK: - MGCardPrice

public class MGCardPrice: NSManagedObject, Codable {
    enum CodingKeys: CodingKey {
      case condition,
           dateUpdated,
           directLow,
           high,
           id,
           isFoil,
           low,
           market,
           median,
           card,
           store
    }

    required convenience public init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
          throw ManaKitError.missingManagedObjectContext
        }

        self.init(context: context)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.condition = try container.decode(String.self, forKey: .condition)
        self.dateUpdated = try container.decode(Date.self, forKey: .dateUpdated)
        self.directLow = try container.decode(Double.self, forKey: .directLow)
        self.high = try container.decode(Double.self, forKey: .high)
        self.id = try container.decode(Int32.self, forKey: .id)
        self.isFoil = try container.decode(Bool.self, forKey: .isFoil)
        self.low = try container.decode(Double.self, forKey: .low)
        self.market = try container.decode(Double.self, forKey: .market)
        self.median = try container.decode(Double.self, forKey: .median)
        self.card = try container.decode(MGCard.self, forKey: .card)
        self.store = try container.decode(MGStore.self, forKey: .store)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(condition, forKey: .condition)
        try container.encode(dateUpdated, forKey: .dateUpdated)
        try container.encode(directLow, forKey: .directLow)
        try container.encode(high, forKey: .high)
        try container.encode(id, forKey: .id)
        try container.encode(isFoil, forKey: .isFoil)
        try container.encode(low, forKey: .low)
        try container.encode(market, forKey: .market)
        try container.encode(median, forKey: .median)
        try container.encode(card, forKey: .card)
        try container.encode(store, forKey: .store)
    }
}

// MARK: - MGCardType

public class MGCardType: NSManagedObject, Codable {
    enum CodingKeys: CodingKey {
      case name,
           nameSection,
           subtypes,
           supertypes,
           children,
           parent
    }

    required convenience public init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
          throw ManaKitError.missingManagedObjectContext
        }

        self.init(context: context)

        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.nameSection = try container.decode(String.self, forKey: .nameSection)
        self.subtypes = try container.decode(Set<MGCard>.self, forKey: .subtypes) as NSSet
        self.supertypes = try container.decode(Set<MGCard>.self, forKey: .supertypes) as NSSet
        self.children = try container.decode(Set<MGCardType>.self, forKey: .children) as NSSet
        self.parent = try container.decode(MGCardType.self, forKey: .parent)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(nameSection, forKey: .nameSection)
        try container.encode(subtypes as! Set<MGCard>, forKey: .subtypes)
        try container.encode(supertypes as! Set<MGCard>, forKey: .supertypes)
        try container.encode(children as! Set<MGCardType>, forKey: .children)
        try container.encode(parent, forKey: .parent)
    }
}

// MARK: - MGColor

public class MGColor: NSManagedObject, Codable {
    enum CodingKeys: CodingKey {
      case name,
           nameSection,
           symbol,
           cards,
           identities,
           indicators
    }

    required convenience public init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
          throw ManaKitError.missingManagedObjectContext
        }

        self.init(context: context)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.nameSection = try container.decode(String.self, forKey: .nameSection)
        self.symbol = try container.decode(String.self, forKey: .symbol)
        self.cards = try container.decode(Set<MGCard>.self, forKey: .cards) as NSSet
        self.identities = try container.decode(Set<MGCard>.self, forKey: .identities) as NSSet
        self.indicators = try container.decode(Set<MGCard>.self, forKey: .indicators) as NSSet
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(nameSection, forKey: .nameSection)
        try container.encode(symbol, forKey: .symbol)
        try container.encode(cards as! Set<MGCard>, forKey: .cards)
        try container.encode(identities as! Set<MGCard>, forKey: .identities)
        try container.encode(indicators as! Set<MGCard>, forKey: .indicators)
    }
}

// MARK: - MGComponent

public class MGComponent: NSManagedObject, Codable {
    enum CodingKeys: CodingKey {
      case name,
           nameSection,
           componentParts
    }

    required convenience public init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
          throw ManaKitError.missingManagedObjectContext
        }

        self.init(context: context)

        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.nameSection = try container.decode(String.self, forKey: .nameSection)
        self.componentParts = try container.decode(Set<MGCardComponentPart>.self, forKey: .componentParts) as NSSet
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.name, forKey: .name)
        try container.encode(self.nameSection, forKey: .nameSection)
        try container.encode(self.componentParts as! Set<MGCardComponentPart>, forKey: .componentParts)
    }
}

// MARK: - MGFormat

public class MGFormat: NSManagedObject, Codable {
    enum CodingKeys: CodingKey {
      case name,
           nameSection,
           cardFormatLegalities
    }

    required convenience public init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
          throw ManaKitError.missingManagedObjectContext
        }

        self.init(context: context)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.nameSection = try container.decode(String.self, forKey: .nameSection)
        self.cardFormatLegalities = try container.decode(Set<MGCardFormatLegality>.self, forKey: .cardFormatLegalities) as NSSet
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(nameSection, forKey: .nameSection)
        try container.encode(cardFormatLegalities as! Set<MGCardFormatLegality>, forKey: .cardFormatLegalities)
    }
}

// MARK: - MGFrame

public class MGFrame: NSManagedObject, Codable {
    enum CodingKeys: CodingKey {
      case description_,
           name,
           nameSection,
           cards
    }

    required convenience public init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
          throw ManaKitError.missingManagedObjectContext
        }

        self.init(context: context)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.description_ = try container.decode(String.self, forKey: .description_)
        self.name = try container.decode(String.self, forKey: .name)
        self.nameSection = try container.decode(String.self, forKey: .nameSection)
        self.cards = try container.decode(Set<MGCard>.self, forKey: .cards) as NSSet
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(description_, forKey: .description_)
        try container.encode(name, forKey: .name)
        try container.encode(nameSection, forKey: .nameSection)
        try container.encode(cards as! Set<MGCard>, forKey: .cards)
    }
}

// MARK: - MGFrameEfect

public class MGFrameEffect: NSManagedObject, Codable {
    enum CodingKeys: CodingKey {
        case description_,
             id,
             name,
             nameSection,
             cards
    }

    required convenience public init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
          throw ManaKitError.missingManagedObjectContext
        }

        self.init(context: context)

        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.description_ = try container.decode(String.self, forKey: .description_)
        self.id = try container.decode(String.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.nameSection = try container.decode(String.self, forKey: .nameSection)
        self.cards = try container.decode(Set<MGCard>.self, forKey: .cards) as NSSet
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(description_, forKey: .description_)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(nameSection, forKey: .nameSection)
        try container.encode(cards as! Set<MGCard>, forKey: .cards)
    }
}

// MARK: - MGLanguage

public class MGLanguage: NSManagedObject, Codable {
    enum CodingKeys: CodingKey {
      case code,
           displayCode,
           name,
           nameSection,
           cards,
           sets
    }

    required convenience public init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
          throw ManaKitError.missingManagedObjectContext
        }

        self.init(context: context)

        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.code = try container.decode(String.self, forKey: .code)
        self.displayCode = try container.decode(String.self, forKey: .displayCode)
        self.name = try container.decode(String.self, forKey: .name)
        self.nameSection = try container.decode(String.self, forKey: .nameSection)
        self.cards = try container.decode(Set<MGCard>.self, forKey: .cards) as NSSet
        self.sets = try container.decode(Set<MGSet>.self, forKey: .sets) as NSSet
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(code, forKey: .code)
        try container.encode(displayCode, forKey: .displayCode)
        try container.encode(name, forKey: .name)
        try container.encode(nameSection, forKey: .nameSection)
        try container.encode(cards as! Set<MGCard>, forKey: .cards)
        try container.encode(sets as! Set<MGSet>, forKey: .sets)
    }
}

// MARK: - MGLayout

public class MGLayout: NSManagedObject, Codable {
    enum CodingKeys: CodingKey {
        case description_,
             name,
             nameSection,
             cards
    }

    required convenience public init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
          throw ManaKitError.missingManagedObjectContext
        }

        self.init(context: context)

        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.description_ = try container.decode(String.self, forKey: .description_)
        self.name = try container.decode(String.self, forKey: .name)
        self.nameSection = try container.decode(String.self, forKey: .nameSection)
        self.cards = try container.decode(Set<MGCard>.self, forKey: .cards) as NSSet
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(description_, forKey: .description_)
        try container.encode(name, forKey: .name)
        try container.encode(nameSection, forKey: .nameSection)
        try container.encode(cards as! Set<MGCard>, forKey: .cards)
    }
}

// MARK: - MGLegality

public class MGLegality: NSManagedObject, Codable {
    enum CodingKeys: CodingKey {
        case name,
             nameSection,
             cardFormatLegalities
    }

    required convenience public init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
          throw ManaKitError.missingManagedObjectContext
        }

        self.init(context: context)

        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.nameSection = try container.decode(String.self, forKey: .nameSection)
        self.cardFormatLegalities = try container.decode(Set<MGCardFormatLegality>.self, forKey: .cardFormatLegalities) as NSSet
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(nameSection, forKey: .nameSection)
        try container.encode(cardFormatLegalities as! Set<MGCardFormatLegality>, forKey: .cardFormatLegalities)
    }
}

// MARK: - MGLocalCache

public class MGLocalCache: NSManagedObject, Codable {
    enum CodingKeys: CodingKey {
      case dateCreated,
           lastUpdated,
           page,
           pageCount,
           pageLimit,
           query,
           rowCount,
           tableName
    }

    required convenience public init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
          throw ManaKitError.missingManagedObjectContext
        }

        self.init(context: context)

        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.dateCreated = try container.decode(Date.self, forKey: .dateCreated)
        self.lastUpdated = try container.decode(Date.self, forKey: .lastUpdated)
        self.page = try container.decode(Int32.self, forKey: .page)
        self.pageCount = try container.decode(Int32.self, forKey: .pageCount)
        self.pageLimit = try container.decode(Int32.self, forKey: .pageLimit)
        self.query = try container.decode(String.self, forKey: .query)
        self.rowCount = try container.decode(Int32.self, forKey: .rowCount)
        self.tableName = try container.decode(String.self, forKey: .tableName)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(dateCreated, forKey: .dateCreated)
        try container.encode(lastUpdated, forKey: .lastUpdated)
        try container.encode(page, forKey: .page)
        try container.encode(pageCount, forKey: .pageCount)
        try container.encode(pageLimit, forKey: .pageLimit)
        try container.encode(query, forKey: .query)
        try container.encode(rowCount, forKey: .rowCount)
        try container.encode(tableName, forKey: .tableName)
    }
}

// MARK: - MGRarity

public class MGRarity: NSManagedObject, Codable {
    enum CodingKeys: CodingKey {
        case name,
             nameSection,
             cards
    }

    required convenience public init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
          throw ManaKitError.missingManagedObjectContext
        }

        self.init(context: context)

        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.nameSection = try container.decode(String.self, forKey: .nameSection)
        self.cards = try container.decode(Set<MGCard>.self, forKey: .cards) as NSSet
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(nameSection, forKey: .nameSection)
        try container.encode(cards as! Set<MGCard>, forKey: .cards)
    }
}

// MARK: - MGRule

public class MGRule: NSManagedObject, Codable {
    enum CodingKeys: CodingKey {
        case definition,
             id,
             order,
             term,
             termSection,
             children,
             parent
        
    }

    required convenience public init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
          throw ManaKitError.missingManagedObjectContext
        }

        self.init(context: context)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.definition = try container.decode(String.self, forKey: .definition)
        self.id = try container.decode(Int32.self, forKey: .id)
        self.order = try container.decode(Double.self, forKey: .order)
        self.term = try container.decode(String.self, forKey: .term)
        self.termSection = try container.decode(String.self, forKey: .termSection)
        self.children = try container.decode(Set<MGRule>.self, forKey: .children) as NSSet
        self.parent = try container.decode(MGRule.self, forKey: .parent)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(definition, forKey: .definition)
        try container.encode(id, forKey: .id)
        try container.encode(order, forKey: .order)
        try container.encode(term, forKey: .term)
        try container.encode(termSection, forKey: .termSection)
        try container.encode(children as! Set<MGRule>, forKey: .children)
        try container.encode(parent, forKey: .parent)
    }
}

// MARK: - MGRuling

public class MGRuling: NSManagedObject, Codable {
    enum CodingKeys: CodingKey {
      case datePublished,
           id,
           oracleId,
           text
    }

    required convenience public init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
          throw ManaKitError.missingManagedObjectContext
        }

        self.init(context: context)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.datePublished = try container.decode(Date.self, forKey: .datePublished)
        self.id = try container.decode(Int32.self, forKey: .id)
        self.oracleId = try container.decode(String.self, forKey: .oracleId)
        self.text = try container.decode(String.self, forKey: .text)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(datePublished, forKey: .datePublished)
        try container.encode(id, forKey: .id)
        try container.encode(oracleId, forKey: .oracleId)
        try container.encode(text, forKey: .text)
    }
}

// MARK: - MGServerInfo

public class MGServerInfo: NSManagedObject, Codable {
    enum CodingKeys: CodingKey {
      case id,
           keyruneVersion,
           scryfallVersion
    }

    required convenience public init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
          throw ManaKitError.missingManagedObjectContext
        }

        self.init(context: context)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.keyruneVersion = try container.decode(String.self, forKey: .keyruneVersion)
        self.scryfallVersion = try container.decode(String.self, forKey: .scryfallVersion)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(keyruneVersion, forKey: .keyruneVersion)
        try container.encode(scryfallVersion, forKey: .scryfallVersion)
    }
}

// MARK: - MGSet

public class MGSet: NSManagedObject, Codable {
    enum CodingKeys: CodingKey {
      case cardCount,
           code,
           dateCreated,
           dateUpdated,
           isFoilOnly,
           isOnlineOnly,
           keyruneClass,
           keyruneUnicode,
           mtgoCode,
           myNameSection,
           myYearSection,
           name,
           releaseDate,
           tcgplayerId,
           cards,
           languages,
           children,
           parent,
           setBlock,
           setType
    }

    required convenience public init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
          throw ManaKitError.missingManagedObjectContext
        }

        self.init(context: context)

        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.cardCount = try container.decode(Int32.self, forKey: .cardCount)
        self.code = try container.decode(String.self, forKey: .code)
        self.dateCreated = try container.decode(Date.self, forKey: .dateCreated)
        self.dateUpdated = try container.decode(Date.self, forKey: .dateUpdated)
        self.isFoilOnly = try container.decode(Bool.self, forKey: .isFoilOnly)
        self.isOnlineOnly = try container.decode(Bool.self, forKey: .isOnlineOnly)
        self.keyruneClass = try container.decode(String.self, forKey: .keyruneClass)
        self.keyruneUnicode = try container.decode(String.self, forKey: .keyruneUnicode)
        self.mtgoCode = try container.decode(String.self, forKey: .mtgoCode)
        self.myNameSection = try container.decode(String.self, forKey: .myNameSection)
        self.myYearSection = try container.decode(String.self, forKey: .myYearSection)
        self.name = try container.decode(String.self, forKey: .name)
        self.releaseDate = try container.decode(String.self, forKey: .releaseDate)
        self.tcgplayerId = try container.decode(Int32.self, forKey: .tcgplayerId)
        self.cards = try container.decode(Set<MGCard>.self, forKey: .cards) as NSSet
        self.languages = try container.decode(Set<MGLanguage>.self, forKey: .languages) as NSSet
        self.children = try container.decode(Set<MGSet>.self, forKey: .children) as NSSet
        self.parent = try container.decode(MGSet.self, forKey: .parent)
        self.setBlock = try container.decode(MGSetBlock.self, forKey: .setBlock)
        self.setType = try container.decode(MGSetType.self, forKey: .setType)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(cardCount, forKey: .cardCount)
        try container.encode(code, forKey: .code)
        try container.encode(dateCreated, forKey: .dateCreated)
        try container.encode(dateUpdated, forKey: .dateUpdated)
        try container.encode(isFoilOnly, forKey: .isFoilOnly)
        try container.encode(isOnlineOnly, forKey: .isOnlineOnly)
        try container.encode(keyruneClass, forKey: .keyruneClass)
        try container.encode(keyruneUnicode, forKey: .keyruneUnicode)
        try container.encode(mtgoCode, forKey: .mtgoCode)
        try container.encode(myNameSection, forKey: .myNameSection)
        try container.encode(myYearSection, forKey: .myYearSection)
        try container.encode(name, forKey: .name)
        try container.encode(releaseDate, forKey: .releaseDate)
        try container.encode(tcgplayerId, forKey: .tcgplayerId)
        try container.encode(cards as! Set<MGCard>, forKey: .cards)
        try container.encode(languages as! Set<MGLanguage>, forKey: .languages)
        try container.encode(children as! Set<MGSet>, forKey: .children)
        try container.encode(parent, forKey: .parent)
        try container.encode(setBlock, forKey: .setBlock)
        try container.encode(setType, forKey: .setType)
    }
}

// MARK: - MGSetBlock

public class MGSetBlock: NSManagedObject, Codable {
    enum CodingKeys: CodingKey {
      case code,
           name,
           nameSection,
           sets
    }

    required convenience public init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
          throw ManaKitError.missingManagedObjectContext
        }

        self.init(context: context)

        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.code = try container.decode(String.self, forKey: .code)
        self.name = try container.decode(String.self, forKey: .name)
        self.nameSection = try container.decode(String.self, forKey: .nameSection)
        self.sets = try container.decode(Set<MGSet>.self, forKey: .sets) as NSSet
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(code, forKey: .code)
        try container.encode(name, forKey: .name)
        try container.encode(nameSection, forKey: .nameSection)
        try container.encode(sets as! Set<MGSet>, forKey: .sets)
    }
}

// MARK: - MGSetType

public class MGSetType: NSManagedObject, Codable {
    enum CodingKeys: CodingKey {
      case name,
           nameSection,
           sets
    }

    required convenience public init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
          throw ManaKitError.missingManagedObjectContext
        }

        self.init(context: context)

        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.nameSection = try container.decode(String.self, forKey: .nameSection)
        self.sets = try container.decode(Set<MGSet>.self, forKey: .sets) as NSSet
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(nameSection, forKey: .nameSection)
        try container.encode(sets as! Set<MGSet>, forKey: .sets)
    }
}

// MARK: - MGStore

public class MGStore: NSManagedObject, Codable {
    enum CodingKeys: CodingKey {
      case name,
           nameSection,
           prices
    }

    required convenience public init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
          throw ManaKitError.missingManagedObjectContext
        }

        self.init(context: context)

        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.nameSection = try container.decode(String.self, forKey: .nameSection)
        self.prices = try container.decode(Set<MGCardPrice>.self, forKey: .prices) as NSSet
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(nameSection, forKey: .nameSection)
        try container.encode(prices as! Set<MGCardPrice>, forKey: .prices)
    }
}

// MARK: - MGWatermark

public class MGWatermark: NSManagedObject, Codable {
    enum CodingKeys: CodingKey {
      case name,
           nameSection,
           cards
    }

    required convenience public init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
          throw ManaKitError.missingManagedObjectContext
        }

        self.init(context: context)

        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.nameSection = try container.decode(String.self, forKey: .nameSection)
        self.cards = try container.decode(Set<MGCard>.self, forKey: .cards) as NSSet
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name , forKey: .name)
        try container.encode(nameSection , forKey: .nameSection)
        try container.encode(cards as! Set<MGCard>, forKey: .cards)
    }
}
