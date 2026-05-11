//
//  MGCardComponentPart+CoreDataProperties.swift
//  
//
//  Created by Vito Royeca on 12/27/21.
//
//

import Foundation
import CoreData


extension MGCardComponentPart {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MGCardComponentPart> {
        return NSFetchRequest<MGCardComponentPart>(entityName: "MGCardComponentPart")
    }

    @NSManaged public var id: String?
    @NSManaged public var card: MGCard?
    @NSManaged public var component: MGComponent?
    @NSManaged public var part: MGCard?

}
