//
//  MArtist.swift
//  
//
//  Created by Vito Royeca on 01/08/22.
//
//

import Foundation
import CoreData

public struct MArtist {
    public var firstName: String?
    public var lastName: String?
    public var name: String?
    public var nameSection: String?
//    public var cards: [MCard]?
}

// MARK: - Identifiable

extension MArtist: MEntity {
    public var id: String {
        return name ?? ""
    }
}
