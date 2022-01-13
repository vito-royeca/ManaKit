//
//  MGColor+CoreDataProperties.swift
//  
//
//  Created by Vito Royeca on 01/08/22.
//
//

import Foundation

public struct MColor {

    public var name: String?
    public var nameSection: String?
    public var symbol: String?
//    public var cards: [MCard]?
//    public var identities: [MColor]?
//    public var indicators: [MColor]?

}

// MARK: - Identifiable

extension MColor: MEntity {
    public var id: String {
        return name ?? ""
    }
}

