//
//  MGImageURI+CoreDataProperties.swift
//  
//
//  Created by Vito Royeca on 01/08/22.
//
//

import Foundation

public struct MImageURI {

    public var artCrop: String?
    public var normal: String?
    public var png: String?
}

// MARK: - Identifiable

extension MImageURI: MEntity {
    public var id: String {
        return "\(artCrop ?? "")_\(normal ?? "")_\(png ?? "")"
    }
}
