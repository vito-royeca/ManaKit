//
//  MGSetType+CoreDataProperties.swift
//  
//
//  Created by Vito Royeca on 01/08/22.
//
//

import Foundation

public struct MSetType {

    public var name: String?
    public var nameSection: String?
//    public var sets: [MSet]?

}

// MARK: - Identifiable

extension MSetType: MEntity {
    public var id: String {
        return name ?? ""
    }
}