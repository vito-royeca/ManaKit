//
//  CardTypes.swift.swift
//  ManaKit
//
//  Created by Vito Royeca on 5/5/26.
//

public enum CardType: Equatable {
    case artifact,
         battle,
         conspiracy,
         creature,
         dungeon,
         enchantment,
         instant,
         kindred,
         land,
         phenomenon,
         plane,
         planeswalker,
         scheme,
         sorcery,
         vanguard
    
    public var description: String {
        get {
            switch self {
            case .artifact: return "Artifact"
            case .battle: return "Battle"
            case .conspiracy: return "Conspiracy"
            case .creature: return "Creature"
            case .dungeon: return "Dungeon"
            case .enchantment: return "Enchantment"
            case .instant: return "Instant"
            case .kindred: return "Kindred"
            case .land: return "Land"
            case .phenomenon: return "Phenomenon"
            case .plane: return "Plane"
            case .planeswalker: return "Planeswalker"
            case .scheme: return "Scheme"
            case .sorcery: return "Sorcery"
            case .vanguard: return "Vanguard"
            }
        }
    }
}

extension String {
    public func cardTypes() -> [CardType] {
        var array = [CardType]()
        
        for type in self.split(separator: " ") {
            switch type.lowercased() {
            case "artifact": array.append(.artifact)
            case "battle": array.append(.battle)
            case "conspiracy": array.append(.conspiracy)
            case "creature": array.append(.creature)
            case "dungeon": array.append(.dungeon)
            case "enchantment": array.append(.enchantment)
            case "instant": array.append(.instant)
            case "kindred": array.append(.kindred)
            case "land": array.append(.land)
            case "phenomenon": array.append(.phenomenon)
            case "plane": array.append(.plane)
            case "planeswalker": array.append(.planeswalker)
            case "scheme": array.append(.scheme)
            case "sorcery": array.append(.sorcery)
            case "vanguard": array.append(.vanguard)
            default:
                break
            }
        }

        return array
    }
}
