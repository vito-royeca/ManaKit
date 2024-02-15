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

        switch storageType {
        case .coreData:
            let context = backgroundContext

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
        case .swiftData:
            let context = sdBackgroundContext
            let predicate = #Predicate<SDLocalCache> {
                $0.url == url.absoluteString
            }

            if let cache = find(SDLocalCache.self,
                                properties: ["url": url.absoluteString],
                                predicate: predicate,
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
        }

        return willFetch
    }

    func saveCache(forUrl url: URL) {
        switch storageType {
        case .coreData:
            let context = backgroundContext

            if let cache = find(MGLocalCache.self,
                                properties: ["url": url.absoluteString],
                                predicate: NSPredicate(format: "url == %@", url.absoluteString),
                                sortDescriptors: nil,
                                createIfNotFound: true,
                                context: context)?.first {
                cache.lastUpdated = Date()
                save(context: context)
            }
        case .swiftData:
            let context = sdBackgroundContext
            let predicate = #Predicate<SDLocalCache> {
                $0.url == url.absoluteString
            }
            
            if let cache = find(SDLocalCache.self,
                                properties: ["url": url.absoluteString],
                                predicate: predicate,
                                sortDescriptors: nil,
                                createIfNotFound: true,
                                context: context)?.first {
                cache.lastUpdated = Date()
                save(context: context)
            }
        }
    }

    func deleteCache(forUrl url: URL) {
        switch storageType {
        case .coreData:
            Task {
                do {
                    let context = backgroundContext
                    try await delete(MGLocalCache.self,
                                     predicate: NSPredicate(format: "url == %@", url.absoluteString))
                    save(context: context)
                } catch {
                    print(error)
                }
            }
        case .swiftData:
            let predicate = #Predicate<SDLocalCache> {
                $0.url == url.absoluteString
            }
            
            do {
                try delete(SDLocalCache.self,
                           predicate: predicate)
            } catch {
                print(error)
            }
        }
    }
}
