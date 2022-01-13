//
//  MGCardType+CoreDataClass.swift
//  ManaKit
//
//  Created by Vito Royeca on 12/17/21.
//

import CoreData

class MGCardType: MGEntity {
    enum CodingKeys: CodingKey {
        case name,
             nameSection,
             children,
             parent,
             subtypes,
             supertypes
    }

    required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
          throw DecoderConfigurationError.missingManagedObjectContext
        }

        self.init(context: context)

        let container = try decoder.container(keyedBy: CodingKeys.self)
        
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
        
        // children
//        if let children = try container.decodeIfPresent(Set<MGCardType>.self, forKey: .children) 
//            children.forEach {
//                $0.parent = self
//            }
//        }
        
        // parent
//        if let parent = try container.decodeIfPresent(MGCardType.self, forKey: .parent) {
//            self.parent = parent
//        }
        
        // subtypes
//        if let subtypes = try container.decodeIfPresent(Set<MGCard>.self, forKey: .subtypes) {
//            for subtype in self.subtypes?.allObjects as? [MGCard] ?? [] {
//                self.removeFromSubtypes(subtype)
//            }
//            addToSubtypes(subtypes as NSSet)
//        }
        
        // supertypes
//        if let supertypes = try container.decodeIfPresent(Set<MGCard>.self, forKey: .supertypes) {
//            for supertype in self.supertypes?.allObjects as? [MGCard] ?? [] {
//                self.removeFromSupertypes(supertype)
//            }
//            addToSupertypes(supertypes as NSSet)
//        }
    }
    
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(name, forKey: .name)
        try container.encode(nameSection, forKey: .nameSection)
        try container.encode(children as! Set<MGCardType>, forKey: .children)
        try container.encode(parent, forKey: .parent)
        try container.encode(subtypes as! Set<MGCard>, forKey: .subtypes)
        try container.encode(supertypes as! Set<MGCard>, forKey: .supertypes)
    }
    
    func toModel() -> MCardType {
        return MCardType(name: name,
                         nameSection: nameSection,
                         children: (children?.allObjects as? [MGCardType] ?? []).map { $0.toModel() },
                         subtypes: (subtypes?.allObjects as? [MGCardType] ?? []).map { $0.toModel() },
                         supertypes: (supertypes?.allObjects as? [MGCardType] ?? []).map { $0.toModel() })
    }
}
