//
//  MGRule+Codable.swift
//  ManaKit
//
//  Created by Vito Royeca on 12/17/21.
//

import CoreData

public class MGRule: NSManagedObject, Codable {
    enum CodingKeys: CodingKey {
        case definition,
             id,
             order,
             term,
             termSection,
             children,
             parent
    }

    public required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
          throw DecoderConfigurationError.missingManagedObjectContext
        }

        self.init(context: context)

        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        definition = try container.decode(String.self, forKey: .definition)
        id = try container.decode(Int32.self, forKey: .id)
        order = try container.decode(Double.self, forKey: .order)
        term = try container.decode(String.self, forKey: .term)
        termSection = try container.decode(String.self, forKey: .termSection)
        children = try container.decode(Set<MGRule>.self, forKey: .children) as NSSet
        parent = try container.decode(MGRule.self, forKey: .parent)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(definition, forKey: .definition)
        try container.encode(id, forKey: .id)
        try container.encode(order, forKey: .order)
        try container.encode(term, forKey: .term)
        try container.encode(termSection, forKey: .termSection)
        try container.encode(children as! Set<MGRule>, forKey: .children)
        try container.encode(parent, forKey: .parent)
    }
}
