//
//  MGCardComponentPart+CoreDataClass.swift
//  ManaKit
//
//  Created by Vito Royeca on 12/16/21.
//

import CoreData

public class MGCardComponentPart: MGEntity {
    enum CodingKeys: CodingKey {
        case id,
             card,
             component,
             part
    }

    public required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
          throw DecoderConfigurationError.missingManagedObjectContext
        }

        self.init(context: context)

        let container = try decoder.container(keyedBy: CodingKeys.self)
        
//        card = try container.decodeIfPresent(MGCard.self, forKey: .card)
//        component = try container.decodeIfPresent(MGComponent.self, forKey: .component)
//        part = try container.decodeIfPresent(MGCard.self, forKey: .part)
        id = "\(card?.newId ?? "")_\(component?.name ?? "")_\(part?.newId ?? "")"
    }
    
    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(card, forKey: .card)
        try container.encode(component, forKey: .component)
        try container.encode(part, forKey: .part)
    }
}
