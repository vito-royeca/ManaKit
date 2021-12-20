//
//  MGCardFormatLegality+Codable.swift
//  ManaKit
//
//  Created by Vito Royeca on 12/16/21.
//

import CoreData

public class MGCardFormatLegality: NSManagedObject, Codable {
    enum CodingKeys: CodingKey {
        case id,
             card,
             format,
             legality
    }

    public required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
          throw DecoderConfigurationError.missingManagedObjectContext
        }

        self.init(context: context)

        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decodeIfPresent(Int32.self, forKey: .id) ?? Int32(0)
        card = try container.decodeIfPresent(MGCard.self, forKey: .card)
        format = try container.decodeIfPresent(MGFormat.self, forKey: .format)
        legality = try container.decodeIfPresent(MGLegality.self, forKey: .legality)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(card, forKey: .card)
        try container.encode(format, forKey: .format)
        try container.encode(legality, forKey: .legality)
    }
}
