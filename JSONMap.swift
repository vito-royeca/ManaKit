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

protocol MEntity: Codable {
    
}

enum LanguageCode: String, MEntity {
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

enum NameSection: String, MEntity {
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
struct MCard: MEntity {
    let collectorNumber: String?
    let cmc, faceOrder: Int?
    let flavorText: String?
    let isFoil, isFullArt, isHighresImage, isNonfoil, isOversized, isReserved, isStorySpotlight: Bool?
    let loyalty, manaCost: String?
    let myNameSection: NameSection?
    let myNumberOrder: Double?
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
    let variations: [MCard]?
    let formatLegalities: [MFormatLegality]?
    let frameEffects: [MFrameEffect]?
    let subtypes, supertypes: [MType]?
    let prices: [MPrice]?
    let rulings: [MRuling]?
    let imageURIs: [MImageURI]?

    enum CodingKeys: String, CodingKey {
        case collectorNumber = "collector_number"
        case cmc
        case faceOrder = "face_order"
        case flavorText = "flavor_text"
        case isFoil = "is_foil"
        case isFullArt = "is_full_art"
        case isHighresImage = "is_highres_image"
        case isNonfoil = "is_nonfoil"
        case isOversized = "is_oversized"
        case isReserved = "is_reserved"
        case isStorySpotlight = "is_story_spotlight"
        case loyalty
        case manaCost = "mana_cost"
        case myNameSection = "my_name_section"
        case myNumberOrder = "my_number_order"
        case name
        case oracleText = "oracle_text"
        case power
        case printedName = "printed_name"
        case printedText = "printed_text"
        case toughness
        case arenaID = "arena_id"
        case mtgoID = "mtgo_id"
        case tcgplayerID = "tcgplayer_id"
        case handModifier = "hand_modifier"
        case lifeModifier = "life_modifier"
        case isBooster = "is_booster"
        case isDigital = "is_digital"
        case isPromo = "is_promo"
        case releasedAt = "released_at"
        case isTextless = "is_textless"
        case mtgoFoilID = "mtgo_foil_id"
        case isReprint = "is_reprint"
        case newID = "new_id"
        case printedTypeLine = "printed_type_line"
        case typeLine = "type_line"
        case multiverseIDs = "multiverse_ids"
        case rarity, language, layout, watermark, frame, artist, colors
        case colorIdentities = "color_identities"
        case colorIndicators = "color_indicators"
        case componentParts = "component_parts"
        case faces
        case otherLanguages = "other_languages"
        case otherPrintings = "other_printings"
        case variations
        case formatLegalities = "format_legalities"
        case frameEffects = "frame_effects"
        case subtypes, supertypes, prices, rulings
        case imageURIs = "image_uris"
    }
}

// MARK: - Artist
struct MArtist: MEntity {
    let name: String
}

// MARK: - Color
struct MColor: MEntity {
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
struct MComponent: MEntity {
    let name: String
    let nameSection: NameSection

    enum CodingKeys: String, CodingKey {
        case name
        case nameSection = "name_section"
    }
}

// MARK: - ComponentPart
struct MComponentPart: MEntity {
    let component: MComponent
    let card: MCard

    enum CodingKeys: String, CodingKey {
        case component
        case card
    }
}

// MARK: - Format
struct MFormat: MEntity {
    let name: String
    let nameSection: NameSection

    enum CodingKeys: String, CodingKey {
        case name
        case nameSection = "name_section"
    }
}

// MARK: - FormatLegality
struct MFormatLegality: MEntity {
    let format: MFormat
    let legality: MLegality
}

// MARK: - Frame
struct MFrame: MEntity {
    let description_: String?
    let name: String
    let nameSection: NameSection?
 
    enum CodingKeys: String, CodingKey {
        case name, description_
        case nameSection = "name_section"
    }
}

// MARK: - FrameEffect
struct MFrameEffect: MEntity {
    let id: String
    let description_: String
    let name: String
    let nameSection: NameSection
 
    enum CodingKeys: String, CodingKey {
        case id, name, description_
        case nameSection = "name_section"
    }
}

// MARK: - ImageUris
struct MImageURI: MEntity {
    let artCrop, normal, png: String

    enum CodingKeys: String, CodingKey {
        case artCrop = "art_crop"
        case normal, png
    }
}

// MARK: - Language
struct MLanguage: MEntity {
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
struct MLayout: MEntity {
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
struct MLegality: MEntity {
    let name: String
    let nameSection: NameSection

    enum CodingKeys: String, CodingKey {
        case name
        case nameSection = "name_section"
    }
}

// MARK: - Parent
struct MParent: MEntity {
    let code: String
}

// MARK: - Price
struct MPrice: MEntity {
    let id: Int32?
    let low, median, high, market: Double?
    let directLow: Double?
    let isFoil: Bool
    let dateUpdated: Date?

    enum CodingKeys: String, CodingKey {
        case id, low, median, high, market
        case directLow = "direct_low"
        case isFoil = "is_foil"
        case dateUpdated = "date_updated"
    }
}

// MARK: - Rarity
struct MRarity: MEntity {
    let name: String
    let nameSection: NameSection?

    enum CodingKeys: String, CodingKey {
        case name
        case nameSection = "name_section"
    }
}

// MARK: - Ruling
struct MRuling: MEntity {
    let id: Int
    let datePublished, text: String

    enum CodingKeys: String, CodingKey {
        case id
        case datePublished = "date_published"
        case text
    }
}

// MARK: - MSet
struct MSet: MEntity {
    let cardCount: Int?
    let code: String
    let isFoilOnly, isOnlineOnly: Bool?
    let mtgoCode, keyruneUnicode, keyruneClass: String?
    let myNameSection: NameSection?
    let myYearSection, releaseDate: String?
    let name: String
    let tcgplayerID: Int?
    let parent: MParent?
    let setBlock: MSetBlock?
    let setType: MSetType?
    let languages: [MLanguage]?
    let cards: [MCard]?
    
    enum CodingKeys: String, CodingKey {
        case cardCount = "card_count"
        case code
        case isFoilOnly = "is_foil_only"
        case isOnlineOnly = "is_online_only"
        case mtgoCode = "mtgo_code"
        case keyruneUnicode = "keyrune_unicode"
        case keyruneClass = "keyrune_class"
        case myNameSection = "my_name_section"
        case myYearSection = "my_year_section"
        case name
        case releaseDate = "release_date"
        case tcgplayerID = "tcgplayer_id"
        case parent
        case setBlock = "set_block"
        case setType = "set_type"
        case languages
        case cards
    }
}

// MARK: - SetBlock
struct MSetBlock: MEntity {
    let code: String
    let displayCode: String?
    let name: String
    let nameSection: NameSection

    enum CodingKeys: String, CodingKey {
        case code
        case displayCode = "display_code"
        case name
        case nameSection = "name_section"
    }
}

// MARK: - SetType
struct MSetType: MEntity {
    let name: String
    let nameSection: NameSection

    enum CodingKeys: String, CodingKey {
        case name
        case nameSection = "name_section"
    }
}

// MARK: - Type
struct MType: MEntity {
    let name: String
}

// MARK: - Watermark
struct MWatermark: MEntity {
    let name: String
    let nameSection: NameSection

    enum CodingKeys: String, CodingKey {
        case name
        case nameSection = "name_section"
    }
}
