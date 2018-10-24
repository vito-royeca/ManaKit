//
//  CMCardInventory+CoreDataProperties.swift
//  Pods
//
//  Created by Jovito Royeca on 23/10/2018.
//
//

import Foundation
import CoreData


extension CMCardInventory {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CMCardInventory> {
        return NSFetchRequest<CMCardInventory>(entityName: "CMCardInventory")
    }

    @NSManaged public var acquiredFrom: String?
    @NSManaged public var acquisitionPrice: Double
    @NSManaged public var condition: String?
    @NSManaged public var dateAcquired: NSDate?
    @NSManaged public var foil: Bool
    @NSManaged public var mainboard: Bool
    @NSManaged public var notes: String?
    @NSManaged public var quantity: Int32
    @NSManaged public var sideboard: Bool
    @NSManaged public var card: CMCard?
    @NSManaged public var collection: CMCollection?
    @NSManaged public var deck: CMDeck?
    @NSManaged public var list: CMList?

}
