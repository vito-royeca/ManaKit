//
//  CMRuling.swift
//  Pods
//
//  Created by Jovito Royeca on 26/12/2018.
//
//

import Foundation
import RealmSwift


public class CMRuling: Object {

    @objc public dynamic var date: String? = nil
    @objc public dynamic var text: String? = nil
    
    // MARK: Relationships
    public let cardRulings = List<CMCardRuling>()

}
