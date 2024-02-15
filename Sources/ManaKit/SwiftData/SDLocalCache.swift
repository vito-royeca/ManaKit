//
//  SDLocalCache.swift
//
//
//  Created by Vito Royeca on 2/13/24.
//

import Foundation
import SwiftData

@Model
class SDLocalCache: SDEntity {
    public var lastUpdated: Date?
    public var url: String
    
    init(lastUpdated: Date? = nil,
         url: String) {
        self.lastUpdated = lastUpdated
        self.url = url
    }
}
