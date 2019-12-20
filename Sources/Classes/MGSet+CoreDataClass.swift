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
    public func keyruneUnicode() -> String? {
        var unicode:String?
        
        if let keyruneCode = myKeyruneCode {
            let charAsInt = Int(keyruneCode, radix: 16)!
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
