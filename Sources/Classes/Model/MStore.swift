//
//  MGStore+CoreDataProperties.swift
//  
//
//  Created by Vito Royeca on 01/08/22.
//
//

import Foundation

public struct MStore {

    public var name: String?
    public var nameSection: String?
//    public var prices: [MCardPrice]?

}

// MARK: - Identifiable

extension MStore: MEntity {
    public var id: String {
        return name ?? ""
    }
}
