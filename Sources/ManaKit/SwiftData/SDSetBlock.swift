//
//  SDSetBlock.swift
//
//
//  Created by Vito Royeca on 2/8/24.
//

import SwiftData

@Model
public class SDSetBlock: SDEntity {
    // MARK: - Properties

    @Attribute(.unique)
    public var code: String

    public var name: String
    public var nameSection: String?

    // MARK: - Relationships

    @Relationship(deleteRule: .nullify, inverse: \SDSet.setBlock)
    public var sets: [SDSet]
    
    // MARK: - Initializers
    
    init(code: String,
         name: String,
         nameSection: String? = nil,
         sets: [SDSet] = []) {
        self.code = code
        self.name = name
        self.nameSection = nameSection
        self.sets = sets
    }
}
