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
    public func prefetchSets(type: SectionedSetsType, fetchSets: Bool, fetchCards: Bool) async throws {
        guard let cachePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first else {
            return
        }
        
        let fileURL = URL(filePath: cachePath.appending("/\(type.rawValue).json"))
        var sectionedSets: [SetsByYearQuery.Data.SetsByYear.SectionedSet]?

        if !FileManager.default.fileExists(atPath: fileURL.path()) {
            sectionedSets = try await sets(fetchRemote: true, type: type)?.sectionedSets
        } else {
            sectionedSets = try await sets(fetchRemote: false, type: type)?.sectionedSets
        }

        if fetchSets {
            let maxFetch = 30
            let sleepInterval = UInt32(300)
            var sleepCounter = 0
            for sectionedSet in sectionedSets ?? [] {
                for setItem in sectionedSet.sets {
                    for language in setItem.languages ?? [] {
                        if sleepCounter >= maxFetch {
                            let date = Date()
                            print("Sleep... \(date)")
                            sleep(sleepInterval)
                            sleepCounter = 0
                        }
                        
                        // fetch only the English language
                        if language.id == "en" {
                            if let set = try await set(fetchRemote: true,
                                                       setID: setItem.id,
                                                       languageID: language.id) {
                                sleepCounter += 1
                            }
                        }
                    }
                }
            }
        }
    }

//    
//    func fetchCard(id: String) async throws -> Bool {
//        guard let cachePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first else {
//            return false
//        }
//        
//        do {
//            let response = try await apollo.fetch(query: CardQuery(id: id))
//            
//            let array = id.split(separator: "_")
//            let dir = URL(fileURLWithPath: cachePath.appending("/\(array[0])/\(array[1])"), isDirectory: true)
//            if !FileManager.default.fileExists(atPath: dir.path) {
//                try FileManager.default.createDirectory(at: dir,
//                                                        withIntermediateDirectories: true,
//                                                        attributes: nil)
//            }
//            
//            let fileURL = dir.appending(path: "\(array[2]).json")
//            if !FileManager.default.fileExists(atPath: fileURL.path()) {
//                let jsonData = response.asJSONDictionary()
//                let data = try JSONSerialization.data(withJSONObject: jsonData, options: [])
//                try data.write(to: fileURL, options: [])
//                print("\(fileURL.path())")
//                return true
//            }
//            return false
//        } catch {
//            return false
//        }
//    }
}
