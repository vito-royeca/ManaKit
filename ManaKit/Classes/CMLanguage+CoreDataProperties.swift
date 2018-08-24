//
//  CMLanguage+CoreDataProperties.swift
//  Pods
//
//  Created by Jovito Royeca on 15/04/2017.
//
//

import Foundation
import CoreData


extension CMLanguage {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CMLanguage> {
        return NSFetchRequest<CMLanguage>(entityName: "CMLanguage")
    }

    @NSManaged public var name: String?
    @NSManaged public var foreignNames: NSSet?

}

// MARK: Generated accessors for foreignNames
extension CMLanguage {

    @objc(addForeignNamesObject:)
    @NSManaged public func addToForeignNames(_ value: CMForeignName)

    @objc(removeForeignNamesObject:)
    @NSManaged public func removeFromForeignNames(_ value: CMForeignName)

    @objc(addForeignNames:)
    @NSManaged public func addToForeignNames(_ values: NSSet)

    @objc(removeForeignNames:)
    @NSManaged public func removeFromForeignNames(_ values: NSSet)

}
