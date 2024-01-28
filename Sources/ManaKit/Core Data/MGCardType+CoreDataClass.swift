//
//  MGCardType+CoreDataClass.swift
//  ManaKit
//
//  Created by Vito Royeca on 12/17/21.
//

import CoreData

public class MGCardType: MGEntity {
    public var sortedChildren: [MGCardType]? {
        guard let set = children,
            let array = set.allObjects as? [MGCardType] else {
            return nil
        }
        
        let sortedArray = array.sorted { ($0.name ?? "") < ($1.name ?? "")}
        return sortedArray.isEmpty ? nil : sortedArray
    }
    
    public override var description: String {
        get {
            name ?? ""
        }
    }
}
