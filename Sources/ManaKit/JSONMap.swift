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

// MARK: - WelcomeElement
public struct MCard: MEntity {
    let artCropURL, collectorNumber: String?
    let cmc: Double?
    let faceOrder: Int?
    let flavorText, handModifier, lifeModifier: String?
    let isFoil, isFullArt, isHighresImage, isNonfoil, isOversized, isReserved, isStorySpotlight: Bool?
    let loyalty, manaCost: String?
    let nameSection: String?
    let numberOrder: Double?
    let name, normalURL, oracleText, power, printedName, printedText, toughness, arenaID, mtgoID, pngURL: String?
    let tcgplayerID: Int?
    let isBooster, isDigital, isPromo: Bool?
    let releaseDate: String?
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
    let artists: [MArtist]?
    let colors, colorIdentities, colorIndicators: [MColor]?
    let componentParts: [MComponentPart]?
    let faces: [MCard]?
    let games: [MGame]?
    let keywords: [MKeyword]?
    let otherLanguages: [MCard]?
    let otherPrintings: [MCard]?
    let set: MSet?
    let variations: [MCard]?
    let formatLegalities: [MFormatLegality]?
    let frameEffects: [MFrameEffect]?
    let subtypes, supertypes: [MCardType]?
    let prices: [MPrice]?
    let rulings: [MRuling]?

    enum CodingKeys: String, CodingKey {
        case arenaID          = "arena_id"
        case artCropURL       = "art_crop_url"
        case collectorNumber  = "collector_number"
        case colorIdentities  = "color_identities"
        case colorIndicators  = "color_indicators"
        case componentParts   = "component_parts"
        case faceOrder        = "face_order"
        case flavorText       = "flavor_text"
        case frameEffects     = "frame_effects"
        case formatLegalities = "format_legalities"
        case handModifier     = "hand_modifier"
        case isBooster        = "is_booster"
        case isDigital        = "is_digital"
        case isFoil           = "is_foil"
        case isFullArt        = "is_full_art"
        case isHighresImage   = "is_highres_image"
        case isNonfoil        = "is_nonfoil"
        case isOversized      = "is_oversized"
        case isPromo          = "is_promo"
        case isReprint        = "is_reprint"
        case isReserved       = "is_reserved"
        case isStorySpotlight = "is_story_spotlight"
        case isTextless       = "is_textless"
        case lifeModifier     = "life_modifier"
        case manaCost         = "mana_cost"
        case mtgoFoilID       = "mtgo_foil_id"
        case mtgoID           = "mtgo_id"
        case multiverseIDs    = "multiverse_ids"
        case nameSection      = "name_section"
        case newID            = "new_id"
        case normalURL        = "normal_url"
        case numberOrder      = "number_order"
        case oracleText       = "oracle_text"
        case otherLanguages   = "other_languages"
        case otherPrintings   = "other_printings"
        case pngURL           = "png_url"
        case printedName      = "printed_name"
        case printedText      = "printed_text"
        case printedTypeLine  = "printed_type_line"
        case releaseDate      = "released_at"
        case tcgplayerID      = "tcgplayer_id"
        case typeLine         = "type_line"
        case artists, colors, cmc, faces, frame, games, keywords, language, layout, loyalty, name, power, set, subtypes, supertypes, prices, rarity, rulings, toughness, variations, watermark
    }
}

// MARK: - Artist
public struct MArtist: MEntity {
    let name: String
    let firstName: String?
    let lastName: String?
    let nameSection: String?
    let info: String?
    
    enum CodingKeys: String, CodingKey {
        case name
        case firstName = "first_name"
        case lastName = "last_name"
        case nameSection = "name_section"
        case info
    }
}

// MARK: - CardType
public struct MCardType: MEntity {
    let name: String
    let nameSection: String?
    let parent: String?

    enum CodingKeys: String, CodingKey {
        case name
        case nameSection = "name_section"
        case parent = "cmcardtype_parent"
    }
}

// MARK: - Color
public struct MColor: MEntity {
    let name: String
    let nameSection: String?
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
    let nameSection: String?

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
    let nameSection: String?

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
    let nameSection: String?
 
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
    let nameSection: String?
 
    enum CodingKeys: String, CodingKey {
        case id, name
        case description_ = "description"
        case nameSection  = "name_section"
    }
}

// MARK: - Game
public struct MGame: MEntity {
    let name: String
    let nameSection: String?

    enum CodingKeys: String, CodingKey {
        case name
        case nameSection = "name_section"
    }
}

// MARK: - Keyword
public struct MKeyword: MEntity {
    let name: String
    let nameSection: String?

    enum CodingKeys: String, CodingKey {
        case name
        case nameSection = "name_section"
    }
}

// MARK: - Language
public struct MLanguage: MEntity {
    let code: String
    let displayCode: String?
    let name: String?
    let nameSection: String?

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
    let nameSection: String?
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
    let nameSection: String?

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
    let dateUpdated: String?

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
    let nameSection: String?

    enum CodingKeys: String, CodingKey {
        case name
        case nameSection = "name_section"
    }
}

// MARK: - Ruling
public struct MRuling: MEntity {
    let id: Int32
    let datePublished: String
    let text: String

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
    let logoCode, mtgoCode, keyruneUnicode, keyruneClass: String?
    let nameSection: String?
    let yearSection: String?
    let releaseDate: String?
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
        case logoCode       = "logo_code"
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
    let nameSection: String?

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
    let nameSection: String?

    enum CodingKeys: String, CodingKey {
        case name
        case nameSection = "name_section"
    }
}

// MARK: - Watermark
public struct MWatermark: MEntity {
    let name: String
    let nameSection: String?

    enum CodingKeys: String, CodingKey {
        case name
        case nameSection = "name_section"
    }
}
