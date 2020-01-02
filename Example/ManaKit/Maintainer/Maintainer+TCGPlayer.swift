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
            setsModel.predicate = NSPredicate(format: "tcgplayerId > 0")
            
            firstly {
                setsModel.fetchRemoteData()
            }.compactMap { (data, result) in
                try JSONSerialization.jsonObject(with: data) as? [[String: Any]]
            }.then { data in
                self.setsModel.saveLocalData(data: data)
            }.then {
                self.setsModel.fetchLocalData()
            }.done {
                var tcgplayerIds = [Int32]()
                
                try! self.setsModel.getFetchedResultsController(with: self.setsModel.fetchRequest).performFetch()
                if let sets = self.setsModel.allObjects() as? [MGSet] {
                    tcgplayerIds = sets.map( { set in
                        set.tcgplayerId
                    })
                }
                
                seal.fulfill(tcgplayerIds)
            }.catch { error in
                self.setsModel.deleteCache()
                seal.reject(error)
            }
        }
    }
    
    func createStorePromise(name: String, connection: Connection) -> Promise<Void> {
        let nameSection = self.sectionFor(name: name) ?? "NULL"
        
        let query = "SELECT createOrUpdateStore($1,$2)"
        let parameters = [name,
                          nameSection]
        return createPromise(with: query,
                             parameters: parameters,
                             connection: connection)
    }
    
    func fetchTcgPlayerCardPricing(groupIds: [Int32], connection: Connection) -> Promise<[()->Promise<Void>]> {
        return Promise { seal in
            var array = [Promise<[()->Promise<Void>]>]()
            var promises = [()->Promise<Void>]()
            
            for groupId in groupIds {
                array.append(fetchCardPricingBy(groupId: groupId,
                                                connection: connection))
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
    
    func fetchCardPricingBy(groupId: Int32, connection: Connection) -> Promise<[()->Promise<Void>]> {
        return Promise { seal in
            guard let urlString = "http://api.tcgplayer.com/\(ManaKit.Constants.TcgPlayerApiVersion)/pricing/group/\(groupId)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
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
                        return self.createCardPricingPromise(price: result,
                                                             connection: connection)
                        
                    })
                }
                seal.fulfill(promises)
                
            }.catch { error in
                print(error)
                seal.reject(error)
            }
        }
    }
    
    func createCardPricingPromise(price: [String: Any], connection: Connection) -> Promise<Void> {
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
                             parameters: parameters,
                             connection: connection)
    }
    
//    private func getMagicCategoryId() -> Promise<Int> {
//        return Promise { seal  in
//            guard let urlString = "http://api.tcgplayer.com/\(ManaKit.Constants.TcgPlayerApiVersion)/catalog/categories?limit=\(ManaKit.Constants.TcgPlayerApiLimit)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
//                let url = URL(string: urlString) else {
//                fatalError("Malformed url")
//            }
//
//            var rq = URLRequest(url: url)
//            rq.httpMethod = "GET"
//            rq.setValue("application/json", forHTTPHeaderField: "Content-Type")
//            rq.setValue("Bearer \(tcgplayerAPIToken)", forHTTPHeaderField: "Authorization")
//
//            firstly {
//                URLSession.shared.dataTask(.promise, with:rq)
//            }.compactMap {
//                try JSONSerialization.jsonObject(with: $0.data) as? [String: Any]
//            }.done { json in
//                guard let results = json["results"] as? [[String: Any]] else {
//                    fatalError("results is nil")
//                }
//
//                for dict in results {
//                    if let categoryId = dict["categoryId"] as? Int,
//                        let name = dict["name"] as? String {
//                        if name == "Magic" {
//                            seal.fulfill(categoryId)
//                        }
//                    }
//                }
//
//            }.catch { error in
//                print("\(error)")
//                seal.reject(error)
//            }
//        }
//    }
    
//    private func getCardPurchaseUris() {
//        startActivity(name: "getCardPurchaseUris")
//
//        let request: NSFetchRequest<CMSet> = CMSet.fetchRequest()
//        request.predicate = NSPredicate(format: "tcgplayerName = nil")
//        request.sortDescriptors = [NSSortDescriptor(key: "releaseDate", ascending: true)]
//
//        var promises = [Promise<URL?>]()
//        for set in try! context.fetch(request) {
//            if let code = set.code,
//                let urlString = "https://api.scryfall.com/cards/search?q=e:\(code)&unique=prints".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
//
//            }
//        }
//
//        endActivity()
//    }

//    private func readScryfall(url: URL) -> Promise<URL?> {
//        return Promise { seal  in
//            var rq = URLRequest(url: url)
//            rq.httpMethod = "GET"
//
//            firstly {
//                URLSession.shared.dataTask(.promise, with:rq)
//            }.compactMap {
//                    try JSONSerialization.jsonObject(with: $0.data) as? [String: Any]
//            }.done { json in
//                if let data = json["data"] as? [[String: Any]] {
//                    for e in data {
//                        if let id = e["id"] as? String,
//                            let purchaseUris = [""] as? [String: Any] {
//
//                        }
//                    }
//                }
//
//                print("Scraping \(url)...")
//
//                if let hasMore = json["has_more"] as? Bool,
//                    let nextPage = json["next_page"] as? String {
//
//                    if hasMore {
//                        seal.fulfill(URL(string: nextPage)!)
//                    } else {
//                        seal.fulfill(nil)
//                    }
//                } else {
//                    seal.fulfill(nil)
//                }
//            }.catch { error in
//                seal.fulfill(nil)
//            }
//        }
//    }
    
    
}
