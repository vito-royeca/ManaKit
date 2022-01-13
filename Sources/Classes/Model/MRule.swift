//
//  MGRule+CoreDataProperties.swift
//  
//
//  Created by Vito Royeca on 01/08/22.
//
//

import Foundation

public struct MRule: MEntity {

    public var definition: String?
    public var id: String?
    public var order: Double
    public var term: String?
    public var termSection: String?
    public var children: [MRule]?
//    public var parent: MRule?

}
