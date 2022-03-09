//
//  MGCardPrice+CoreDataProperties.swift
//  
//
//  Created by Vito Royeca on 01/08/22.
//
//

import Foundation

public struct MCardPrice: MEntity {

    public var condition: String?
    public var dateUpdated: Date?
    public var directLow: Double
    public var high: Double
    public var id: String?
    public var isFoil: Bool
    public var low: Double
    public var market: Double
    public var median: Double
    public var store: MStore?

}
