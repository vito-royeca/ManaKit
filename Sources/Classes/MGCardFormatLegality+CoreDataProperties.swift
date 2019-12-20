//
//  MGCardFormatLegality+CoreDataProperties.swift
//  Pods
//
//  Created by Vito Royeca on 12/14/19.
//
//

import Foundation
import CoreData


extension MGCardFormatLegality {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MGCardFormatLegality> {
        return NSFetchRequest<MGCardFormatLegality>(entityName: "MGCardFormatLegality")
    }

    @NSManaged public var card: MGCard?
    @NSManaged public var format: MGFormat?
    @NSManaged public var legality: MGLegality?

}
