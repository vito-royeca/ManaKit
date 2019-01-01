//
//  CMCardPricing.swift
//  Pods
//
//  Created by Jovito Royeca on 26/12/2018.
//
//

import Foundation
import RealmSwift


public class CMCardPricing: Object {

    @objc public dynamic var average = Double(0)
    @objc public dynamic var foil = Double(0)
    @objc public dynamic var high = Double(0)
    @objc public dynamic var id = Int64(0)
    @objc public dynamic var lastUpdate: Date? = nil
    @objc public dynamic var link: String? = nil
    @objc public dynamic var low = Double(0)
    
    // MARK: Relationships
    public let cards = List<CMCard>()
    public let collections = List<CMCollection>()
    public let decks = List<CMDeck>()

    // MARK: Primary key
    override public static func primaryKey() -> String? {
        return "id"
    }

}

