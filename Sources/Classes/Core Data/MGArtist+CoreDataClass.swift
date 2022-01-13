//
//  MGArtist+CoreDataClass.swift
//  ManaKit
//
//  Created by Vito Royeca on 12/16/21.
//

import CoreData

class MGArtist: MGEntity {
    enum CodingKeys: CodingKey {
        case firstName,
             lastName,
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
        
        // firstName
        if let firstName = try container.decodeIfPresent(String.self, forKey: .firstName),
           self.firstName != firstName {
            self.firstName = firstName
        }
        
        // lastName
        if let lastName = try container.decodeIfPresent(String.self, forKey: .lastName),
           self.lastName != lastName {
            self.lastName = lastName
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
        
//        if let cards = try container.decodeIfPresent(Set<MGCard>.self, forKey: .cards) as NSSet? {
//            addToCards(cards)
//        }
    }
    
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(firstName, forKey: .firstName)
        try container.encode(lastName, forKey: .lastName)
        try container.encode(name, forKey: .name)
        try container.encode(nameSection, forKey: .nameSection)
        if let cards = cards as? Set<MGCard> {
            try container.encode(cards, forKey: .cards)
        }
    }
    
    func toModel() -> MArtist {
        return MArtist(firstName: firstName,
                       lastName: lastName,
                       name: name,
                       nameSection: nameSection)
    }
}
