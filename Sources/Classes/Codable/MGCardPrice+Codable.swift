//
//  MGCardPrice+Codable.swift
//  ManaKit
//
//  Created by Vito Royeca on 12/17/21.
//

import CoreData

public class MGCardPrice: NSManagedObject, Codable {
    enum CodingKeys: CodingKey {
        case condition,
             dateUpdated,
             directLow,
             high,
             id,
             isFoil,
             low,
             market,
             median,
             card,
             store
    }

    public required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
          throw DecoderConfigurationError.missingManagedObjectContext
        }

        self.init(context: context)

        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        condition = try container.decode(String.self, forKey: .condition)
        dateUpdated = try container.decode(Date.self, forKey: .dateUpdated)
        directLow = try container.decode(Double.self, forKey: .directLow)
        high = try container.decode(Double.self, forKey: .high)
        id = try container.decode(Int32.self, forKey: .id)
        isFoil = try container.decode(Bool.self, forKey: .isFoil)
        low = try container.decode(Double.self, forKey: .low)
        market = try container.decode(Double.self, forKey: .market)
        median = try container.decode(Double.self, forKey: .median)
        card = try container.decode(MGCard.self, forKey: .card)
        store = try container.decode(MGStore.self, forKey: .store)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(condition, forKey: .condition)
        try container.encode(dateUpdated, forKey: .dateUpdated)
        try container.encode(directLow, forKey: .directLow)
        try container.encode(high, forKey: .high)
        try container.encode(id, forKey: .id)
        try container.encode(isFoil, forKey: .isFoil)
        try container.encode(low, forKey: .low)
        try container.encode(market, forKey: .market)
        try container.encode(median, forKey: .median)
        try container.encode(card, forKey: .card)
        try container.encode(store, forKey: .store)
    }
}
