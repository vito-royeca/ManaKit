//
//  MGRuling+Codable.swift
//  ManaKit
//
//  Created by Vito Royeca on 12/17/21.
//

import CoreData

public class MGRuling: MGEntity {
    enum CodingKeys: CodingKey {
        case datePublished,
             id,
             oracleId,
             text
    }

    public required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
          throw DecoderConfigurationError.missingManagedObjectContext
        }

        self.init(context: context)

        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        datePublished = try container.decodeIfPresent(Date.self, forKey: .datePublished)
        id = "\(try container.decodeIfPresent(Int32.self, forKey: .id) ?? Int32(0))"
        oracleId = try container.decodeIfPresent(String.self, forKey: .oracleId)
        text = try container.decodeIfPresent(String.self, forKey: .text)
    }
    
    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(datePublished, forKey: .datePublished)
        try container.encode(id, forKey: .id)
        try container.encode(oracleId, forKey: .oracleId)
        try container.encode(text, forKey: .text)
    }
}
