//
//  CMCardComponentPart+CoreDataProperties.swift
//  Pods
//
//  Created by Vito Royeca on 11/26/19.
//
//

import Foundation
import CoreData


extension CMCardComponentPart {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CMCardComponentPart> {
        return NSFetchRequest<CMCardComponentPart>(entityName: "CMCardComponentPart")
    }

    @NSManaged public var card: CMCard?
    @NSManaged public var component: CMComponent?
    @NSManaged public var part: CMCard?

}
