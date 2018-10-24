//
//  CMCardImageURI+CoreDataProperties.swift
//  Pods
//
//  Created by Jovito Royeca on 23/10/2018.
//
//

import Foundation
import CoreData


extension CMCardImageURI {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CMCardImageURI> {
        return NSFetchRequest<CMCardImageURI>(entityName: "CMCardImageURI")
    }

    @NSManaged public var id: String?
    @NSManaged public var type: String?
    @NSManaged public var uri: String?
    @NSManaged public var card: CMCard?

}
