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

    required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
          throw DecoderConfigurationError.missingManagedObjectContext
        }

        self.init(context: context)

        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // condition
        if let condition = try container.decodeIfPresent(String.self, forKey: .condition),
           self.condition != condition {
            self.condition = condition
        }
        
        // dateUpdated
        if let dateUpdated = try container.decodeIfPresent(Date.self, forKey: .dateUpdated),
           self.dateUpdated != dateUpdated {
            self.dateUpdated = dateUpdated
        }
        
        // directLow
        if let directLow = try container.decodeIfPresent(Double.self, forKey: .directLow),
           self.directLow != directLow {
            self.directLow = directLow
        }
        
        // high
        if let high = try container.decodeIfPresent(Double.self, forKey: .high),
           self.high != high {
            self.high = high
        }
        
        // id
        if let id = try container.decodeIfPresent(Int32.self, forKey: .id),
           self.id != "\(id)" {
            self.id = "\(id)"
        }
        
        // isFoil
        if let isFoil = try container.decodeIfPresent(Bool.self, forKey: .isFoil),
           self.isFoil != isFoil {
            self.isFoil = isFoil
        }
        
        // low
        if let low = try container.decodeIfPresent(Double.self, forKey: .low),
           self.low != low {
            self.low = low
        }
        
        // market
        if let market = try container.decodeIfPresent(Double.self, forKey: .market),
           self.market != market {
            self.market = market
        }
        
        // median
        if let median = try container.decodeIfPresent(Double.self, forKey: .median),
           self.median != median {
            self.median = median
        }
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
    }
    
//    func toModel() -> MCardPrice {
//        return MCardPrice(condition: condition,
//                          dateUpdated: dateUpdated,
//                          directLow: directLow,
//                          high: high,
//                          id: id,
//                          isFoil: isFoil,
//                          low: low,
//                          market: market,
//                          median: median,
//                          store: store?.toModel())
//    }
}
