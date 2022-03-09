//
//  MGCardFormatLegality+CoreDataClass.swift
//  ManaKit
//
//  Created by Vito Royeca on 12/16/21.
//

import CoreData

public class MGCardFormatLegality: MGEntity {
    enum CodingKeys: CodingKey {
        case id,
             card,
             format,
             legality
    }

    required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
          throw DecoderConfigurationError.missingManagedObjectContext
        }

        self.init(context: context)

        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = "\(try container.decodeIfPresent(Int32.self, forKey: .id) ?? Int32(0))"
    }
    
    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
    }
    
//    func toModel() -> MCardFormatLegality {
//        return MCardFormatLegality(id: id,
////                                   card: card?.toModel(),
//                                   format: format?.toModel(),
//                                   legality: legality?.toModel())
//    }
}
