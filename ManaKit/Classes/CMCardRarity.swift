//
//  CMCardRarity.swift
//  Pods
//
//  Created by Jovito Royeca on 26/12/2018.
//
//

import Foundation
import RealmSwift


public class CMCardRarity: Object {

    @objc public dynamic var name: String? = nil
    @objc public dynamic var nameSection: String? = nil
    
    // MARK: Relationships
    public let cards = List<CMCard>()

    // MARK: Primary key
    override public static func primaryKey() -> String? {
        return "name"
    }

}
