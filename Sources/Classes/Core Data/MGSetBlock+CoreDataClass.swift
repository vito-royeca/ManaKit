//
//  MGSetBlock+CoreDataClass.swift
//  ManaKit
//
//  Created by Vito Royeca on 12/17/21.
//

import CoreData

class MGSetBlock: MGEntity {
    enum CodingKeys: CodingKey {
        case code,
             name,
             nameSection,
             sets
    }

    required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
          throw DecoderConfigurationError.missingManagedObjectContext
        }

        self.init(context: context)

        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // code
        if let code = try container.decodeIfPresent(String.self, forKey: .code),
           self.code != code {
            self.code = code
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
        
        // sets
//        if let sets = try container.decodeIfPresent(Set<MGSet>.self, forKey: .sets) {
//            for set in self.sets?.allObjects as? [MGSet] ?? [] {
//                self.removeFromSets(set)
//            }
//            addToSets(sets as NSSet)
//            
//            sets.forEach {
//                $0.setBlock = self
//            }
//        }
    }
    
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(code, forKey: .code)
        try container.encode(name, forKey: .name)
        try container.encode(nameSection, forKey: .nameSection)
        if let sets = sets as? Set<MGSet> {
            try container.encode(sets, forKey: .sets)
        }
    }
    
    func toModel() -> MSetBlock {
        return MSetBlock(code: code,
                         name: name,
                         nameSection: nameSection)
    }
}
