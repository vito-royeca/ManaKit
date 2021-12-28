//
//  MGCardPrice+CoreDataClass.swift
//  ManaKit
//
//  Created by Vito Royeca on 12/17/21.
//

import CoreData

public class MGCardPrice: MGEntity {
    enum CodingKeys: CodingKey {
        case condition,
             dateUpdated,
             directLow,
             high,
             id,
             isFoil,
             low,
             market,
             median/*,
             card,
             store*/
    }

    public required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
          throw DecoderConfigurationError.missingManagedObjectContext
        }

        self.init(context: context)

        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        condition = try container.decodeIfPresent(String.self, forKey: .condition)
        dateUpdated = try container.decodeIfPresent(Date.self, forKey: .dateUpdated)
        directLow = try container.decodeIfPresent(Double.self, forKey: .directLow) ?? Double(0)
        high = try container.decodeIfPresent(Double.self, forKey: .high) ?? Double(0)
        id = "\(try container.decodeIfPresent(Int32.self, forKey: .id) ?? Int32(0))"
        isFoil = try container.decodeIfPresent(Bool.self, forKey: .isFoil) ?? false
        low = try container.decodeIfPresent(Double.self, forKey: .low) ?? Double(0)
        market = try container.decodeIfPresent(Double.self, forKey: .market) ?? Double(0)
        median = try container.decodeIfPresent(Double.self, forKey: .median) ?? Double(0)
        //card = try container.decodeIfPresent(MGCard.self, forKey: .card)
//        store = try container.decodeIfPresent(MGStore.self, forKey: .store)
    }
    
    public override func encode(to encoder: Encoder) throws {
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
        //try container.encode(card, forKey: .card)
//        try container.encode(store, forKey: .store)
    }
}
