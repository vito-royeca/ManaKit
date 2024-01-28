//
//  MGKeyword+CoreDataClass.swift
//
//
//  Created by Vito Royeca on 12/13/23.
//

import CoreData

public class MGKeyword: MGEntity {
    public override var description: String {
        get {
            name ?? ""
        }
    }
}
