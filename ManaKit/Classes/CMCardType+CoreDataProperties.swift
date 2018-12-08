//
//  CMCardType+CoreDataProperties.swift
//  Pods
//
//  Created by Jovito Royeca on 10/11/2018.
//
//

import Foundation
import CoreData


extension CMCardType {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CMCardType> {
        return NSFetchRequest<CMCardType>(entityName: "CMCardType")
    }

    @NSManaged public var name: String?
    @NSManaged public var nameSection: String?
    @NSManaged public var printedTypeLines: NSSet?
    @NSManaged public var typeLines: NSSet?
    @NSManaged public var myTypes: NSSet?
    @NSManaged public var language: CMLanguage?

}

// MARK: Generated accessors for cardPrintedTypes
extension CMCardType {

    @objc(addPrintedTypeLinesObject:)
    @NSManaged public func addToPrintedTypeLines(_ value: CMCard)

    @objc(removePrintedTypeLinesObject:)
    @NSManaged public func removeFromPrintedTypeLines(_ value: CMCard)

    @objc(addPrintedTypeLines:)
    @NSManaged public func addToPrintedTypeLines(_ values: NSSet)

    @objc(removePrintedTypes:)
    @NSManaged public func removeFromPrintedTypeLines(_ values: NSSet)

}

// MARK: Generated accessors for cardTypeLines
extension CMCardType {
    
    @objc(addTypeLinesObject:)
    @NSManaged public func addToTypeLines(_ value: CMCard)
    
    @objc(removeTypeLinesObject:)
    @NSManaged public func removeFromTypeLines(_ value: CMCard)
    
    @objc(addTypeLines:)
    @NSManaged public func addToTypeLines(_ values: NSSet)
    
    @objc(removeTypeLines:)
    @NSManaged public func removeFromTypeLines(_ values: NSSet)
    
}

// MARK: Generated accessors for cardTypeLines
extension CMCardType {

    @objc(addMyTypesObject:)
    @NSManaged public func addToMyTypes(_ value: CMCard)

    @objc(removeMyTypesObject:)
    @NSManaged public func removeFromMyTypes(_ value: CMCard)

    @objc(addMyTypes:)
    @NSManaged public func addToMyTypes(_ values: NSSet)

    @objc(removeMyTypes:)
    @NSManaged public func removeFromMyTypes(_ values: NSSet)

}
