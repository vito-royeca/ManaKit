//
//  CMInventory.swift
//  Pods
//
//  Created by Jovito Royeca on 26/12/2018.
//
//

import Foundation
import RealmSwift


public class CMInventory: Object {

    @objc public dynamic var acquiredFrom: String? = nil
    @objc public dynamic var acquisitionPrice = Double(0)
    @objc public dynamic var condition: String? = nil
    @objc public dynamic var dateAcquired: Date? = nil
    @objc public dynamic var isFoil = false
    @objc public dynamic var isMainboard = false
    @objc public dynamic var notes: String? = nil
    @objc public dynamic var quantity = Int32(0)
    @objc public dynamic var isSideboard = false
    
    // MARK: Relationships
    @objc public dynamic var card: CMCard?
    @objc public dynamic var collection: CMCollection?
    @objc public dynamic var deck: CMDeck?
    @objc public dynamic var list: CMList?

}
