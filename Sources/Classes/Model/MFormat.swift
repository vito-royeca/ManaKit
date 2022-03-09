//
//  MGFormat+CoreDataProperties.swift
//  
//
//  Created by Vito Royeca on 01/08/22.
//
//

import Foundation

public struct MFormat {

    public var name: String?
    public var nameSection: String?
}

// MARK: - Identifiable

extension MFormat: MEntity {
    public var id: String {
        return name ?? ""
    }
}
