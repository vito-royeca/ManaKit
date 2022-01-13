//
//  MGImageURI+CoreDataClass.swift
//  ManaKit
//
//  Created by Vito Royeca on 12/22/21.
//

import CoreData

class MGImageURI: MGEntity {
    enum CodingKeys: CodingKey {
        case artCrop,
             normal,
             png,
             card
    }

    required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
          throw DecoderConfigurationError.missingManagedObjectContext
        }

        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.init(context: context)

        // artCrop
        if let artCrop = try container.decodeIfPresent(String.self, forKey: .artCrop),
           self.artCrop != artCrop {
            self.artCrop = artCrop
        }
        
        // normal
        if let normal = try container.decodeIfPresent(String.self, forKey: .normal),
           self.normal != normal {
            self.normal = normal
        }
        
        // png
        if let png = try container.decodeIfPresent(String.self, forKey: .png),
           self.png != png {
            self.png = png
        }
        
        // card
//        if let card = try container.decodeIfPresent(MGCard.self, forKey: .card) {
//            self.card = card
//        }
    }
    
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(artCrop, forKey: .artCrop)
        try container.encode(normal, forKey: .normal)
        try container.encode(png, forKey: .png)
        if let card = card {
            try container.encode(card, forKey: .card)
        }
    }
    
    func toModel() -> MImageURI {
        return MImageURI(artCrop: artCrop,
                         normal: normal,
                         png: png)
    }
}
