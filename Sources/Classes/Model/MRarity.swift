//
//  MGRarity+CoreDataProperties.swift
//  
//
//  Created by Vito Royeca on 01/08/22.
//
//

import Foundation

public struct MRarity {

    public var name: String?
    public var nameSection: String?
}

// MARK: - Identifiable

extension MRarity: MEntity {
    public var id: String {
        return name ?? ""
    }
}
