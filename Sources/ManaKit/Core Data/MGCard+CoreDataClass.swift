//
//  MGCard+CoreDataClass.swift
//  ManaKit
//
//  Created by Vito Royeca on 12/16/21.
//

import CoreData

// MARK: - MGCard
public class MGCard: MGEntity {
    public var sortedArtists: [MGArtist]? {
        guard let artists = artists,
            let array = artists.allObjects as? [MGArtist] else {
            return nil
        }
        
        let sortedArray = array.sorted { ($0.name ?? "") < ($1.name ?? "")}
        return sortedArray.isEmpty ? nil : sortedArray
    }

    public var sortedColors: [MGColor]? {
        guard let colors = colors,
            let array = colors.allObjects as? [MGColor] else {
            return nil
        }
        
        let sortedArray = array.sorted { ($0.name ?? "") < ($1.name ?? "")}
        return sortedArray.isEmpty ? nil : sortedArray
    }
    
    public var sortedColorIdentities: [MGColor]? {
        guard let colorIdentities = colorIdentities,
            let array = colorIdentities.allObjects as? [MGColor] else {
            return nil
        }
        
        let sortedArray = array.sorted { ($0.name ?? "") < ($1.name ?? "")}
        return sortedArray.isEmpty ? nil : sortedArray
    }
    
    public var sortedColorIndicators: [MGColor]? {
        guard let colorIndicators = colorIndicators,
            let array = colorIndicators.allObjects as? [MGColor] else {
            return nil
        }
        
        let sortedArray = array.sorted { ($0.name ?? "") < ($1.name ?? "")}
        return sortedArray.isEmpty ? nil : sortedArray
    }
    
    public var sortedComponentParts: [MGCardComponentPart]? {
        guard let componentParts = componentParts,
            let array = componentParts.allObjects as? [MGCardComponentPart] else {
            return nil
        }
        
        let sortedArray = array.sorted { ($0.component?.name ?? "") < ($1.component?.name ?? "")}
        return sortedArray.isEmpty ? nil : sortedArray
    }
    
    public var sectionedComponentParts: [String: [MGCardComponentPart]] {
        guard let componentParts = sortedComponentParts else {
            return [:]
        }
        
        var result = [String: [MGCardComponentPart]]()
        let keys = componentParts.map { $0.component?.name ?? "" }
        
        for key in keys {
            let values = componentParts.filter { $0.component?.name == key }
            result[key] = values
        }
        
        return result
    }
    
    public var sortedFaces: [MGCard]? {
        guard let faces = faces,
            let array = faces.allObjects as? [MGCard] else {
            return nil
        }
        
        let sortedArray = array.sorted { $0.faceOrder < $1.faceOrder}
        return sortedArray.isEmpty ? nil : sortedArray
    }
    
    public var sortedFormatLegalities: [MGCardFormatLegality]? {
        guard let formatLegalities = formatLegalities,
            let array = formatLegalities.allObjects as? [MGCardFormatLegality] else {
            return nil
        }
        
        let sortedArray = array.sorted { ($0.legality?.name ?? "") < ($1.legality?.name ?? "") }
//                               .sorted { ($0.format?.name ?? "") < ($1.format?.name ?? "") }
        return sortedArray.isEmpty ? nil : sortedArray
    }
    
    public var sortedFrameEffects: [MGFrameEffect]? {
        guard let frameEffects = frameEffects,
            let array = frameEffects.allObjects as? [MGFrameEffect] else {
            return nil
        }
        
        let sortedArray = array.sorted { ($0.name ?? "") < ($1.name ?? "")}
        return sortedArray.isEmpty ? nil : sortedArray
    }
    
    public var sortedGames: [MGGame]? {
        guard let games = games,
            let array = games.allObjects as? [MGGame] else {
            return nil
        }
        
        let sortedArray = array.sorted { ($0.name ?? "") < ($1.name ?? "")}
        return sortedArray.isEmpty ? nil : sortedArray
    }
    
    public var sortedKeywords: [MGKeyword]? {
        guard let keywords = keywords,
            let array = keywords.allObjects as? [MGKeyword] else {
            return nil
        }
        
        let sortedArray = array.sorted { ($0.name ?? "") < ($1.name ?? "")}
        return sortedArray.isEmpty ? nil : sortedArray
    }

    public var sortedOtherLanguages: [MGCard]? {
        guard let otherLanguages = otherLanguages,
            let array = otherLanguages.allObjects as? [MGCard] else {
            return nil
        }
        
        let sortedArray = array.sorted { ($0.language?.name ?? "") < ($1.language?.name ?? "")}
        return sortedArray.isEmpty ? nil : sortedArray
    }
    
    public var sortedOtherPrintings: [MGCard]? {
        guard let otherPrintings = otherPrintings,
            let array = otherPrintings.allObjects as? [MGCard] else {
            return nil
        }
        
        let date = Date()
        let sortedArray = array.sorted { ($0.set?.releaseDate ?? date) > ($1.set?.releaseDate ?? date) }
        return sortedArray.isEmpty ? nil : sortedArray
    }
    
    public var sortedRulings: [MGRuling]? {
        guard let rulings = rulings,
            let array = rulings.allObjects as? [MGRuling] else {
            return nil
        }
        
        let date = Date()
        let sortedArray = array.sorted { ($0.datePublished ?? date) > ($1.datePublished ?? date) }
        return sortedArray.isEmpty ? nil : sortedArray
    }
    
    public var sortedSubtypes: [MGCardType]? {
        guard let subtypes = subtypes,
            let array = subtypes.allObjects as? [MGCardType] else {
            return nil
        }
        
        let sortedArray = array.sorted { ($0.name ?? "") < ($1.name ?? "")}
        return sortedArray.isEmpty ? nil : sortedArray
    }
    
    public var sortedSupertypes: [MGCardType]? {
        guard let supertypes = supertypes,
            let array = supertypes.allObjects as? [MGCardType] else {
            return nil
        }
        
        let sortedArray = array.sorted { ($0.name ?? "") < ($1.name ?? "")}
        return sortedArray.isEmpty ? nil : sortedArray
    }
    
    public var sortedVariations: [MGCard]? {
        guard let variations = variations,
            let array = variations.allObjects as? [MGCard] else {
            return nil
        }
        
        let sortedArray = array.sorted { ($0.collectorNumber ?? "") < ($1.collectorNumber ?? "")}
        return sortedArray.isEmpty ? nil : sortedArray
    }
}
