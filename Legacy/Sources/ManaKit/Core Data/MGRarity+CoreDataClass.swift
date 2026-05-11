//
//  MGRarity+CoreDataClass.swift
//  ManaKit
//
//  Created by Vito Royeca on 12/17/21.
//

import CoreData

public class MGRarity: MGEntity {
    public override var description: String {
        get {
            name ?? ""
        }
    }
}
