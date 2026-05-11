//
//  SDSetType.swift
//  ManaKit
//
//  Created by Vito Royeca on 10/26/25.
//

import Foundation
import SwiftData

@Model
final public class SDSetType {
    public var name: String
    public var nameSection: String
//    public var sets: NSSet?
    
    public init(name: String,
                nameSection: String,
                sets: NSSet? = nil) {

        self.name = name
        self.nameSection = nameSection
//        self.sets = sets
    }
}
