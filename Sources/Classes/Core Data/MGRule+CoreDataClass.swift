//
//  MGRule+CoreDataClass.swift
//  ManaKit
//
//  Created by Vito Royeca on 12/17/21.
//

import CoreData

public class MGRule: MGEntity {
    enum CodingKeys: CodingKey {
        case definition,
             id,
             order,
             term,
             termSection,
             children,
             parent
    }

    required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
          throw DecoderConfigurationError.missingManagedObjectContext
        }

        self.init(context: context)

        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // definition
        if let definition = try container.decodeIfPresent(String.self, forKey: .definition),
           self.definition != definition {
            self.definition = definition
        }
        
        // id
        if let id = try container.decodeIfPresent(Int32.self, forKey: .id),
           self.id != "\(id)" {
            self.id = "\(id)"
        }
        
        // order
        if let order = try container.decodeIfPresent(Double.self, forKey: .order),
           self.order != order {
            self.order = order
        }
        
        // term
        if let term = try container.decodeIfPresent(String.self, forKey: .term),
           self.term != term {
            self.term = term
        }
        
        // termSection
        if let termSection = try container.decodeIfPresent(String.self, forKey: .termSection),
           self.termSection != termSection {
            self.termSection = termSection
        }
        
        // children
        if let children = try container.decodeIfPresent(Set<MGRule>.self, forKey: .children),
           !children.isEmpty {
            for child in self.children?.allObjects as? [MGRule] ?? [] {
                self.removeFromChildren(child)
            }
            
            children.forEach {
                $0.parent = self
            }
            addToChildren(children as NSSet)
        }
        
        // parent
//        if let parent = try container.decodeIfPresent(MGRule.self, forKey: .parent) {
//            self.parent = parent
//        }
    }
    
    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(definition, forKey: .definition)
        try container.encode(id, forKey: .id)
        try container.encode(order, forKey: .order)
        try container.encode(term, forKey: .term)
        try container.encode(termSection, forKey: .termSection)
    }
    
//    func toModel() -> MRule {
//        return MRule(definition: definition,
//                     id: id,
//                     order: order,
//                     term: term,
//                     termSection: termSection,
//                     children: (children?.allObjects as? [MGRule] ?? []).map { $0.toModel() })
//    }
}
