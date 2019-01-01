//
//  CMDeck.swift
//  Pods
//
//  Created by Jovito Royeca on 26/12/2018.
//
//

import Foundation
import RealmSwift


public class CMDeck: Object {

    @objc public dynamic var colors: String? = nil
    @objc public dynamic var createdOn: Date? = nil
    @objc public dynamic var description_: String? = nil
    @objc public dynamic var id: String? = nil
    @objc public dynamic var mainboard = Int32(0)
    @objc public dynamic var name: String? = nil
    @objc public dynamic var nameSection: String? = nil
    @objc public dynamic var originalCreator: String? = nil
    @objc public dynamic var sideboard = Int32(0)
    @objc public dynamic var updatedOn: Date? = nil
    @objc public dynamic var views = Int64(0)
    
    // MARK: Relationships
    public let cards = List<CMInventory>()
    @objc public dynamic var format: CMCardFormat?
    @objc public dynamic var heroCard: CMCard?
    @objc public dynamic var pricing: CMCardPricing?
    @objc public dynamic var user: CMUser?
    
    // MARK: Primary key
    override public static func primaryKey() -> String? {
        return "id"
    }

}
