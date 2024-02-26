//
//  File.swift
//  
//
//  Created by Miguel Ponce de Monio III on 2/13/24.
//

import Foundation
import SwiftData

extension ManaKit {
    func willFetchCache(forUrl url: URL) -> Bool {
        var willFetch = true

        let context = newBackgroundContext()

        if let cache = find(MGLocalCache.self,
                            properties: ["url": url.absoluteString],
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

        if let cache = find(MGLocalCache.self,
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
                try await delete(MGLocalCache.self,
                                 predicate: NSPredicate(format: "url == %@", url.absoluteString))
                save(context: context)
            } catch {
                print(error)
            }
        }
    }
}
