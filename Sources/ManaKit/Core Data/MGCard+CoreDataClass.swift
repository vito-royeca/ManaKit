//
//  MGCard+CoreDataClass.swift
//  ManaKit
//
//  Created by Vito Royeca on 12/16/21.
//

import CoreData

// MARK: - MGCard
public class MGCard: MGEntity {
    public var sortedColors: [MGColor]? {
        guard let set = colors,
            let array = set.allObjects as? [MGColor] else {
            return nil
        }
        
        let sortedArray = array.sorted { ($0.name ?? "") < ($1.name ?? "")}
        return sortedArray.isEmpty ? nil : sortedArray
    }
    
    public var sortedColorIdentities: [MGColor]? {
        guard let set = colorIdentities,
            let array = set.allObjects as? [MGColor] else {
            return nil
        }
        
        let sortedArray = array.sorted { ($0.name ?? "") < ($1.name ?? "")}
        return sortedArray.isEmpty ? nil : sortedArray
    }
    
    public var sortedColorIndicators: [MGColor]? {
        guard let set = colorIndicators,
            let array = set.allObjects as? [MGColor] else {
            return nil
        }
        
        let sortedArray = array.sorted { ($0.name ?? "") < ($1.name ?? "")}
        return sortedArray.isEmpty ? nil : sortedArray
    }
    
    public var sortedComponentParts: [MGCardComponentPart]? {
        guard let set = componentParts,
            let array = set.allObjects as? [MGCardComponentPart] else {
            return nil
        }
        
        let sortedArray = array.sorted { ($0.component?.name ?? "") < ($1.component?.name ?? "")}
        return sortedArray.isEmpty ? nil : sortedArray
    }
    
    public var sortedFaces: [MGCard]? {
        guard let set = faces,
            let array = set.allObjects as? [MGCard] else {
            return nil
        }
        
        let sortedArray = array.sorted { $0.faceOrder < $1.faceOrder}
        return sortedArray.isEmpty ? nil : sortedArray
    }
    
    public var sortedFormatLegalities: [MGCardFormatLegality]? {
        guard let set = formatLegalities,
            let array = set.allObjects as? [MGCardFormatLegality] else {
            return nil
        }
        
        let sortedArray = array.sorted { ($0.legality?.name ?? "") < ($1.legality?.name ?? "") }
//                               .sorted { ($0.format?.name ?? "") < ($1.format?.name ?? "") }
        return sortedArray.isEmpty ? nil : sortedArray
    }
    
    public var sortedFrameEffects: [MGFrameEffect]? {
        guard let set = frameEffects,
            let array = set.allObjects as? [MGFrameEffect] else {
            return nil
        }
        
        let sortedArray = array.sorted { ($0.name ?? "") < ($1.name ?? "")}
        return sortedArray.isEmpty ? nil : sortedArray
    }
    
    public var sortedOtherLanguages: [MGCard]? {
        guard let set = otherLanguages,
            let array = set.allObjects as? [MGCard] else {
            return nil
        }
        
        let sortedArray = array.sorted { ($0.language?.name ?? "") < ($1.language?.name ?? "")}
        return sortedArray.isEmpty ? nil : sortedArray
    }
    
    public var sortedOtherPrintings: [MGCard]? {
        guard let set = otherPrintings,
            let array = set.allObjects as? [MGCard] else {
            return nil
        }
        
        let date = Date()
        let sortedArray = array.sorted { ($0.set?.releaseDate ?? date) > ($1.set?.releaseDate ?? date) }
        return sortedArray.isEmpty ? nil : sortedArray
    }
    
    public var sortedRulings: [MGRuling]? {
        guard let set = rulings,
            let array = set.allObjects as? [MGRuling] else {
            return nil
        }
        
        let date = Date()
        let sortedArray = array.sorted { ($0.datePublished ?? date) > ($1.datePublished ?? date) }
        return sortedArray.isEmpty ? nil : sortedArray
    }
    
    public var sortedSubtypes: [MGCardType]? {
        guard let set = subtypes,
            let array = set.allObjects as? [MGCardType] else {
            return nil
        }
        
        let sortedArray = array.sorted { ($0.name ?? "") < ($1.name ?? "")}
        return sortedArray.isEmpty ? nil : sortedArray
    }
    
    public var sortedSupertypes: [MGCardType]? {
        guard let set = supertypes,
            let array = set.allObjects as? [MGCardType] else {
            return nil
        }
        
        let sortedArray = array.sorted { ($0.name ?? "") < ($1.name ?? "")}
        return sortedArray.isEmpty ? nil : sortedArray
    }
    
    public var sortedVariations: [MGCard]? {
        guard let set = variations,
            let array = set.allObjects as? [MGCard] else {
            return nil
        }
        
        let sortedArray = array.sorted { ($0.collectorNumber ?? "") < ($1.collectorNumber ?? "")}
        return sortedArray.isEmpty ? nil : sortedArray
    }
}
