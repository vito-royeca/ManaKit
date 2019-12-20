//
//  MGServerInfo+CoreDataProperties.swift
//  Pods
//
//  Created by Vito Royeca on 12/14/19.
//
//

import Foundation
import CoreData


extension MGServerInfo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MGServerInfo> {
        return NSFetchRequest<MGServerInfo>(entityName: "MGServerInfo")
    }

    @NSManaged public var id: String?
    @NSManaged public var keyruneVersion: String?
    @NSManaged public var scryfallVersion: String?

}
