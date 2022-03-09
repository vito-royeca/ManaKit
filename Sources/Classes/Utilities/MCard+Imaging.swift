//
//  MCard+Imaging.swift
//  ManaKit-iOS
//
//  Created by Vito Royeca on 12/24/19.
//

//#if canImport(UIKit)

//import UIKit

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

//extension MCard {
//    public func typeImage() -> UIImage? {
//        guard let typeLine = typeLine else {
//            return nil
//        }
//
//        var types = [String]()
//        var symbolName: String?
//
//        for type in CardType.allCases {
//            let desc = type.description
//
//            for n in typeLine.components(separatedBy: " ") {
//                if n == desc && !types.contains(desc) {
//                    types.append(desc)
//                }
//            }
//        }
//
//        if types.count == 1 {
//            symbolName = types.first
//
//        } else if types.count > 1 {
//            symbolName = "Multiple"
//        }
//
//        if let symbolName = symbolName {
//            return ManaKit.shared.symbolImage(name: symbolName)
//        }
//
//        return nil
//    }
        
//    public func imageURL(type: CardImageType, faceOrder: Int) -> URL? {
//        var url:URL?
//        var urlString: String?
//
//
//        if let imageUris = imageUris,
//            let dict = NSKeyedUnarchiver.unarchiveObject(with: imageUris as Data) as? [String: String] {
//            urlString = dict[type.description]
//        } else {
//            if let faces = faces {
//                let orderedFaces = faces.sorted(by: {(a, b) -> Bool in
//                    if let a = a as? MGCard,
//                        let b = b as? MGCard {
//                        return a.faceOrder < b.faceOrder
//                    } else {
//                        return false
//                    }
//                })
//
//                if let face = orderedFaces[faceOrder] as? MGCard,
//                    let imageURIs = face.imageUris,
//                    let dict = NSKeyedUnarchiver.unarchiveObject(with: imageURIs as Data) as? [String: String] {
//                    urlString = dict[type.description]
//                }
//            }
//        }
//
//        if let urlString = urlString {
//            url = URL(string: urlString)
//        }
//
//        return url
//    }
        
//    public func backImage() -> UIImage? {
//        guard let set = set else {
//            return nil
//        }
//
//        if set.code == "ced" {
//            return ManaKit.shared.imageFromFramework(imageName: .collectorsCardBack)
//        } else if set.code == "cei" {
//            return ManaKit.shared.imageFromFramework(imageName: .intlCollectorsCardBack)
//        } else {
//            return ManaKit.shared.imageFromFramework(imageName: .cardBack)
//        }
//    }

//    public func image(type: CardImageType, faceOrder: Int, roundCornered: Bool) -> UIImage? {
//        var cardImage: UIImage?
//
////        guard let url = imageURL(type: type,
////                                 faceOrder: faceOrder) else {
////            return nil
////        }
//        let url = URL(fileURLWithPath: "")
//        
//        let imageCache = SDImageCache.init()
//        let cacheKey = url.absoluteString
//
//        cardImage = imageCache.imageFromDiskCache(forKey: cacheKey)
//
//        if roundCornered {
//            if let c = cardImage {
//                cardImage = c.roundCornered(card: self)
//            }
//        }
//
//        return cardImage
//    }
//}

//#endif // #if canImport(UIKit)
