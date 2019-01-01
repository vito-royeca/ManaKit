//
//  CMStorePricing.swift
//  Pods
//
//  Created by Jovito Royeca on 26/12/2018.
//
//

import Foundation
import RealmSwift


public class CMStorePricing: Object {

    @objc public dynamic var id: String? = nil
    @objc public dynamic var lastUpdate: Date? = nil
    @objc public dynamic var notes: String? = nil
    
    // MARK: Relationships
    public let cards = List<CMCard>()
    public let suppliers = List<CMStoreSupplier>()

    // MARK: Primary key
    override public static func primaryKey() -> String? {
        return "id"
    }

}

