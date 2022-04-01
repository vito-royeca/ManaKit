//
//  JSON.swift
//  ManaKit
//
//  Created by Vito Royeca on 3/10/22.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? newJSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

public protocol MEntity: Codable {
    
}

public enum LanguageCode: String, MEntity {
    case cs = "CS"
    case ct = "CT"
    case de = "DE"
    case en = "EN"
    case es = "ES"
    case fr = "FR"
    case it = "IT"
    case jp = "JP"
    case kr = "KR"
    case pt = "PT"
    case ru = "RU"
}

public enum NameSection: String, MEntity {
    case empty = "#"
    case a = "A"
    case b = "B"
    case c = "C"
    case d = "D"
    case e = "E"
    case f = "F"
    case g = "G"
    case h = "H"
    case i = "I"
    case j = "J"
    case k = "K"
    case l = "L"
    case m = "M"
    case n = "N"
    case o = "O"
    case p = "P"
    case q = "Q"
    case r = "R"
    case s = "S"
    case t = "T"
    case u = "U"
    case v = "V"
    case w = "W"
    case x = "X"
    case y = "Y"
    case z = "Z"
}

// MARK: - WelcomeElement
public struct MCard: MEntity {
    let collectorNumber: String?
    let cmc: Double?
    let faceOrder: Int?
    let flavorText: String?
    let isFoil, isFullArt, isHighresImage, isNonfoil, isOversized, isReserved, isStorySpotlight: Bool?
    let loyalty, manaCost: String?
    let nameSection: NameSection?
    let numberOrder: Double?
    let name: String?
    let oracleText, power, printedName, printedText, toughness, arenaID, mtgoID: String?
    let tcgplayerID: Int?
    let handModifier, lifeModifier, isBooster, isDigital, isPromo: Bool?
    let releasedAt: String?
    let isTextless: Bool?
    let mtgoFoilID: String?
    let isReprint: Bool?
    let newID: String
    let printedTypeLine: String?
    let typeLine: String?
    let multiverseIDs: [Int]?
    let rarity: MRarity?
    let language: MLanguage?
    let layout: MLayout?
    let watermark: MWatermark?
    let frame: MFrame?
    let artist: MArtist?
    let colors, colorIdentities, colorIndicators: [MColor]?
    let componentParts: [MComponentPart]?
    let faces: [MCard]?
    let otherLanguages: [MCard]?
    let otherPrintings: [MCard]?
    let set: MSet?
    let variations: [MCard]?
    let formatLegalities: [MFormatLegality]?
    let frameEffects: [MFrameEffect]?
    let subtypes, supertypes: [MCardType]?
    let prices: [MPrice]?
    let rulings: [MRuling]?
    let imageURIs: [MImageURI]?

    enum CodingKeys: String, CodingKey {
        case collectorNumber  = "collector_number"
        case cmc
        case faceOrder        = "face_order"
        case flavorText       = "flavor_text"
        case isFoil           = "is_foil"
        case isFullArt        = "is_full_art"
        case isHighresImage   = "is_highres_image"
        case isNonfoil        = "is_nonfoil"
        case isOversized      = "is_oversized"
        case isReserved       = "is_reserved"
        case isStorySpotlight = "is_story_spotlight"
        case loyalty
        case manaCost         = "mana_cost"
        case nameSection      = "name_section"
        case numberOrder      = "number_order"
        case name
        case oracleText       = "oracle_text"
        case power
        case printedName      = "printed_name"
        case printedText      = "printed_text"
        case toughness
        case arenaID          = "arena_id"
        case mtgoID           = "mtgo_id"
        case tcgplayerID      = "tcgplayer_id"
        case handModifier     = "hand_modifier"
        case lifeModifier     = "life_modifier"
        case isBooster        = "is_booster"
        case isDigital        = "is_digital"
        case isPromo          = "is_promo"
        case releasedAt       = "released_at"
        case isTextless       = "is_textless"
        case mtgoFoilID       = "mtgo_foil_id"
        case isReprint        = "is_reprint"
        case newID            = "new_id"
        case printedTypeLine  = "printed_type_line"
        case typeLine         = "type_line"
        case multiverseIDs    = "multiverse_ids"
        case colorIdentities  = "color_identities"
        case colorIndicators  = "color_indicators"
        case componentParts   = "component_parts"
        case formatLegalities = "format_legalities"
        case frameEffects     = "frame_effects"
        case imageURIs        = "image_uris"
        case otherLanguages   = "other_languages"
        case otherPrintings   = "other_printings"
        case artist, colors, faces, frame, language, layout, set, subtypes, supertypes, prices, rarity, rulings, variations, watermark
    }
}

// MARK: - Artist
public struct MArtist: MEntity {
    let name: String
}

// MARK: - CardType
public struct MCardType: MEntity {
    let name: String
    let nameSection: NameSection?

    enum CodingKeys: String, CodingKey {
        case name
        case nameSection = "name_section"
    }
}

// MARK: - Color
public struct MColor: MEntity {
    let name: String
    let nameSection: NameSection?
    let symbol: String?

