//
//  MGCard+CoreDataClass.swift
//  Pods
//
//  Created by Vito Royeca on 12/14/19.
//
//

import Foundation
import CoreData
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

@objc(MGCard)
public class MGCard: NSManagedObject {
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
}
