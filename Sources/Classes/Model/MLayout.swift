//
//  MGLayout+CoreDataProperties.swift
//  
//
//  Created by Vito Royeca on 01/08/22.
//
//

import Foundation

public struct MLayout {

    public var description_: String?
    public var name: String?
    public var nameSection: String?
//    public var cards: [MCard]?

}

// MARK: - Identifiable

extension MLayout: MEntity {
    public var id: String {
        return name ?? ""
    }
}
