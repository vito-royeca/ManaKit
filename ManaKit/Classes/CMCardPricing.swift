//
//  CMCardPricing.swift
//  Pods
//
//  Created by Jovito Royeca on 26/12/2018.
//
//

import Foundation
import RealmSwift


public class CMCardPricing: Object {

    
    @objc public dynamic var lowPrice = Double(0)
    @objc public dynamic var midPrice = Double(0)
    @objc public dynamic var highPrice = Double(0)
    @objc public dynamic var marketPrice = Double(0)
    @objc public dynamic var directLowPrice = Double(0)
    @objc public dynamic var isFoil = false
    
    // MARK: Relationships
    @objc public dynamic var card: CMCard?
    @objc public dynamic var collection: CMCollection?
    @objc public dynamic var deck: CMDeck?
}

