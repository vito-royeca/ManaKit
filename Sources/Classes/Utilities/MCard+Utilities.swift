//
//  MCard+Utilities.swift
//  
//
//  Created by Vito Royeca on 12/27/21.
//

import Foundation
//import SwiftUI

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

extension MCard {
//    public var displayManaCost: Text {
//        get {
//            guard let manaCost = manaCost else {
//                return Text("")
//            }
//
//            return symbols(manaCost)
//        }
//    }
    
    public var displayFlavorText: String {
        get {
            guard let flavorText = flavorText else {
                return ""
            }
            
            return flavorText
        }
    }
    
    public var displayFoilPrice: String {
        get {
            for price in prices {
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
            
            return set.keyrune2Unicode()
        }
    }
    
    public var displayName: String {
        get {
            var dName = name
            
            if let language = language,
                let code = language.code {
                dName = (code == "en" ? name : printedName) ?? name
            }
            return dName ?? ""
        }
    }
    
    public var displayNormalPrice: String {
        get {
            for price in prices {
                if !price.isFoil {
                    return price.market > 0 ? String(format: "$%.2f", price.market) : "\u{2014}"
                }
            }
            
            return "\u{2014}"
        }
    }
    
//    public var displayOracleText: Text {
//        get {
//            guard let oracleText = oracleText else {
//                return Text("")
//            }
//
//            return symbols(oracleText)
//        }
//    }
    
    public var displayPowerToughness: String {
        get {
            if !(power ?? "").isEmpty || !(toughness ?? "").isEmpty {
                return "\(power ?? "")/\(toughness ?? "")"
            } else {
                return ""
            }
        }
    }
    
//    public var displayPrintedText: Text {
//        get {
//            guard let printedText = printedText else {
//                return Text("")
//            }
//
//            return symbols(printedText)
//        }
//    }
    
    public var displayTypeLine: String {
        get {
            var typeText = ""
            
            if let language = language,
                let code = language.code {
                
                typeText = code == "en" ? typeLine ?? "" : printedTypeLine ?? ""
                
                // fallback to default typeLine
                if typeText.isEmpty {
                    typeText = typeLine ?? ""
                }
            }
            
            return typeText
        }
    }
    
//    func symbols(_ text: String) -> Text {
//        if text.isEmpty {
//            return Text("")
//        }
//        
//        let trimmedText = text.trimmingCharacters(in: CharacterSet.whitespaces)
//        var array = [Any]()
//        var textFragment = ""
//        var sentinel = 0
//        
//        repeat {
//            for i in sentinel...trimmedText.count - 1 {
//                let c = trimmedText[trimmedText.index(trimmedText.startIndex, offsetBy: i)]
//                
//                if c == "{" {
//                    let code = NSMutableString()
//                    
//                    for j in i...text.count - 1 {
//                        let cc = trimmedText[trimmedText.index(trimmedText.startIndex, offsetBy: j)]
//                        code.append(String(cc))
//                        
//                        if cc == "}" {
//                            sentinel = j + 1
//                            break
//                        }
//                    }
//                    
//                    var cleanCode = code.replacingOccurrences(of: "{", with: "")
//                        .replacingOccurrences(of: "}", with: "")
//                        .replacingOccurrences(of: "/", with: "")
//                    
//                    if cleanCode.lowercased() == "chaos" {
//                        cleanCode = "Chaos"
//                    }
//                    
//                    guard let image = ManaKit.shared.symbolImage(name: cleanCode as String) else {
//                        return Text("")
//                    }
//                    var width = CGFloat(16)
//                    let height = CGFloat(16)
//                    
//                    if cleanCode == "100" {
//                        width = 35
//                    } else if cleanCode == "1000000" {
//                        width = 60
//                    }
//                    
//                    if let resizedImage = image.copy(newSize: CGSize(width: width, height: height)) {
//                        let newImage = Image(uiImage: resizedImage)
//                        if !textFragment.isEmpty {
//                            array.append(textFragment)
//                        }
//                        array.append(newImage)
//                        textFragment = ""
//                    }
//                    break
//                   
//                } else {
//                    textFragment.append(String(c))
//                    sentinel += 1
//                }
//                
//            }
//        } while sentinel <= text.count - 1
//        
//        var newString = ""
//        for a in array {
//            newString.append("\(a)")
//        }
//        return Text(newString)
//    }
}


// MARK: - Methods

extension MCard {
    public func imageURL(for type: CardImageType) -> URL? {
        guard let imageUri = imageUri else {
            return nil
        }
        
        switch type {
        case .artCrop:
            return URL(string: "\(ManaKit.shared.apiURL)/\(imageUri.artCrop ?? "")")
        case .normal:
            return URL(string: "\(ManaKit.shared.apiURL)/\(imageUri.normal ?? "")")
        case .png:
            return URL(string: "\(ManaKit.shared.apiURL)/\(imageUri.png ?? "")")
        default:
            return nil
        }
        
    }
    
    public func isModern() -> Bool {
        guard let set = set,
            let releaseDate = set.releaseDate else {
            return false
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        if let eightEditionDate = formatter.date(from: ManaKit.Constants.eightEditionRelease),
            let setReleaseDate = formatter.date(from: releaseDate) {
            return setReleaseDate.compare(eightEditionDate) == .orderedDescending ||
                setReleaseDate.compare(eightEditionDate) == .orderedSame
        }
        
        return false
    }
    
    public func keyruneColor() -> UIColor {
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
    
    public func nameFont() -> ManaKit.Font {
        if let releaseDate = set?.releaseDate {
            let isModern = isModern()
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            
            if let m15Date = formatter.date(from: "2014-07-18"),
                let setReleaseDate = formatter.date(from: releaseDate) {
                
                if setReleaseDate.compare(m15Date) == .orderedSame ||
                    setReleaseDate.compare(m15Date) == .orderedDescending {
                    return ManaKit.Fonts.magic2015
                    
                } else {
                    return isModern ? ManaKit.Fonts.eightEdition : ManaKit.Fonts.preEightEdition
                }
            }
        }
        
        return ManaKit.Fonts.magic2015
    }
    
    public func multiverseIDArray() -> [Int64] {
        guard let multiverseIds = multiverseIds else {
            return [Int64]()
        }
        
//        do {
//            let array = try NSKeyedUnarchiver.unarchivedObject(ofClass: [Int64].self, from: multiverseIds)
//            return array
//        } catch {
            return [Int64]()
//        }
        
    }
}
