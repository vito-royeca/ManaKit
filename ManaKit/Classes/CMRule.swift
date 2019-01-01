//
//  CMRule.swift
//  Pods
//
//  Created by Jovito Royeca on 26/12/2018.
//
//

import Foundation
import RealmSwift


public class CMRule: Object {

    @objc public dynamic var definition: String? = nil
    @objc public dynamic var order = Double(0)
    @objc public dynamic var term: String? = nil
    @objc public dynamic var termSection: String? = nil
    
    // MARK: Relationships
    public let children = List<CMRule>()
    @objc public dynamic var parent: CMRule?

}

