//
//  Maintainer+Rulings.swift
//  ManaKit_Example
//
//  Created by Jovito Royeca on 14/07/2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation
import ManaKit
import PromiseKit
import RealmSwift

extension Maintainer {
    func createRulings() -> Promise<Void> {
        return Promise { seal in
            firstly {
                self.fetchRulings()
            }.then {
                self.saveRulings()
            }.done {
                seal.fulfill(())
            }.catch { error in
                seal.reject(error)
            }
        }
    }
    
    private func fetchRulings() -> Promise<Void> {
        return Promise { seal in
            guard let cachePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first else {
                fatalError("Malformed cachePath")
            }
            let rulingsPath = "\(cachePath)/\(ManaKit.Constants.ScryfallDate)_\(rulingsFileName)"
            let willFetch = !FileManager.default.fileExists(atPath: rulingsPath)
            
            if willFetch {
                guard let urlString = "https://archive.scryfall.com/json/\(rulingsFileName)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                    let url = URL(string: urlString) else {
                        fatalError("Malformed url")
                }
                var rq = URLRequest(url: url)
                rq.httpMethod = "GET"
                
                print("Fetching Scryfall rulings... \(urlString)")
                firstly {
                    URLSession.shared.dataTask(.promise, with:rq)
                    }.compactMap {
                        try JSONSerialization.jsonObject(with: $0.data) as? [[String: Any]]
                    }.done { json in
                        if let outputStream = OutputStream(toFileAtPath: rulingsPath, append: false) {
                            print("Writing Scryfall rulings... \(rulingsPath)")
                            var error: NSError?
                            outputStream.open()
                            JSONSerialization.writeJSONObject(json,
                                                              to: outputStream,
                                                              options: JSONSerialization.WritingOptions(),
                                                              error: &error)
                            outputStream.close()
                            print("Done!")
                        }
                        seal.fulfill(())
                    }.catch { error in
                        seal.reject(error)
                }
            } else {
                seal.fulfill(())
            }
        }
    }
    
    private func saveRulings() -> Promise<Void> {
        return Promise { seal in
            guard let cachePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first else {
                fatalError("Malformed cachePath")
            }
            let rulingsPath = "\(cachePath)/\(ManaKit.Constants.ScryfallDate)_\(rulingsFileName)"
            
            let data = try! Data(contentsOf: URL(fileURLWithPath: rulingsPath))
            guard let array = try! JSONSerialization.jsonObject(with: data,
                                                                options: .mutableContainers) as? [[String: Any]] else {
                                                                    fatalError("Malformed data")
            }
            
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
