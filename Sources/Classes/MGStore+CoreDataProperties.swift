//
//  MGStore+CoreDataProperties.swift
//  Pods
//
//  Created by Vito Royeca on 12/14/19.
//
//

import Foundation
import CoreData


extension MGStore {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MGStore> {
        return NSFetchRequest<MGStore>(entityName: "MGStore")
    }

    @NSManaged public var name: String?
    @NSManaged public var nameSection: String?

}
