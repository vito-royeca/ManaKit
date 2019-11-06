//
//  Maintainer+RulingsRealm.swift
//  ManaKit_Example
//
//  Created by Vito Royeca on 11/5/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation
import ManaKit
import PromiseKit
import RealmSwift

extension Maintainer {
    private func saveRulings() -> Promise<Void> {
        return Promise { seal in
            let array = rulingsData()
            
            var count = 0
            print("Creating rulings: \(count)/\(array.count) \(Date())")
            
            try! realm.write {
                // delete existing cardRulings first
                for object in realm.objects(CMCardRuling.self) {
                    realm.delete(object)
                }
                for object in realm.objects(CMRuling.self) {
                    realm.delete(object)
                }
                
                for dict in array {
                    if let oracleID = dict["oracle_id"] as? String,
                        let publishedAt = dict["published_at"] as? String,
                        let comment = dict["comment"] as? String {
                        
                        let ruling = findRuling(withDate: publishedAt, andText: comment)
                        
                        for card in realm.objects(CMCard.self).filter("oracleID == %@", oracleID) {
                            let cardRuling = CMCardRuling()
                            
                            cardRuling.ruling = ruling
                            cardRuling.card = card
                            card.cardRulings.append(cardRuling)
                        }
                        
                        count += 1
                        if count % printMilestone == 0 {
                            print("Creating rulings: \(count)/\(array.count) \(Date())")
                        }
                    }
                }
                seal.fulfill(())
            }
        }
    }
}
