//
//  TCGPlayerMaintainer.swift
//  ManaKit_Example
//
//  Created by Jovito Royeca on 23/10/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import CoreData
import ManaKit
import PromiseKit

class TCGPlayerMaintainer: Maintainer {
    let version = "v1.9.0"
    let limit = 300
    var token = ""
    
    func updateSetTcgPlayerNames() {
        startActivity(name: "updateSetTcgPlayerNames()")
        
        firstly {
            getToken()
        }.then {
            self.getMagicCategoryId()
        }.done { categoryId in
            self.getMagicSets(categoryId: categoryId, offset: 0)
//            self.getCardPurchaseUris()
            self.endActivity()
        }.catch { error in
            print("\(error)")
        }
    }
    
    private func getToken() -> Promise<Void> {
        return Promise { seal  in
            if let urlString = "https://api.tcgplayer.com/token".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                let url = URL(string: urlString) {

                let query = "grant_type=client_credentials&client_id=A49D81FB-5A76-4634-9152-E1FB5A657720&client_secret=C018EF82-2A4D-4F7A-A785-04ADEBF2A8E5"
                
                var rq = URLRequest(url: url)
                rq.httpMethod = "POST"
                rq.setValue("application/json", forHTTPHeaderField: "Content-Type")
                rq.httpBody = query.data(using: .utf8)
                
                firstly {
                    URLSession.shared.dataTask(.promise, with:rq)
                }.compactMap {
                    try JSONSerialization.jsonObject(with: $0.data) as? [String: Any]
                }.done { json in
                    guard let token = json["access_token"] as? String else {
                        fatalError("access_token is nil")
                    }
                    
                    self.token = token
                    seal.fulfill(())
                }.catch { error in
                    print("\(error)")
                    seal.reject(error)
                }
            }
        }
    }
    
    private func getMagicCategoryId() -> Promise<Int> {
        return Promise { seal  in
            if let urlString = "http://api.tcgplayer.com/\(version)/catalog/categories?limit=\(limit)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                let url = URL(string: urlString) {
                
                var rq = URLRequest(url: url)
                rq.httpMethod = "GET"
                rq.setValue("application/json", forHTTPHeaderField: "Content-Type")
                rq.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
                
                firstly {
                    URLSession.shared.dataTask(.promise, with:rq)
                }.compactMap {
                    try JSONSerialization.jsonObject(with: $0.data) as? [String: Any]
                }.done { json in
                    guard let results = json["results"] as? [[String: Any]] else {
                        fatalError("results is nil")
                    }
                    
                    for dict in results {
                        if let categoryId = dict["categoryId"] as? Int,
                            let name = dict["name"] as? String {
                            if name == "Magic" {
                                seal.fulfill(categoryId)
                            }
                        }
                    }
                    
                }.catch { error in
                    print("\(error)")
                    seal.reject(error)
                }
            }
        }
    }
    
    private func getCardPurchaseUris() {
        startActivity(name: "getCardPurchaseUris")
        
        let request: NSFetchRequest<CMSet> = CMSet.fetchRequest()
        request.predicate = NSPredicate(format: "tcgplayerName = nil")
        request.sortDescriptors = [NSSortDescriptor(key: "releaseDate", ascending: true)]
        
        var promises = [Promise<URL?>]()
        for set in try! context.fetch(request) {
            if let code = set.code,
                let urlString = "https://api.scryfall.com/cards/search?q=e:\(code)&unique=prints".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                
            }
        }
        
        endActivity()
    }

    private func readScryfall(url: URL) -> Promise<URL?> {
        return Promise { seal  in
            var rq = URLRequest(url: url)
            rq.httpMethod = "GET"
            
            firstly {
                URLSession.shared.dataTask(.promise, with:rq)
            }.compactMap {
                    try JSONSerialization.jsonObject(with: $0.data) as? [String: Any]
            }.done { json in
                if let data = json["data"] as? [[String: Any]] {
                    for e in data {
                        if let id = e["id"] as? String,
                            let purchaseUris = [""] as? [String: Any] {
                        
                        }
                    }
                }
            
                print("Scraping \(url)...")
                
                if let hasMore = json["has_more"] as? Bool,
                    let nextPage = json["next_page"] as? String {
                    
                    if hasMore {
                        seal.fulfill(URL(string: nextPage)!)
                    } else {
                        seal.fulfill(nil)
                    }
                } else {
                    seal.fulfill(nil)
                }
            }.catch { error in
                seal.fulfill(nil)
            }
        }
    }
    
    private func getMagicSets(categoryId: Int, offset: Int) {
            if let urlString = "http://api.tcgplayer.com/\(version)/catalog/categories/\(categoryId)/groups?limit=\(limit)&offset=\(offset)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                let url = URL(string: urlString) {
                
                var rq = URLRequest(url: url)
                rq.httpMethod = "GET"
                rq.setValue("application/json", forHTTPHeaderField: "Content-Type")
                rq.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
                
                firstly {
                    URLSession.shared.dataTask(.promise, with:rq)
                }.compactMap {
                    try JSONSerialization.jsonObject(with: $0.data) as? [String: Any]
                }.done { json in
                    guard let totalItems = json["totalItems"] as? Int,
                        let results = json["results"] as? [[String: Any]] else {
                        fatalError("results is nil")
                    }
                    var sets = [[String: String]]()
                    
                    for dict in results {
                        if let code = dict["abbreviation"] as? String,
                            let name = dict["name"] as? String {
                            sets.append(["code": code,
                                         "name": name])
                        }
                    }
                    
                    self.processSets(array: sets)
                    
                    if offset <= totalItems && sets.count > 0 {
                        self.getMagicSets(categoryId: categoryId, offset: offset + sets.count + 1)
                    }
                }.catch { error in
                    print("\(error)")
                    
                }
            }
        
    }
    
    private func processSets(array: [[String: String]]) {
        let request: NSFetchRequest<CMSet> = CMSet.fetchRequest()
        
        var sets = try! context.fetch(request)
        for set in sets {
            for dict in array {
                if let code = dict["code"],
                    let name = dict["name"] {
                    if set.code?.lowercased() == code.lowercased() {
                        set.tcgplayerName = name
                    }
                }
            }
        }
        try! context.save()
        
        // manual fix
        sets = try! context.fetch(request)
        for set in sets {
            if let parent = set.parent {
                set.tcgplayerName = parent.tcgplayerName
            }
        }
        try! context.save()
    }
}
