//
//  Maintainer+Sets.swift
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
    func fetchSetsData() -> Promise<Void> {
        return Promise { seal in
            guard let cachePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first else {
                fatalError("Malformed cachePath")
            }
            let setsPath = "\(cachePath)/\(ManaKit.Constants.ScryfallDate)_\(setsFileName)"
            let willFetch = !FileManager.default.fileExists(atPath: setsPath)
            
            if willFetch {
                guard let urlString = "https://api.scryfall.com/sets".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                    let url = URL(string: urlString) else {
                        fatalError("Malformed url")
                }
                var rq = URLRequest(url: url)
                rq.httpMethod = "GET"
                
                print("Fetching Scryfall sets... \(urlString)")
                firstly {
                    URLSession.shared.dataTask(.promise, with:rq)
                }.compactMap {
                    try JSONSerialization.jsonObject(with: $0.data) as? [String: Any]
                }.done { json in
                    if let outputStream = OutputStream(toFileAtPath: setsPath, append: false) {
                        print("Writing Scryfall sets... \(setsPath)")
                        var error: NSError?
                        outputStream.open()
                        JSONSerialization.writeJSONObject(json,
                                                          to: outputStream,
                                                          options: JSONSerialization.WritingOptions(),
                                                          error: &error)
                        outputStream.close()
                        print("Done!")
                        seal.fulfill(())
                    }
                }.catch { error in
                    seal.reject(error)
                }
            } else {
                seal.fulfill(())
            }
        }
    }
    
    func fetchSetSymbols() -> Promise<Void> {
        return Promise { seal in
            guard let cachePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first else {
                fatalError("Malformed cachePath")
            }
            let keyrunePath = "\(cachePath)/\(ManaKit.Constants.ScryfallDate)_\(keyruneFileName)"
            let willFetch = !FileManager.default.fileExists(atPath: keyrunePath)
            
            if willFetch {
                guard let urlString = "http://andrewgioia.github.io/Keyrune/cheatsheet.html".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                    let url = URL(string: urlString) else {
                    fatalError("Malformed url")
                }

                var rq = URLRequest(url: url)
                rq.httpMethod = "GET"
                
                firstly {
                    URLSession.shared.downloadTask(.promise,
                                                   with: rq,
                                                   to: URL(fileURLWithPath: keyrunePath))
                }.done { _ in
                    seal.fulfill(())
                }.catch { error in
                    seal.reject(error)
                }
            } else {
                seal.fulfill(())
            }
        }
    }
    
    func setsData() -> [[String: Any]] {
        guard let cachePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first else {
            fatalError("Malformed cachePath")
        }
        let setsPath = "\(cachePath)/\(ManaKit.Constants.ScryfallDate)_\(setsFileName)"
        
        let data = try! Data(contentsOf: URL(fileURLWithPath: setsPath))
        guard let dict = try! JSONSerialization.jsonObject(with: data,
                                                           options: .mutableContainers) as? [String: Any] else {
            fatalError("Malformed data")
        }
        guard let array = dict["data"] as? [[String: Any]] else {
            fatalError("Malformed data")
        }
        
        return array
    }

    func filterSetBlocks(array: [[String: Any]], connection: Connection) -> [()->Promise<Void>] {
        var filteredData = [String: String]()
        
        for dict in array {
            if let blockCode = dict["block_code"] as? String,
                let block = dict["block"] as? String {
                filteredData[blockCode] = block
            }
        }
        let promises: [()->Promise<Void>] = filteredData.map { (blockCode, block) in
            return {
                return self.createSetBlockPromise(blockCode: blockCode,
                                                  block: block,
                                                  connection: connection)
            }
        }
        return promises
    }
    
    func filterSetTypes(array: [[String: Any]], connection: Connection) -> [()->Promise<Void>] {
        var filteredData = [String]()
        
        for dict in array {
            if let setType = dict["set_type"] as? String,
                !filteredData.contains(setType) {
                filteredData.append(setType)
            }
        }
        let promises: [()->Promise<Void>] = filteredData.map { setType in
            return {
                return self.createSetTypePromise(setType: setType,
                                                 connection: connection)
            }
        }
        return promises
    }
    
    func filterSets(array: [[String: Any]], connection: Connection) -> [()->Promise<Void>] {
        let filteredData = array.sorted(by: {
            $0["parent_set_code"] as? String ?? "" < $1["parent_set_code"] as? String ?? ""
        })
        
        let promises: [()->Promise<Void>] = filteredData.map { dict in
            return {
                return self.createSetPromise(dict: dict,
                                             connection: connection)
            }
        }
        
        return promises
    }
}
