//
//  ManaKitUtilities+Prefetcher.swift
//  ManaKit
//
//  Created by Vito Royeca on 5/16/26.
//

import Foundation
import Apollo
import ApolloAPI

extension ManaKitUtilities {
    public func prefetchSets(fetchSetDetails: Bool = false,
                             includeNonEnglishSets: Bool = false,
                             fetchCards: Bool = false) async throws {
        do {
            let sectionedSets = try await sets(fetchRemote: false, type: .byName)?
                .sectionedSets
            try await sets(fetchRemote: false, type: .byType)
            try await sets(fetchRemote: false, type: .byYear)
            
            if let sectionedSets,
                fetchSetDetails {
                let maxFetch = 60
                let sleepInterval = UInt32(30)
                var sleepCounter = 0

                for sectionedSet in sectionedSets {
                    for setItem in sectionedSet.sets {
                        for language in setItem.languages ?? [] {
                            if sleepCounter >= maxFetch {
                                let date = Date()
                                print("Sleep... \(date)")
                                sleep(sleepInterval)
                                sleepCounter = 0
                            }
                            
                            let willFetch = includeNonEnglishSets || language.id == "en"
                            
                            if willFetch {
                                if let set = try await set(fetchRemote: true,
                                                           setID: setItem.id,
                                                           languageID: language.id) {
                                    sleepCounter += 1
                                    
                                    if fetchCards {
                                        for setCard in set.cards ?? [] {
                                            if sleepCounter >= maxFetch {
                                                let date = Date()
                                                print("Sleep... \(date)")
                                                sleep(sleepInterval)
                                                sleepCounter = 0
                                            }

                                            if let _ = try await card(fetchRemote: false,
                                                                      id: setCard.id) {
                                                sleepCounter += 1
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        } catch {
            print(error)
        }
    }
}
