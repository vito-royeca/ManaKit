//
//  CMCardType.swift
//  Pods
//
//  Created by Jovito Royeca on 26/12/2018.
//
//

import Foundation
import RealmSwift


public class CMCardType: Object {

    @objc public dynamic var name: String? = nil
    @objc public dynamic var nameSection: String? = nil
    
    // MARK: Relationships
    public let printedTypeLines = List<CMCard>()
    public let typeLines = List<CMCard>()
    public let myTypes = List<CMCard>()
    @objc public dynamic var language: CMLanguage?

    // MARK: Primary key
    override public static func primaryKey() -> String? {
        return "name"
    }

}

