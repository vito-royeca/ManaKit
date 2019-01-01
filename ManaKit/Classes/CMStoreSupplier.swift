//
//  CMStoreSupplier.swift
//  Pods
//
//  Created by Jovito Royeca on 26/12/2018.
//
//

import Foundation
import RealmSwift


public class CMStoreSupplier: Object {

    @objc public dynamic var condition: String? = nil
    @objc public dynamic var id: String? = nil
    @objc public dynamic var link: String? = nil
    @objc public dynamic var name: String? = nil
    @objc public dynamic var price = Double(0)
    @objc public dynamic var qty = Int32(0)
    
    // MARK: Relationships
    @objc public dynamic var storePricing: CMStorePricing?

    // MARK: Primary key
    override public static func primaryKey() -> String? {
        return "id"
    }

}
