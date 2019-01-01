//
//  CMCardColor.swift
//  Pods
//
//  Created by Jovito Royeca on 26/12/2018.
//
//

import Foundation
import RealmSwift


public class CMCardColor: Object {
    @objc public dynamic var name: String? = nil
    @objc public dynamic var symbol: String? = nil
    
    // MARK: Relationships
    public let colors = LinkingObjects(fromType: CMCard.self, property: "colors")
    public let colorIdentities = LinkingObjects(fromType: CMCard.self, property: "colorIdentities")
    public let colorIndicators = LinkingObjects(fromType: CMCard.self, property: "colorIndicators")

    // MARK: Primary key
    override public static func primaryKey() -> String? {
        return "name"
    }

}

