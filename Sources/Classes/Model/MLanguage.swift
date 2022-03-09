//
//  MGLanguage+CoreDataProperties.swift
//  
//
//  Created by Vito Royeca on 01/08/22.
//
//

import Foundation

public struct MLanguage {

    public var code: String?
    public var displayCode: String?
    public var name: String?
    public var nameSection: String?
}

// MARK: - Identifiable

extension MLanguage: MEntity {
    public var id: String {
        return name ?? ""
    }
}
