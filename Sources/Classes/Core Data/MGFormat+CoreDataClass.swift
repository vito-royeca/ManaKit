//
//  MGFormat+CoreDataClass.swift
//  ManaKit
//
//  Created by Vito Royeca on 12/17/21.
//

import CoreData

class MGFormat: MGEntity {
    enum CodingKeys: CodingKey {
        case name,
             nameSection,
             cardFormatLegalities
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
        
        // cardFormatLegalities
//        if let cardFormatLegalities = try container.decodeIfPresent(Set<MGCardFormatLegality>.self, forKey: .cardFormatLegalities) as NSSet? {
//            self.cardFormatLegalities = cardFormatLegalities
//        }
    }
    
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(name, forKey: .name)
        try container.encode(nameSection, forKey: .nameSection)
        try container.encode(cardFormatLegalities as! Set<MGCardFormatLegality>, forKey: .cardFormatLegalities)
    }
    
    func toModel() -> MFormat {
        return MFormat(name: name,
                       nameSection: nameSection)
    }
}
