//
//  ServerInfo+CoreDataProperties.swift
//  ManaKit
//
//  Created by Vito Royeca on 12/7/19.
//
//

import Foundation
import CoreData


extension ServerInfo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ServerInfo> {
        return NSFetchRequest<ServerInfo>(entityName: "ServerInfo")
    }

    @NSManaged public var id: String?
    @NSManaged public var keyruneVersion: String?
    @NSManaged public var scryfallVersion: String?

}
