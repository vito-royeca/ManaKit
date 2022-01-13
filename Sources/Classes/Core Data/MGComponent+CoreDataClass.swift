//
//  MGComponent+CoreDataClass.swift
//  ManaKit
//
//  Created by Vito Royeca on 12/17/21.
//

import CoreData

class MGComponent: MGEntity {
    enum CodingKeys: CodingKey {
        case name,
             nameSection,
             componentParts
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
        
        // componentParts
//        if let componentParts = try container.decodeIfPresent(Set<MGCardComponentPart>.self, forKey: .componentParts) as NSSet? {
//            self.componentParts = componentParts
//        }
    }
    
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(name, forKey: .name)
        try container.encode(nameSection, forKey: .nameSection)
        try container.encode(componentParts as! Set<MGCardComponentPart>, forKey: .componentParts)
    }
    
    func toModel() -> MComponent {
        return MComponent(name: name,
                          nameSection: nameSection,
                          componentParts: (componentParts?.allObjects as? [MGCardComponentPart] ?? []).map { $0.toModel() })
    }
}
