//
//  CMCardInventory+CoreDataProperties.swift
//  ManaKit
//
//  Created by Jovito Royeca on 23.08.18.
//
//

import Foundation
import CoreData


extension CMCardInventory {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CMCardInventory> {
        return NSFetchRequest<CMCardInventory>(entityName: "CMCardInventory")
    }

    @NSManaged public var condition: String?
    @NSManaged public var foil: Bool
    @NSManaged public var mainboard: Bool
    @NSManaged public var sideboard: Bool
    @NSManaged public var quantity: Int32
    @NSManaged public var notes: String?
    @NSManaged public var dateAcquired: NSDate?
    @NSManaged public var acquisitionPrice: Double
    @NSManaged public var acquiredFrom: String?
    @NSManaged public var card: CMCard?
    @NSManaged public var deck: CMDeck?
    @NSManaged public var list: CMList?

}
