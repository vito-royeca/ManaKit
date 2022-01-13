//
//  MGWatermark+CoreDataProperties.swift
//  
//
//  Created by Vito Royeca on 01/08/22.
//
//

import Foundation

public struct MWatermark {

    public var name: String?
    public var nameSection: String?
//    public var cards: [MCard]?

}

// MARK: - Identifiable

extension MWatermark: MEntity {
    public var id: String {
        return name ?? ""
    }
}
