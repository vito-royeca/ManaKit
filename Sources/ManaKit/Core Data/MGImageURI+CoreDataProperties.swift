//
//  MGImageURI+CoreDataProperties.swift
//  
//
//  Created by Vito Royeca on 12/27/21.
//
//

import Foundation
import CoreData


extension MGImageURI {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MGImageURI> {
        return NSFetchRequest<MGImageURI>(entityName: "MGImageURI")
    }

    @NSManaged public var artCrop: String?
    @NSManaged public var normal: String?
    @NSManaged public var png: String?
    @NSManaged public var card: MGCard?

}
