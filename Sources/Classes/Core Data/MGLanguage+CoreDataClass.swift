//
//  MGLanguage+CoreDataClass.swift
//  ManaKit
//
//  Created by Vito Royeca on 12/17/21.
//

import CoreData

class MGLanguage: MGEntity {
    enum CodingKeys: CodingKey {
        case code,
             displayCode,
             name,
             nameSection,
             cards,
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
        
        // displayCode
        if let displayCode = try container.decodeIfPresent(String.self, forKey: .displayCode),
           self.displayCode != displayCode {
            self.displayCode = displayCode
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
        
//        if let cards = try container.decodeIfPresent(Set<MGCard>.self, forKey: .cards) {
//            for card in self.cards?.allObjects as? [MGCard] ?? [] {
//                self.removeFromCards(card)
//            }
//            addToCards(cards as NSSet)
//            
//            cards.forEach {
//                $0.language = self
//            }
//        }
//
//        if let sets = try container.decodeIfPresent(Set<MGSet>.self, forKey: .sets) {
//            for set in self.sets?.allObjects as? [MGSet] ?? [] {
//                self.removeFromSets(set)
//            }
//            addToSets(sets as NSSet)
//            
//            sets.forEach {
//                $0.addToLanguages(self)
//            }
//        }
    }
    
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(code, forKey: .code)
        try container.encode(displayCode, forKey: .displayCode)
        try container.encode(name, forKey: .name)
        try container.encode(nameSection, forKey: .nameSection)
        if let cards = cards as? Set<MGCard> {
            try container.encode(cards, forKey: .cards)
        }
        if let sets = sets as? Set<MGSet> {
            try container.encode(sets, forKey: .sets)
        }
    }
    
    func toModel() -> MLanguage {
        return MLanguage(code: code,
                         displayCode: displayCode,
                         name: name,
                         nameSection: nameSection)
    }
}