    enum CodingKeys: String, CodingKey {
        case name
        case nameSection = "name_section"
        case symbol
    }
}

// MARK: - Component
public struct MComponent: MEntity {
    let name: String
    let nameSection: NameSection?

    enum CodingKeys: String, CodingKey {
        case name
        case nameSection = "name_section"
    }
}

// MARK: - ComponentPart
public struct MComponentPart: MEntity {
    let component: MComponent
    let card: MCard

    enum CodingKeys: String, CodingKey {
        case component
        case card
    }
}

// MARK: - Format
public struct MFormat: MEntity {
    let name: String
    let nameSection: NameSection?

    enum CodingKeys: String, CodingKey {
        case name
        case nameSection = "name_section"
    }
}

// MARK: - FormatLegality
public struct MFormatLegality: MEntity {
    let format: MFormat
    let legality: MLegality
}

// MARK: - Frame
public struct MFrame: MEntity {
    let description_: String?
    let name: String
    let nameSection: NameSection?
 
    enum CodingKeys: String, CodingKey {
        case name
        case description_ = "description"
        case nameSection  = "name_section"
    }
}

// MARK: - FrameEffect
public struct MFrameEffect: MEntity {
    let id: String
    let description_: String?
    let name: String
    let nameSection: NameSection?
 
    enum CodingKeys: String, CodingKey {
        case id, name
        case description_ = "description"
        case nameSection  = "name_section"
    }
}

// MARK: - ImageUris
public struct MImageURI: MEntity {
    let artCrop, normal, png: String

    enum CodingKeys: String, CodingKey {
        case artCrop = "art_crop"
        case normal, png
    }
}

// MARK: - Language
public struct MLanguage: MEntity {
    let code: String
    let displayCode: LanguageCode?
    let name: String?
    let nameSection: NameSection?

    enum CodingKeys: String, CodingKey {
        case code
        case displayCode = "display_code"
        case name
        case nameSection = "name_section"
    }
}

// MARK: - Layout
public struct MLayout: MEntity {
    let name: String
    let nameSection: NameSection?
    let description_: String?

    enum CodingKeys: String, CodingKey {
        case name
        case nameSection = "name_section"
        case description_
    }
}

// MARK: - Legality
public struct MLegality: MEntity {
    let name: String
    let nameSection: NameSection?

    enum CodingKeys: String, CodingKey {
        case name
        case nameSection = "name_section"
    }
}

// MARK: - Price
public struct MPrice: MEntity {
    let id: Int32?
    let low, median, high, market: Double?
    let directLow: Double?
    let isFoil: Bool
    let dateUpdated: Date?

    enum CodingKeys: String, CodingKey {
        case id, low, median, high, market
        case directLow   = "direct_low"
        case isFoil      = "is_foil"
        case dateUpdated = "date_updated"
    }
}

// MARK: - Rarity
public struct MRarity: MEntity {
    let name: String
    let nameSection: NameSection?

    enum CodingKeys: String, CodingKey {
        case name
        case nameSection = "name_section"
    }
}

// MARK: - Ruling
public struct MRuling: MEntity {
    let id: Int32
    let datePublished, text: String

    enum CodingKeys: String, CodingKey {
        case id
        case datePublished = "date_published"
        case text
    }
}

// MARK: - MSet
public struct MSet: MEntity {
    let cardCount: Int?
    let code: String
    let isFoilOnly, isOnlineOnly: Bool?
    let mtgoCode, keyruneUnicode, keyruneClass: String?
    let nameSection: NameSection?
    let yearSection, releaseDate: String?
    let name: String?
    let tcgplayerID: Int?
    let parent: String?
    let setBlock: MSetBlock?
    let setType: MSetType?
    let languages: [MLanguage]?
    let cards: [MCard]?
    
    enum CodingKeys: String, CodingKey {
        case cardCount      = "card_count"
        case code
        case isFoilOnly     = "is_foil_only"
        case isOnlineOnly   = "is_online_only"
        case mtgoCode       = "mtgo_code"
        case keyruneUnicode = "keyrune_unicode"
        case keyruneClass   = "keyrune_class"
        case nameSection    = "name_section"
        case yearSection    = "year_section"
        case name
        case releaseDate    = "release_date"
        case tcgplayerID    = "tcgplayer_id"
        case parent         = "cmset_parent"
        case setBlock       = "set_block"
        case setType        = "set_type"
        case languages
        case cards
    }
}

// MARK: - SetBlock
public struct MSetBlock: MEntity {
    let code: String
    let displayCode: String?
    let name: String
    let nameSection: NameSection?

    enum CodingKeys: String, CodingKey {
        case code
        case displayCode = "display_code"
        case name
        case nameSection = "name_section"
    }
}

// MARK: - SetType
public struct MSetType: MEntity {
    let name: String
    let nameSection: NameSection?

    enum CodingKeys: String, CodingKey {
        case name
        case nameSection = "name_section"
    }
}

// MARK: - Watermark
public struct MWatermark: MEntity {
    let name: String
    let nameSection: NameSection?

    enum CodingKeys: String, CodingKey {
        case name
        case nameSection = "name_section"
    }
}
