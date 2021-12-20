//
//  MGCard+Imaging.swift
//  ManaKit-iOS
//
//  Created by Vito Royeca on 12/24/19.
//

#if canImport(UIKit)

import UIKit
import SDWebImage

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
    case multiple
    
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
        case .multiple: return "Multiple"
        }
    }
}

extension MGCard {
    public var displayName: String? {
        get {
            var dName: String?
            
            if let language = language,
                let code = language.code {
                dName = (code == "en" ? name : printedName) ?? name
            }
            return dName
        }
    }

    public func keyruneColor() -> UIColor? {
        guard let set = set,
            let rarity = rarity else {
            return nil
        }
        
        var color: UIColor?
        
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
        guard let typeLine = typeLine else {
            return nil
        }

        var types = [String]()
        var symbolName: String?

        for type in CardType.allCases {
            let desc = type.description

            for n in typeLine.components(separatedBy: " ") {
                if n == desc && !types.contains(desc) {
                    types.append(desc)
                }
            }
        }

        if types.count == 1 {
            symbolName = types.first

        } else if types.count > 1 {
            symbolName = "Multiple"
        }

        if let symbolName = symbolName {
            return ManaKit.shared.symbolImage(name: symbolName)
        }

        return nil
    }
        
    public func typeText(includePower: Bool) -> String {
        var typeText = ""
        
        if let language = language,
            let code = language.code {
            
            typeText = code == "en" ? typeLine ?? "" : printedTypeLine ?? ""
            
            // fallback to default typeLine
            if typeText.count == 0 {
                typeText = typeLine ?? ""
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
        
        
        if let imageUris = imageUris,
            let dict = NSKeyedUnarchiver.unarchiveObject(with: imageUris as Data) as? [String: String] {
            urlString = dict[type.description]
        } else {
            if let faces = faces {
                let orderedFaces = faces.sorted(by: {(a, b) -> Bool in
                    if let a = a as? MGCard,
                        let b = b as? MGCard {
                        return a.faceOrder < b.faceOrder
                    } else {
                        return false
                    }
                })
                
                if let face = orderedFaces[faceOrder] as? MGCard,
                    let imageURIs = face.imageUris,
                    let dict = NSKeyedUnarchiver.unarchiveObject(with: imageURIs as Data) as? [String: String] {
                    urlString = dict[type.description]
                }
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
            return ManaKit.shared.imageFromFramework(imageName: .collectorsCardBack)
        } else if set.code == "cei" {
            return ManaKit.shared.imageFromFramework(imageName: .intlCollectorsCardBack)
        } else {
            return ManaKit.shared.imageFromFramework(imageName: .cardBack)
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

#endif // #if canImport(UIKit)
