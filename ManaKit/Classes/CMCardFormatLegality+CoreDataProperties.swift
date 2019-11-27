//
//  CMCardFormatLegality+CoreDataProperties.swift
//  Pods
//
//  Created by Vito Royeca on 11/26/19.
//
//

import Foundation
import CoreData


extension CMCardFormatLegality {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CMCardFormatLegality> {
        return NSFetchRequest<CMCardFormatLegality>(entityName: "CMCardFormatLegality")
    }

    @NSManaged public var card: CMCard?
    @NSManaged public var format: CMFormat?
    @NSManaged public var legality: CMLegality?

}
