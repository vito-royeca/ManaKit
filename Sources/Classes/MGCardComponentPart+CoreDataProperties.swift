//
//  MGCardComponentPart+CoreDataProperties.swift
//  Pods
//
//  Created by Vito Royeca on 12/14/19.
//
//

import Foundation
import CoreData


extension MGCardComponentPart {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MGCardComponentPart> {
        return NSFetchRequest<MGCardComponentPart>(entityName: "MGCardComponentPart")
    }

    @NSManaged public var card: MGCard?
    @NSManaged public var component: MGComponent?
    @NSManaged public var part: MGCard?

}
