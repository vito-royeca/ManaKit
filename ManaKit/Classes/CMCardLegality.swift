//
//  CMCardLegality.swift
//  Pods
//
//  Created by Jovito Royeca on 26/12/2018.
//
//

import Foundation
import RealmSwift


public class CMCardLegality: Object {

    // MARK: Relationships
    @objc public dynamic var card: CMCard?
    @objc public dynamic var format: CMCardFormat?
    @objc public dynamic var legality: CMLegality?

}
