//
//  MGCard+Utilities.swift
//  
//
//  Created by Vito Royeca on 12/27/21.
//

import UIKit

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

// MARK: - Display data

extension MGCard {
    public var displayFoilPrice: String {
        get {
            for price in prices?.allObjects as? [MGCardPrice] ?? [] {
                if price.isFoil {
                    return price.market > 0 ? String(format: "$%.2f", price.market) : "\u{2014}"
                }
            }
            
            return "\u{2014}"
        }
    }
    
    public var displayKeyrune: String {
        get {
            guard let set = set else {
                return ""
            }
            
            return set.keyrune2Unicode
        }
    }
    
    public var displayName: String? {
        get {
            var text: String?
            
            if let sortedFaces = sortedFaces,
               let face = sortedFaces.first {

                if let language = language,
                   let code = language.code {

                    if code == "en" {
                        text = face.name
                    } else {
                        text = face.printedName
                    }
                } else {
                    text = face.name
                }
            } else {
                if let language = language,
                   let code = language.code {
                    
                    if code == "en" {
                        text = name
                    } else {
                        text = printedName
                    }
                } else {
                    text = printedName ?? name
                }
            }
            
            return text
        }
    }
    
    public var displayNormalPrice: String {
        get {
            for price in prices?.allObjects as? [MGCardPrice] ?? [] {
                if !price.isFoil {
                    return price.market > 0 ? String(format: "$%.2f", price.market) : "\u{2014}"
                }
            }
            
            return "\u{2014}"
        }
    }
    
    public var displayPowerToughness: String? {
        get {
            if !(power ?? "").isEmpty || !(toughness ?? "").isEmpty {
                return "\(power ?? "")/\(toughness ?? "")"
            } else {
                return nil
            }
        }
    }
    
    public var displayReleaseDate: String? {
        get {
            guard let releaseDate = releaseDate else {
                return nil
            }
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            
            return formatter.string(from: releaseDate)
        }
    }
    
    public var displayTypeLine: String? {
        get {
            var text: String?
            
            if let sortedFaces = sortedFaces,
               let face = sortedFaces.first {

                if let language = language,
                   let code = language.code {

                    if code == "en" {
                        text = face.typeLine
                    } else {
                        text = face.printedTypeLine
                    }
                } else {
                    text = face.typeLine
                }
            } else {
                if let language = language,
                   let code = language.code {
                    
                    if code == "en" {
                        text = typeLine
                    } else {
                        text = printedTypeLine
                    }
                } else {
                    text = printedTypeLine ?? typeLine
                }
            }
            
            return text
        }
    }
    
    public var newIDCopy: String {
        get {
            let cleanCollectorNumber = (collectorNumber ?? "")
                .replacingOccurrences(of: "★", with: "star")
                .replacingOccurrences(of: "†", with: "cross")
            
            return "\(set?.code ?? "")_\(language?.code ?? "")_\(cleanCollectorNumber)"
        }
    }
}


// MARK: - Methods

extension MGCard {
    public func imageURL(for type: CardImageType, faceOrder: Int = 0) -> URL? {
        guard let imageURIs = imageURIs,
            let array = imageURIs.allObjects as? [MGImageURI],
            !array.isEmpty else {
            return nil
        }
        let sortedArray = array.sorted(by: { ($0.artCrop ?? "") < ($1.artCrop ?? "") })
        
        switch type {
        case .artCrop:
            return URL(string: "\(ManaKit.shared.apiURL)/\(sortedArray[faceOrder].artCrop ?? "")")
        case .normal:
            return URL(string: "\(ManaKit.shared.apiURL)/\(sortedArray[faceOrder].normal ?? "")")
        case .png:
            return URL(string: "\(ManaKit.shared.apiURL)/\(sortedArray[faceOrder].png ?? "")")
        default:
            return nil
        }
    }
    
    public var isModern: Bool {
        get {
            guard let set = set,
                let releaseDate = set.releaseDate else {
                return false
            }
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            
            if let eightEditionDate = formatter.date(from: ManaKit.Constants.eightEditionRelease) {
                return releaseDate.compare(eightEditionDate) == .orderedDescending ||
                    releaseDate.compare(eightEditionDate) == .orderedSame
            }
            
            return false
        }
    }
    
    public var keyruneColor: UIColor {
        get {
            guard let set = set,
                let rarity = rarity else {
                return .black
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

            return color ?? .black
        }
    }
    
    public var nameFont: ManaKit.Font {
        get {
            if let releaseDate = set?.releaseDate {
                let isModern = isModern
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"
                
                if let m15Date = formatter.date(from: "2014-07-18") {
                    
                    if releaseDate.compare(m15Date) == .orderedSame ||
                        releaseDate.compare(m15Date) == .orderedDescending {
                        return ManaKit.Fonts.magic2015
                    } else {
                        return isModern ? ManaKit.Fonts.eightEdition : ManaKit.Fonts.preEightEdition
                    }
                }
            }
            
            return ManaKit.Fonts.magic2015
        }
    }
    
//    public func multiverseIDArray() -> [Int64] {
//        guard let multiverseIds = multiverseIds else {
//            return [Int64]()
//        }
        
//        do {
//            let array = try NSKeyedUnarchiver.unarchivedObject(ofClass: [Int64].self, from: multiverseIds)
//            return array
//        } catch {
//            return [Int64]()
//        }
//    }
}
