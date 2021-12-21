//
//  MGComponent+Codable.swift
//  ManaKit
//
//  Created by Vito Royeca on 12/17/21.
//

import CoreData

public class MGComponent: MGEntity {
    enum CodingKeys: CodingKey {
        case name,
             nameSection,
             componentParts
    }

    public required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
          throw DecoderConfigurationError.missingManagedObjectContext
        }

        self.init(context: context)

        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        name = try container.decodeIfPresent(String.self, forKey: .name)
        nameSection = try container.decodeIfPresent(String.self, forKey: .nameSection)
        componentParts = try container.decodeIfPresent(Set<MGCardComponentPart>.self, forKey: .componentParts) as NSSet?
    }
    
    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(name, forKey: .name)
        try container.encode(nameSection, forKey: .nameSection)
        try container.encode(componentParts as! Set<MGCardComponentPart>, forKey: .componentParts)
    }
}
