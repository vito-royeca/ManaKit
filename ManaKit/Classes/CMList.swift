//
//  CMList.swift
//  Pods
//
//  Created by Jovito Royeca on 26/12/2018.
//
//

import Foundation
import RealmSwift


public class CMList: Object {
    @objc public dynamic var createdOn: Date? = nil
    @objc public dynamic var description_: String? = nil
    @objc public dynamic var id: String? = nil
    @objc public dynamic var name: String? = nil
    @objc public dynamic var nameSection: String? = nil
    @objc public dynamic var query: Data? = nil
    @objc public dynamic var updatedOn: Date? = nil
    @objc public dynamic var views = Int64(0)
    
    // MARK: Relationships
    public let cards = List<CMInventory>()
    @objc public dynamic var user: CMUser?
    
    // MARK: Primary key
    override public static func primaryKey() -> String? {
        return "id"
    }

}
