//
//  MGRuling+CoreDataClass.swift
//  ManaKit
//
//  Created by Vito Royeca on 12/17/21.
//

import CoreData

public class MGRuling: MGEntity {
    public var displayDatePublished: String? {
        get {
            guard let datePublished = datePublished else {
                return nil
            }
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            
            return formatter.string(from: datePublished)
        }
    }
}
