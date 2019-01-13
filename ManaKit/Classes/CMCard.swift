//
//  CMCard.swift
//  Pods
//
//  Created by Jovito Royeca on 26/12/2018.
//
//

import Foundation
import SDWebImage
import RealmSwift

public enum CardImageType: Int, CaseIterable {
    case png
    case borderCrop
    case artCrop
    case large
    case normal
    case small
    
    public var description : String {
        switch self {
            
        case .png: return "png"
        case .borderCrop: return "border_crop"
        case .artCrop: return "art_crop"
        case .large: return "large"
        case .normal: return "normal"
        case .small: return "small"
        }
    }
}
public enum CardType: Int, CaseIterable {
    case artifact
    case chaos
    case conspiracy
    case creature
    case enchantment
    case instant
    case land
    case phenomenon
    case plane
    case planesWalker
    case scheme
    case sorcery
    case tribal
    case vanguard
    
    public var description : String {
        switch self {
            
        case .artifact: return "Artifact"
        case .chaos: return "Chaos"
        case .conspiracy: return "Conspiracy"
        case .creature: return "Creature"
        case .enchantment: return "Enchantment"
        case .instant: return "Instant"
        case .land: return "Land"
        case .phenomenon: return "Phenomenon"
        case .plane: return "Plane"
        case .planesWalker: return "Planeswalker"
        case .scheme: return "Scheme"
        case .sorcery: return "Sorcery"
        case .tribal: return "Tribal"
        case .vanguard: return "Vanguard"
        }
    }
}

public class CMCard: Object {

    @objc public dynamic var arenaID: String? = nil
    @objc public dynamic var collectorNumber: String? = nil
    @objc public dynamic var convertedManaCost = Double(0)
    @objc public dynamic var displayName: String? = nil
    @objc public dynamic var faceOrder = Int32(0)
    @objc public dynamic var firebaseID: String? = nil
    @objc public dynamic var firebaseRating = Double(0)
    @objc public dynamic var firebaseViews = Int64(0)
    @objc public dynamic var firebaseLastUpdate: Date? = nil
    @objc public dynamic var flavorText: String? = nil
    @objc public dynamic var id: String? = nil
    @objc public dynamic var illustrationID: String? = nil
    @objc public dynamic var imageURIs: Data? = nil
    @objc public dynamic var internalID = Int32(0)
    @objc public dynamic var isColorshifted = false
    @objc public dynamic var isDigital = false
    @objc public dynamic var isFoil = false
    @objc public dynamic var isFullArt = false
    @objc public dynamic var isFutureshifted = false
    @objc public dynamic var isHighResImage = false
    @objc public dynamic var isNonFoil = false
    @objc public dynamic var isOversized = false
    @objc public dynamic var isReprint = false
    @objc public dynamic var isReserved = false
    @objc public dynamic var isStorySpotlight = false
    @objc public dynamic var isTimeshifted = false
    @objc public dynamic var loyalty: String? = nil
    @objc public dynamic var manaCost: String? = nil
    @objc public dynamic var mtgoFoilID: String? = nil
    @objc public dynamic var mtgoID: String? = nil
    @objc public dynamic var multiverseIDs: Data? = nil
    @objc public dynamic var myNameSection: String? = nil
    @objc public dynamic var myNumberOrder = Double(0)
    @objc public dynamic var name: String? = nil
    @objc public dynamic var oracleID: String? = nil
    @objc public dynamic var oracleText: String? = nil
    @objc public dynamic var power: String? = nil
    @objc public dynamic var printedName: String? = nil
    @objc public dynamic var printedText: String? = nil
    @objc public dynamic var releaseDate: String? = nil
    @objc public dynamic var tcgPlayerPurchaseURI: String? = nil
    @objc public dynamic var tcgPlayerID = Int32(0)
    @objc public dynamic var tcgPlayerLstUpdate: Date? = nil
    @objc public dynamic var toughness: String? = nil
    
    // MARK: Relationships
    @objc public dynamic var artist: CMCardArtist?
    @objc public dynamic var borderColor: CMCardBorderColor?
    public let cardLegalities = List<CMCardLegality>()
    public let cardRulings = List<CMCardRuling>()
    public let colors = List<CMCardColor>()
    public let colorIdentities = List<CMCardColor>()
    public let colorIndicators = List<CMCardColor>()
    public let deckHeroes = List<CMDeck>()
    @objc public dynamic var face: CMCard?
    public let faces = List<CMCard>()
    public let firebaseUserFavorites = List<CMUser>()
    public let firebaseUserRatings = List<CMCardRating>()
    @objc public dynamic var frame: CMCardFrame?
    @objc public dynamic var frameEffect: CMCardFrameEffect?
    public let inventories = List<CMInventory>()
    @objc public dynamic var language: CMLanguage?
    @objc public dynamic var layout: CMCardLayout?
    @objc public dynamic var myType: CMCardType?
    public let otherLanguages = List<CMCard>()
    public let otherPrintings = List<CMCard>()
    @objc public dynamic var part: CMCard?
    public let parts = List<CMCard>()
    public let pricings = List<CMCardPricing>()
    @objc public dynamic var printedTypeLine: CMCardType?
    @objc public dynamic var rarity: CMCardRarity?
    @objc public dynamic var set: CMSet?
    @objc public dynamic var tcgplayerStorePricing: CMStorePricing?
    @objc public dynamic var typeLine: CMCardType?
    public let variations = List<CMCard>()
    @objc public dynamic var watermark: CMCardWatermark?
    
    // MARK: Primary key
    override public static func primaryKey() -> String? {
        return "internalID"
    }

