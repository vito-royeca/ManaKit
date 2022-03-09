//
//  MGFrameEffect+CoreDataClass.swift
//  ManaKit
//
//  Created by Vito Royeca on 12/17/21.
//

import CoreData

public class MGFrameEffect: MGEntity {
    enum CodingKeys: CodingKey {
        case description,
             id,
             name,
             nameSection,
             cards
    }

    required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
          throw DecoderConfigurationError.missingManagedObjectContext
        }

        self.init(context: context)

        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // description_
        if let description_ = try container.decodeIfPresent(String.self, forKey: .description),
           self.description_ != description_ {
            self.description_ = description_
        }
        
        // id
        if let id = try container.decodeIfPresent(String.self, forKey: .id),
           self.id != id {
            self.id = id
        }
        
        // name
        if let name = try container.decodeIfPresent(String.self, forKey: .name),
           self.name != name {
            self.name = name
        }
        
        // nameSection
        if let nameSection = try container.decodeIfPresent(String.self, forKey: .nameSection),
           self.nameSection != nameSection {
            self.nameSection = nameSection
        }
    }
    
    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(description_, forKey: .description)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(nameSection, forKey: .nameSection)
    }
    
//    func toModel() -> MFrameEffect {
//        return MFrameEffect(description_: description_,
//                            id: id,
//                            name: name,
//                            nameSection: nameSection)
//    }
}
