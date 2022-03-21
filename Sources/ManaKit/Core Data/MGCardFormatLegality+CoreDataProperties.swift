//
//  MGCardFormatLegality+CoreDataProperties.swift
//  
//
//  Created by Vito Royeca on 12/27/21.
//
//

import Foundation
import CoreData


extension MGCardFormatLegality {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MGCardFormatLegality> {
        return NSFetchRequest<MGCardFormatLegality>(entityName: "MGCardFormatLegality")
    }

    @NSManaged public var id: String?
    @NSManaged public var card: MGCard?
    @NSManaged public var format: MGFormat?
    @NSManaged public var legality: MGLegality?

}
