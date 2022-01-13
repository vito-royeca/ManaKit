//
//  MGComponent+CoreDataProperties.swift
//  
//
//  Created by Vito Royeca on 01/08/22.
//
//

import Foundation

public struct MComponent {

    public var name: String?
    public var nameSection: String?
    public var componentParts: [MCardComponentPart]?

}

// MARK: - Identifiable

extension MComponent: MEntity {
    public var id: String {
        return name ?? ""
    }
}
