//
//  Maintainer+TCGPlayer.swift
//  ManaKit_Example
//
//  Created by Jovito Royeca on 23/10/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import ManaKit
import PostgresClientKit
import PromiseKit

extension Maintainer {
    func getTcgPlayerToken() -> Promise<Void> {
        return Promise { seal  in
            guard let urlString = "https://api.tcgplayer.com/token".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                let url = URL(string: urlString) else {
                fatalError("Malformed url")
            }
            let query = "grant_type=client_credentials&client_id=\(ManaKit.Constants.TcgPlayerPublicKey)&client_secret=\(ManaKit.Constants.TcgPlayerPrivateKey)"
            
            var rq = URLRequest(url: url)
            rq.httpMethod = "POST"
            rq.setValue("application/json", forHTTPHeaderField: "Content-Type")
            rq.httpBody = query.data(using: .utf8)
            
            firstly {
                URLSession.shared.dataTask(.promise, with: rq)
            }.compactMap {
                try JSONSerialization.jsonObject(with: $0.data) as? [String: Any]
            }.done { json in
                guard let token = json["access_token"] as? String else {
                    fatalError("access_token is nil")
                }
                
                self.tcgplayerAPIToken = token
                seal.fulfill(())
            }.catch { error in
                print("\(error)")
                seal.reject(error)
            }
        }
    }
    
    func fetchSets() -> Promise<[Int32]> {
        return Promise { seal in
            seal.fulfill([Int32]())
//            setsModel.predicate = NSPredicate(format: "tcgplayerId > 0")
//
//            firstly {
//                setsModel.fetchRemoteData()
//            }.compactMap { (data, result) in
//                try JSONSerialization.jsonObject(with: data) as? [[String: Any]]
//            }.then { data in
//                self.setsModel.saveLocalData(data: data)
//            }.then {
//                self.setsModel.fetchLocalData()
//            }.done {
//                var tcgplayerIds = [Int32]()
//
//                try! self.setsModel.getFetchedResultsController(with: self.setsModel.fetchRequest).performFetch()
//                if let sets = self.setsModel.allObjects() as? [MGSet] {
//                    tcgplayerIds = sets.map( { set in
//                        set.tcgplayerId
//                    })
//                }
//
//                seal.fulfill(tcgplayerIds)
//            }.catch { error in
//                self.setsModel.deleteCache()
//                seal.reject(error)
//            }
        }
    }
    
    func createStorePromise(name: String) -> Promise<Void> {
        let nameSection = self.sectionFor(name: name) ?? "NULL"
        
        let query = "SELECT createOrUpdateStore($1,$2)"
        let parameters = [name,
                          nameSection]
        return createPromise(with: query,
                             parameters: parameters)
    }
    
    func fetchTcgPlayerCardPricing(groupIds: [Int32]) -> Promise<[()->Promise<Void>]> {
        return Promise { seal in
            var array = [Promise<[()->Promise<Void>]>]()
            var promises = [()->Promise<Void>]()
            
            for groupId in groupIds {
                array.append(fetchCardPricingBy(groupId: groupId))
            }
            
            firstly {
                when(fulfilled: array)
            }.done { results in
                for result in results {
                    promises.append(contentsOf: result)
                }
                seal.fulfill(promises)
            }.catch { error in
                seal.reject(error)
            }
        }
    }
    
    func fetchCardPricingBy(groupId: Int32) -> Promise<[()->Promise<Void>]> {
        return Promise { seal in
            guard let urlString = "https://api.tcgplayer.com/\(ManaKit.Constants.TcgPlayerApiVersion)/pricing/group/\(groupId)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                let url = URL(string: urlString) else {
                fatalError("Malformed url")
            }
            
            var rq = URLRequest(url: url)
            rq.httpMethod = "GET"
            rq.setValue("application/json", forHTTPHeaderField: "Content-Type")
            rq.setValue("Bearer \(tcgplayerAPIToken)", forHTTPHeaderField: "Authorization")
            
            firstly {
                URLSession.shared.dataTask(.promise, with:rq)
            }.compactMap {
                try JSONSerialization.jsonObject(with: $0.data) as? [String: Any]
            }.done { json in
                guard let results = json["results"] as? [[String: Any]] else {
                    fatalError("results is nil")
                }
                var promises = [()->Promise<Void>]()
                
                for result in results {
                    
                    promises.append({
                        return self.createCardPricingPromise(price: result)
                        
                    })
                }
                seal.fulfill(promises)
                
            }.catch { error in
                print(error)
                seal.reject(error)
            }
        }
    }
    
    func createCardPricingPromise(price: [String: Any]) -> Promise<Void> {
        let low = price["lowPrice"] as? Double ?? 0.0
        let median = price["midPrice"] as? Double ?? 0.0
        let high = price["highPrice"] as? Double ?? 0.0
        let market = price["marketPrice"] as? Double ?? 0.0
        let directLow = price["directLowPrice"] as? Double ?? 0.0
        let tcgPlayerId = price["productId"]  as? Int ?? 0
        let cmstore = self.storeName
        let isFoil = price["subTypeName"] as? String ?? "Foil" == "Foil" ? true : false
        
        let query = "SELECT createOrUpdateCardPrice($1,$2,$3,$4,$5,$6,$7,$8)"
        let parameters = [
            low,
            median,
            high,
            market,
            directLow,
            tcgPlayerId,
            cmstore,
            isFoil
            ] as [Any]
        
        return createPromise(with: query,
                             parameters: parameters)
    }
}
