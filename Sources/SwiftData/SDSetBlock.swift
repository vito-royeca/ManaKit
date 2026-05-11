//
//  SDSetBlock.swift
//  ManaKit
//
//  Created by Vito Royeca on 10/26/25.
//

import Foundation
import SwiftData

@Model
final public class SDSetBlock {
    public var code: String?
    public var name: String
    public var nameSection: String
//    public var sets: NSSet?
    
    public init(code: String? = nil,
                name: String,
                nameSection: String,
                sets: NSSet? = nil) {

        self.code = code
        self.name = name
        self.nameSection = nameSection
//        self.sets = sets
    }
}
