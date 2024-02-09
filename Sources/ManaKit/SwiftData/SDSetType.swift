//
//  SDSetType.swift
//
//
//  Created by Vito Royeca on 2/8/24.
//

import SwiftData

@Model
public class SDSetType {
    // MARK: - Properties
    
    @Attribute(.unique)
    public var name: String

    public var nameSection: String?

    // MARK: - Relationships

    @Relationship(deleteRule: .nullify, inverse: \SDSet.setType)
    public var sets: [SDSet]
    
    // MARK: Initializers
    
    init(name: String,
         nameSection: String? = nil,
         sets: [SDSet]) {
        self.name = name
        self.nameSection = nameSection
        self.sets = sets
    }
}
