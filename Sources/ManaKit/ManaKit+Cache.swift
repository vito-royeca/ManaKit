//
//  ManaKit+Cache.swift
//  
//
//  Created by Vito Royeca on 2/13/24.
//

import Foundation
import SwiftData

extension ManaKit {
    func willFetchCache(forUrl url: URL) -> Bool {
        var willFetch = true

        let context = newBackgroundContext()
        var properties:[String : Any] = ["url": url.absoluteString]
        
        if let queries = url.query(percentEncoded: false) {
            for query in queries.components(separatedBy: "&") {
                let pair = queries.components(separatedBy: "=")
                if let key = pair.first,
                   let value = pair.last {
                    if key == "pageCount" ||
                        key == "pageNumber" ||
                        key == "queries" ||
                        key == "sorters" {
                        properties[key] = value
                    }
                }
            }
        }

        if let cache = find(LocalCache.self,
                            properties: properties,
                            predicate: NSPredicate(format: "url == %@", url.absoluteString),
                            sortDescriptors: nil,
                            createIfNotFound: true,
                            context: context)?.first {
            
            if let lastUpdated = cache.lastUpdated {
                if let diff = Calendar.current.dateComponents([.minute],
                                                              from: lastUpdated,
                                                              to: Date()).minute {
                    willFetch = diff >= Constants.cacheAge
                }
            }
        }

        return willFetch
    }

    func saveCache(forUrl url: URL) {
        let context = newBackgroundContext()

        if let cache = find(LocalCache.self,
                            properties: ["url": url.absoluteString],
                            predicate: NSPredicate(format: "url == %@", url.absoluteString),
                            sortDescriptors: nil,
                            createIfNotFound: true,
                            context: context)?.first {
            cache.lastUpdated = Date()
            save(context: context)
        }
    }

    func deleteCache(forUrl url: URL) {
        Task {
            do {
                let context = newBackgroundContext()
                try await delete(LocalCache.self,
                                 predicate: NSPredicate(format: "url == %@", url.absoluteString))
                save(context: context)
            } catch {
                print(error)
            }
        }
    }
}
