//
//  MGCardType+CoreDataProperties.swift
//  
//
//  Created by Vito Royeca on 01/08/22.
//
//

import Foundation

public struct MCardType {

    public var name: String?
    public var nameSection: String?
    public var children: [MCardType]?
//    public var parent: MCardType?
    public var subtypes: [MCardType]?
    public var supertypes: [MCardType]?

}

// MARK: - Identifiable

extension MCardType: MEntity {
    public var id: String {
        return name ?? ""
    }
}
