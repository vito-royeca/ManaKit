//
//  CMCardRating.swift
//  Pods
//
//  Created by Jovito Royeca on 26/12/2018.
//
//

import Foundation
import RealmSwift


public class CMCardRating: Object {

    @objc public dynamic var rating = Double(0)
    
    // MARK: Relationships
    @objc public dynamic var card: CMCard?
    @objc public dynamic var user: CMUser?

}
