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

extension Maintainer {
    func fetchRulings() -> Promise<Void> {
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
    
    func rulingsData() -> [[String: Any]] {
        guard let cachePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first else {
            fatalError("Malformed cachePath")
        }
        let setsPath = "\(cachePath)/\(ManaKit.Constants.ScryfallDate)_\(rulingsFileName)"
        
        let data = try! Data(contentsOf: URL(fileURLWithPath: setsPath))
        guard let array = try! JSONSerialization.jsonObject(with: data,
                                                           options: .mutableContainers) as? [[String: Any]] else {
            fatalError("Malformed data")
        }
        
        return array
    }
}
