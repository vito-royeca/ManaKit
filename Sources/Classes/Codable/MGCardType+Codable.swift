//
//  MGCardType+Codable.swift
//  ManaKit
//
//  Created by Vito Royeca on 12/17/21.
//

import CoreData

public class MGCardType: NSManagedObject, Codable {
    enum CodingKeys: CodingKey {
        case name,
             nameSection,
             children,
             parent,
             subtypes,
             supertypes
    }

    public required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
          throw DecoderConfigurationError.missingManagedObjectContext
        }

        self.init(context: context)

        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        name = try container.decode(String.self, forKey: .name)
        nameSection = try container.decode(String.self, forKey: .nameSection)
        children = try container.decode(Set<MGCardType>.self, forKey: .children) as NSSet
        parent = try container.decode(MGCardType.self, forKey: .parent)
        subtypes = try container.decode(Set<MGCard>.self, forKey: .subtypes) as NSSet
        supertypes = try container.decode(Set<MGCard>.self, forKey: .supertypes) as NSSet
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(name, forKey: .name)
        try container.encode(nameSection, forKey: .nameSection)
        try container.encode(children as! Set<MGCardType>, forKey: .children)
        try container.encode(parent, forKey: .parent)
        try container.encode(subtypes as! Set<MGCard>, forKey: .subtypes)
        try container.encode(supertypes as! Set<MGCard>, forKey: .supertypes)
    }
}
