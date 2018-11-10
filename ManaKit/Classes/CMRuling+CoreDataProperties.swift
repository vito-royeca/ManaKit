//
//  CMRuling+CoreDataProperties.swift
//  Pods
//
//  Created by Jovito Royeca on 10/11/2018.
//
//

import Foundation
import CoreData


extension CMRuling {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CMRuling> {
        return NSFetchRequest<CMRuling>(entityName: "CMRuling")
    }

    @NSManaged public var date: String?
    @NSManaged public var text: String?
    @NSManaged public var cardRulings: NSSet?

}

// MARK: Generated accessors for cardRulings
extension CMRuling {

    @objc(addCardRulingsObject:)
    @NSManaged public func addToCardRulings(_ value: CMCardRuling)

    @objc(removeCardRulingsObject:)
    @NSManaged public func removeFromCardRulings(_ value: CMCardRuling)

    @objc(addCardRulings:)
    @NSManaged public func addToCardRulings(_ values: NSSet)

    @objc(removeCardRulings:)
    @NSManaged public func removeFromCardRulings(_ values: NSSet)

}