    // MARK: Custom methods
    public func willUpdateTCGPlayerCardPricing() -> Bool {
        var willUpdate = false
        
        if let lastUpdate = tcgPlayerLstUpdate {
            if let diff = Calendar.current.dateComponents([.hour],
                                                          from: lastUpdate as Date,
                                                          to: Date()).hour {
                if diff >= ManaKit.Constants.TcgPlayerPricingAge {
                    willUpdate = true
                }
            }
        } else {
            willUpdate = true
        }
        
        return willUpdate
    }
    
    public func willUpdateTCGPlayerStorePricing() -> Bool {
        var willUpdate = false
        
        if let storePricing = tcgplayerStorePricing,
            let lastUpdate = storePricing.lastUpdate {
            
            if let diff = Calendar.current.dateComponents([.hour],
                                                          from: lastUpdate as Date,
                                                          to: Date()).hour {
                
                if diff >= ManaKit.Constants.TcgPlayerPricingAge {
                    willUpdate = true
                }
            }
        }
        
        return willUpdate
    }
    
    public func willUpdateFirebaseData() -> Bool {
        var willUpdate = false
        
        if let lastUpdate = firebaseLastUpdate {
            
            if let diff = Calendar.current.dateComponents([.second],
                                                          from: lastUpdate as Date,
                                                          to: Date()).second {
                
                if diff >= ManaKit.Constants.FirebaseDataAge {
                    willUpdate = true
                }
            }
        }
        
        return willUpdate
    }
    
    public func keyruneColor() -> UIColor? {
        guard let set = set,
            let rarity = rarity else {
            return nil
        }
        
        var color:UIColor?
        
        if set.code == "tsb" {
            color = UIColor(hex: "652978") // purple
        } else {
            if rarity.name == "Common" {
                color = UIColor(hex: "1A1718")
            } else if rarity.name == "Uncommon" {
                color = UIColor(hex: "707883")
            } else if rarity.name == "Rare" {
                color = UIColor(hex: "A58E4A")
            } else if rarity.name == "Mythic" {
                color = UIColor(hex: "BF4427")
            } else if rarity.name == "Special" {
                color = UIColor(hex: "BF4427")
            } else if rarity.name == "Timeshifted" {
                color = UIColor(hex: "652978")
            } else if rarity.name == "Basic Land" {
                color = UIColor(hex: "000000")
            }
        }
        
        return color
    }
    
    public func isModern() -> Bool {
        guard let set = set,
            let releaseDate = set.releaseDate else {
            return false
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        if let eightEditionDate = formatter.date(from: ManaKit.Constants.EightEditionRelease),
            let setReleaseDate = formatter.date(from: releaseDate) {
            return setReleaseDate.compare(eightEditionDate) == .orderedDescending ||
                setReleaseDate.compare(eightEditionDate) == .orderedSame
        }
        
        return false
    }
    
    public func typeImage() -> UIImage? {
        if let type = myType,
            let name = type.name {
            
            return ManaKit.sharedInstance.symbolImage(name: name)
        }
        
        return nil
    }
    
    public func typeText(includePower: Bool) -> String {
        var typeText = ""
        
        if let language = language,
            let code = language.code {
            
            if code == "en" {
                if let type = typeLine,
                    let name = type.name {
                    typeText = name
                }
            } else {
                if let type = printedTypeLine,
                    let name = type.name {
                    typeText = name
                }
            }
            
            // fallback to default typeLine
            if typeText.count == 0 {
                if let type = typeLine,
                    let name = type.name {
                    typeText = name
                }
            }
            
            if includePower {
                if let power = power,
                    let toughness = toughness {
                    typeText.append(" (\(power)/\(toughness))")
                }
                
                if let loyalty = loyalty {
                    typeText.append(" (\(loyalty))")
                }
            }
        }
        
        return typeText
    }
    
    public func imageURL(type: CardImageType, faceOrder: Int) -> URL? {
        var url:URL?
        var urlString: String?
        
        
        if let imageURIs = imageURIs,
            let dict = NSKeyedUnarchiver.unarchiveObject(with: imageURIs as Data) as? [String: String] {
            urlString = dict[type.description]
        } else {
            let orderedFaces = faces.sorted(by: {(a, b) -> Bool in
                return a.faceOrder < b.faceOrder
            })
            let face = orderedFaces[faceOrder]
            
            if let imageURIs = face.imageURIs,
                let dict = NSKeyedUnarchiver.unarchiveObject(with: imageURIs as Data) as? [String: String] {
                urlString = dict[type.description]
            }
        }
        
        if let urlString = urlString {
            url = URL(string: urlString)
        }
        
        return url
    }
    
    public func backImage() -> UIImage? {
        guard let set = set else {
            return nil
        }
        
        if set.code == "ced" {
            return ManaKit.sharedInstance.imageFromFramework(imageName: .collectorsCardBack)
        } else if set.code == "cei" {
            return ManaKit.sharedInstance.imageFromFramework(imageName: .intlCollectorsCardBack)
        } else {
            return ManaKit.sharedInstance.imageFromFramework(imageName: .cardBack)
        }
    }
    
    public func image(type: CardImageType, faceOrder: Int, roundCornered: Bool) -> UIImage? {
        var cardImage: UIImage?
        
        guard let url = imageURL(type: type,
                                 faceOrder: faceOrder) else {
            return nil
        }
        
        let imageCache = SDImageCache.init()
        let cacheKey = url.absoluteString
        
        cardImage = imageCache.imageFromDiskCache(forKey: cacheKey)
        
        if roundCornered {
            if let c = cardImage {
                cardImage = c.roundCornered(card: self)
            }
        }
        
        return cardImage
    }
}

