//
//  MGFormat+Codable.swift
//  ManaKit
//
//  Created by Vito Royeca on 12/17/21.
//

import CoreData

public class MGFormat: NSManagedObject, Codable {
    enum CodingKeys: CodingKey {
        case name,
             nameSection,
             cardFormatLegalities
    }

    public required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
          throw DecoderConfigurationError.missingManagedObjectContext
        }

        self.init(context: context)

        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        name = try container.decode(String.self, forKey: .name)
        nameSection = try container.decode(String.self, forKey: .nameSection)
        cardFormatLegalities = try container.decode(Set<MGCardFormatLegality>.self, forKey: .cardFormatLegalities) as NSSet
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(name, forKey: .name)
        try container.encode(nameSection, forKey: .nameSection)
        try container.encode(cardFormatLegalities as! Set<MGCardFormatLegality>, forKey: .cardFormatLegalities)
    }
}
