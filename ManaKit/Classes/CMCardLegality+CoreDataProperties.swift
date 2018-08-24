//
//  CMCardLegality+CoreDataProperties.swift
//  ManaKit
//
//  Created by Jovito Royeca on 23.08.18.
//
//

import Foundation
import CoreData


extension CMCardLegality {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CMCardLegality> {
        return NSFetchRequest<CMCardLegality>(entityName: "CMCardLegality")
    }

    @NSManaged public var id: Int64
    @NSManaged public var card: CMCard?
    @NSManaged public var format: CMFormat?
    @NSManaged public var legality: CMLegality?

}
