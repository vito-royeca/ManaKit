//
//  ManaKit+TcgPlayer.swift
//  Pods
//
//  Created by Vito Royeca on 11/27/19.
//

import Foundation
import PromiseKit

extension ManaKit {
    public func authenticateTcgPlayer() -> Promise<Void> {
        return Promise { seal  in
            guard let _ = tcgPlayerPartnerKey,
                let tcgPlayerPublicKey = tcgPlayerPublicKey,
                let tcgPlayerPrivateKey = tcgPlayerPrivateKey else {
                let error = NSError(domain: "Error", code: 401, userInfo: [NSLocalizedDescriptionKey: "No TCGPlayer keys found."])
                seal.reject(error)
                return
            }
            
            let dateFormat = DateFormatter()
            var willAuthenticate = true
            
            dateFormat.dateStyle = .medium
            
            if let _ = keychain[UserDefaultsKeys.TcgPlayerToken],
                let expiration = keychain[UserDefaultsKeys.TcgPlayerExpiration],
                let expirationDate = dateFormat.date(from: expiration) {
                
                if Date() <= expirationDate {
                    willAuthenticate = false
                }
            }
            
            if willAuthenticate {
                guard let urlString = "https://api.tcgplayer.com/token".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                    let url = URL(string: urlString) else {
                    fatalError("Malformed url")
                }
                let query = "grant_type=client_credentials&client_id=\(tcgPlayerPublicKey)&client_secret=\(tcgPlayerPrivateKey)"
            
                var rq = URLRequest(url: url)
                rq.httpMethod = "POST"
                rq.setValue("application/json", forHTTPHeaderField: "Content-Type")
                rq.httpBody = query.data(using: .utf8)
            
                firstly {
                    URLSession.shared.dataTask(.promise, with: rq)
                }.compactMap {
                    try JSONSerialization.jsonObject(with: $0.data) as? [String: Any]
                }.done { json in
                    guard let token = json["access_token"] as? String,
                        let expiresIn = json["expires_in"] as? Double else {
                        let error = NSError(domain: "Error", code: 401, userInfo: [NSLocalizedDescriptionKey: "No TCGPlayer token found."])
                        seal.reject(error)
                        return
                    }
                    let date = Date().addingTimeInterval(expiresIn)
                    self.keychain[UserDefaultsKeys.TcgPlayerToken] = token
                    self.keychain[UserDefaultsKeys.TcgPlayerExpiration] = dateFormat.string(from: date)
                    
                    seal.fulfill(())
                }.catch { error in
                    print("\(error)")
                    seal.reject(error)
                }
            } else {
                seal.fulfill(())
            }
        }
    }
    
//    public func getTcgPlayerPrices(forSet set: CMSet) -> Promise<Void> {
//        return Promise { seal  in
//            guard let urlString = "https://api.tcgplayer.com/\(Constants.TcgPlayerApiVersion)/pricing/group/\(set.tcgPlayerID)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
//                let url = URL(string: urlString) else {
//                    fatalError("Malformed url")
//            }
//
//            guard let token = keychain[UserDefaultsKeys.TcgPlayerToken] else {
//                fatalError("No TCGPlayer token found.")
//            }
//
//            var rq = URLRequest(url: url)
//            rq.httpMethod = "GET"
//            rq.setValue("application/json", forHTTPHeaderField: "Content-Type")
//            rq.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
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
//                try! self.realm.write {
//                    // delete first
//                    for card in set.cards {
//                        for pricing in card.pricings {
//                            self.realm.delete(pricing)
//                        }
//                        self.realm.add(card)
//                    }
//
//                    for dict in results {
//                        if let productId = dict["productId"] as? Int,
//                            let card = self.realm.objects(CMCard.self).filter("tcgPlayerID = %@", productId).first {
//
//                            let pricing = CMCardPricing()
//                            pricing.card = card
//                            if let d = dict["lowPrice"] as? Double {
//                                pricing.lowPrice = d
//                            }
//                            if let d = dict["midPrice"] as? Double {
//                                pricing.midPrice = d
//                            }
//                            if let d = dict["highPrice"] as? Double {
//                                pricing.highPrice = d
//                            }
//                            if let d = dict["marketPrice"] as? Double {
//                                pricing.marketPrice = d
//                            }
//                            if let d = dict["directLowPrice"] as? Double {
//                                pricing.directLowPrice = d
//                            }
//                            if let d = dict["subTypeName"] as? String {
//                                if d == "Normal" {
//                                    pricing.isFoil = false
//                                } else if d == "Foil" {
//                                    pricing.isFoil = true
//                                }
//                            }
//                            self.realm.add(pricing)
//
//                            card.pricings.append(pricing)
//                            card.tcgPlayerID = Int32(productId)
//                            card.tcgPlayerLstUpdate = Date()
//                            self.realm.add(card)
//                        }
//                    }
//                    seal.fulfill(())
//                }
//            }.catch { error in
//                print("\(error)")
//                seal.reject(error)
//            }
//        }
//    }
//
//    public func getTcgPlayerPrices(forCards cards: [CMCard]) -> Promise<Void> {
//        return Promise { seal  in
//            let productIds = cards.map({ $0.tcgPlayerID }).map(String.init).joined(separator: ",")
//            guard let urlString = "https://api.tcgplayer.com/\(Constants.TcgPlayerApiVersion)/pricing/product/\(productIds)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
//                let url = URL(string: urlString) else {
//                fatalError("Malformed url")
//            }
//
//            guard let token = keychain[UserDefaultsKeys.TcgPlayerToken] else {
//                fatalError("No TCGPlayer token found.")
//            }
//
//            var rq = URLRequest(url: url)
//            rq.httpMethod = "GET"
//            rq.setValue("application/json", forHTTPHeaderField: "Content-Type")
//            rq.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
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
//                try! self.realm.write {
//                    // delete first
//                    for card in cards {
//                        for pricing in card.pricings {
//                            self.realm.delete(pricing)
//                        }
//                        self.realm.add(card)
//                    }
//
//                    for dict in results {
//                        if let productId = dict["productId"] as? Int,
//                            let card = cards.filter({ it -> Bool in
//                               it.tcgPlayerID == productId
//                            }).first {
//
//                            let pricing = CMCardPricing()
//                            pricing.card = card
//                            if let d = dict["lowPrice"] as? Double {
//                                pricing.lowPrice = d
//                            }
//                            if let d = dict["midPrice"] as? Double {
//                                pricing.midPrice = d
//                            }
//                            if let d = dict["highPrice"] as? Double {
//                                pricing.highPrice = d
//                            }
//                            if let d = dict["marketPrice"] as? Double {
//                                pricing.marketPrice = d
//                            }
//                            if let d = dict["directLowPrice"] as? Double {
//                                pricing.directLowPrice = d
//                            }
//                            if let d = dict["subTypeName"] as? String {
//                                if d == "Normal" {
//                                    pricing.isFoil = false
//                                } else if d == "Foil" {
//                                    pricing.isFoil = true
//                                }
//                            }
//                            self.realm.add(pricing)
//
//                            card.pricings.append(pricing)
//                            card.tcgPlayerID = Int32(productId)
//                            card.tcgPlayerLstUpdate = Date()
//                            self.realm.add(card)
//                        }
//                    }
//                    seal.fulfill(())
//                }
//            }.catch { error in
//                print("\(error)")
//                seal.reject(error)
//            }
//        }
//    }
//    
//    public func fetchTCGPlayerCardPricing(card: CMCard) -> Promise<Void> {
//        return Promise { seal  in
//            if card.willUpdateTCGPlayerCardPricing() {
//                guard let tcgPlayerPartnerKey = tcgPlayerPartnerKey,
//                    let set = card.set,
//                    let tcgPlayerSetName = set.tcgplayerName,
//                    let cardName = card.name,
//                    let urlString = "http:partner.tcgplayer.com/x3/phl.asmx/p?pk=\(tcgPlayerPartnerKey)&s=\("tcgPlayerSetName")&p=\(cardName)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
//                    let url = URL(string: urlString) else {
//                    
//                    seal.fulfill(())
//                    return
//                }
//                
//                var rq = URLRequest(url: url)
//                rq.httpMethod = "GET"
//                
//                firstly {
//                    URLSession.shared.dataTask(.promise, with: rq)
//                }.map {
//                    try! XML(xml: $0.data, encoding: .utf8)
//                }.done { xml in
//                    let pricing = card.pricing != nil ? card.pricing : CMCardPricing()
//                    
//                    try! self.realm.write {
//                        for product in xml.xpath("product") {
//                            if let id = product.xpath("id").first?.text,
//                                let hiprice = product.xpath("hiprice").first?.text,
//                                let lowprice = product.xpath("lowprice").first?.text,
//                                let avgprice = product.xpath("avgprice").first?.text,
//                                let foilavgprice = product.xpath("foilavgprice").first?.text,
//                                let link = product.xpath("link").first?.text {
//                                pricing!.id = Int64(id)!
//                                pricing!.high = Double(hiprice)!
//                                pricing!.low = Double(lowprice)!
//                                pricing!.average = Double(avgprice)!
//                                pricing!.foil = Double(foilavgprice)!
//                                pricing!.link = link
//                            }
//                        }
//                        pricing!.lastUpdate = Date()
//                        card.pricing = pricing
//                    
//                        self.realm.add(pricing!)
//                        self.realm.add(card, update: true)
//                        seal.fulfill(())
//                    }
//                }.catch { error in
//                    seal.reject(error)
//                }
//            } else {
//                seal.fulfill(())
//            }
//        }
//    }
//
//    public func fetchTCGPlayerStorePricing(card: CMCard) -> Promise<Void> {
//        return Promise { seal  in
//            if card.willUpdateTCGPlayerStorePricing() {
//                guard let tcgPlayerPartnerKey = tcgPlayerPartnerKey,
////                    let set = card.set,
////                    let tcgPlayerSetName = set.tcgplayerName,
//                    let cardName = card.name,
//                    let urlString = "http://partner.tcgplayer.com/x3/pv.asmx/p?pk=\(tcgPlayerPartnerKey)&s=\("tcgPlayerSetName")&p=\(cardName)&v=8".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
//                    let url = URL(string: urlString) else {
//
//                    seal.fulfill(())
//                    return
//                }
//
//                var rq = URLRequest(url: url)
//                rq.httpMethod = "GET"
//
//                firstly {
//                    URLSession.shared.dataTask(.promise, with: rq)
//                }.map {
//                    try! XML(xml: $0.data, encoding: .utf8)
//                }.done { xml in
//                    try! self.realm.write {
//                        var storePricing: CMStorePricing?
//
//                        // cleanup existing storePricing, if there is any
//                        if let sp = card.tcgplayerStorePricing {
//                            for sup in sp.suppliers {
//                                self.realm.delete(sup)
//                            }
//                            self.realm.delete(sp)
//                            storePricing = sp
//                        } else {
//                            storePricing = CMStorePricing()
//                        }
//
//                        for supplier in xml.xpath("//supplier") {
//                            if let name = supplier.xpath("name").first?.text,
//                                let condition = supplier.xpath("condition").first?.text,
//                                let qty = supplier.xpath("qty").first?.text,
//                                let price = supplier.xpath("price").first?.text,
//                                let link = supplier.xpath("link").first?.text {
//
//                                let id = "\(name)_\(condition)_\(qty)_\(price)"
//                                var sup: CMStoreSupplier?
//
//                                if let s = self.realm.objects(CMStoreSupplier.self).filter("id = %@", id).first {
//                                    sup = s
//                                } else {
//                                    sup = CMStoreSupplier()
//                                }
//                                sup!.id = id
//                                sup!.name = name
//                                sup!.condition = condition
//                                sup!.qty = Int32(qty)!
//                                sup!.price = Double(price)!
//                                sup!.link = link
//                                self.realm.add(sup!)
//                                storePricing!.suppliers.append(sup!)
//                            }
//                        }
//                        if let note = xml.xpath("//note").first?.text {
//                            storePricing!.notes = note
//                        }
//                        storePricing!.lastUpdate = Date()
//                        self.realm.add(storePricing!)
//
//                        seal.fulfill(())
//                    }
//
//                }.catch { error in
//                    seal.reject(error)
//                }
//            } else {
//                seal.fulfill(())
//            }
//        }
//    }
}
