//
//  MGFrame+CoreDataProperties.swift
//  
//
//  Created by Vito Royeca on 01/08/22.
//
//

import Foundation

public struct MFrame {

    public var description_: String?
    public var name: String?
    public var nameSection: String?
}


// MARK: - Identifiable

extension MFrame: MEntity {
    public var id: String {
        return name ?? ""
    }
}
