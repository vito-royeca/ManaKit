//
//  CMCardLegality+CoreDataProperties.swift
//  Pods
//
//  Created by Jovito Royeca on 10/11/2018.
//
//

import Foundation
import CoreData


extension CMCardLegality {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CMCardLegality> {
        return NSFetchRequest<CMCardLegality>(entityName: "CMCardLegality")
    }

    @NSManaged public var card: CMCard?
    @NSManaged public var format: CMCardFormat?
    @NSManaged public var legality: CMLegality?

}
