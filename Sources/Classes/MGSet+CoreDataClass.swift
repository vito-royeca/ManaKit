//
//  MGSet+CoreDataClass.swift
//  Pods
//
//  Created by Vito Royeca on 12/14/19.
//
//

import Foundation
import CoreData

@objc(MGSet)
public class MGSet: NSManagedObject {
    public func keyruneUnicode2String() -> String? {
        var unicode:String?
        
        if let keyruneUnicode = keyruneUnicode {
            let charAsInt = Int(keyruneUnicode, radix: 16)!
            let uScalar = UnicodeScalar(charAsInt)!
            unicode = "\(uScalar)"
        } else {
            let charAsInt = Int("e684", radix: 16)!
            let uScalar = UnicodeScalar(charAsInt)!
            unicode = "\(uScalar)"
        }
        
        return unicode
    }
}
