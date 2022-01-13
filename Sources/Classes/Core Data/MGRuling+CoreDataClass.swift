//
//  MGRuling+CoreDataClass.swift
//  ManaKit
//
//  Created by Vito Royeca on 12/17/21.
//

import CoreData

class MGRuling: MGEntity {
    enum CodingKeys: CodingKey {
        case datePublished,
             id,
             oracleId,
             text
    }

    required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
          throw DecoderConfigurationError.missingManagedObjectContext
        }

        self.init(context: context)

        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // datePublished
        if let datePublished = try container.decodeIfPresent(Date.self, forKey: .datePublished),
           self.datePublished != datePublished {
            self.datePublished = datePublished
        }
        
        // id
        if let id = try container.decodeIfPresent(Int32.self, forKey: .id),
           self.id != "\(id)" {
            self.id = "\(id)"
        }
        
        // oracleId
        if let oracleId = try container.decodeIfPresent(String.self, forKey: .oracleId),
           self.oracleId != oracleId {
            self.oracleId = oracleId
        }
        
        // text
        if let text = try container.decodeIfPresent(String.self, forKey: .text),
           self.text != text {
            self.text = text
        }
    }
    
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(datePublished, forKey: .datePublished)
        try container.encode(id, forKey: .id)
        try container.encode(oracleId, forKey: .oracleId)
        try container.encode(text, forKey: .text)
    }
    
    func toModel() -> MRuling {
        return MRuling(datePublished: datePublished,
                       id: id,
                       oracleId: oracleId,
                       text: text)
    }
}
