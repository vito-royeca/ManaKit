//
//  MGImageURI+CoreDataClass.swift
//  ManaKit
//
//  Created by Vito Royeca on 12/22/21.
//

import CoreData

public class MGImageURI: MGEntity {
    enum CodingKeys: CodingKey {
        case artCrop,
             normal,
             png,
             card
    }

    public required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
          throw DecoderConfigurationError.missingManagedObjectContext
        }

        self.init(context: context)

        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        artCrop = try container.decodeIfPresent(String.self, forKey: .artCrop)
        normal = try container.decodeIfPresent(String.self, forKey: .normal)
        png = try container.decodeIfPresent(String.self, forKey: .png)
        card = try container.decodeIfPresent(MGCard.self, forKey: .card)
    }
    
    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(artCrop, forKey: .artCrop)
        try container.encode(normal, forKey: .normal)
        try container.encode(png, forKey: .png)
        if let card = card {
            try container.encode(card, forKey: .card)
        }
    }
}
