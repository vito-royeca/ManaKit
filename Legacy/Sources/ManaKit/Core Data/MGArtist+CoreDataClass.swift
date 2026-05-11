//
//  MGArtist+CoreDataClass.swift
//  ManaKit
//
//  Created by Vito Royeca on 12/16/21.
//

import CoreData

public class MGArtist: MGEntity {
    public override var description: String {
        get {
            name ?? ""
        }
    }
}
