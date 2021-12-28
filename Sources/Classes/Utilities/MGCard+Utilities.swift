//
//  File.swift
//  
//
//  Created by Vito Royeca on 12/27/21.
//

import Foundation

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

extension MGCard {
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
}
