//
//  ManaKitUtilities+Data.swift
//  ManaKit
//
//  Created by Vito Royeca on 4/20/26.
//

import Foundation
import CryptoKit

public enum SectionedSetsType: String {
    case byName = "sets_by_name"
    case byType = "sets_by_type"
    case byYear = "sets_by_year"
}

extension ManaKitUtilities {
    public func sets(fetchRemote: Bool, type: SectionedSetsType) async throws -> SectionedSets? {
        guard let cachePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first else {
            return nil
        }
        
        let parentURL = URL(filePath: cachePath.appending("/sets"))
        let fileURL = parentURL.appendingPathComponent(type.rawValue, conformingTo: .json)
        let bundleName = type.rawValue
        
        do {
            if fetchRemote {
                var sectionedSets: SectionedSets?
                var jsonData: [String: Any]?

                // fetch remotely
                switch type {
                case .byName:
                    let response = try await apollo.fetch(query: SetsByNameQuery())
                    sectionedSets = response.data?.setsByName?.fragments.sectionedSets
                    jsonData = response.asJSONDictionary()
                case .byType:
                    let response = try await apollo.fetch(query: SetsByTypeQuery())
                    sectionedSets = response.data?.setsByType?.fragments.sectionedSets
                    jsonData = response.asJSONDictionary()
                case .byYear:
                    let response = try await apollo.fetch(query: SetsByYearQuery())
                    sectionedSets = response.data?.setsByYear?.fragments.sectionedSets
                    jsonData = response.asJSONDictionary()
                }
                
                // write to disk
                if let sectionedSets, let jsonData {
                    try write(to: fileURL, parent: parentURL, jsonData: jsonData)
                }
                return sectionedSets
            } else {
                // read from disk (previously downloaded) or from Bundle
                if let data = try read(from: fileURL, or: bundleName),
                    let jsonObject = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as? [String: AnyHashable],
                   let jsonValue = jsonObject["data"] as? [String: AnyHashable] {
                    switch type {
                    case .byName:
                        let queryData = try await SetsByNameQuery.Data(data: jsonValue)
                        return queryData.setsByName?.fragments.sectionedSets
                    case .byType:
                        let queryData = try await SetsByTypeQuery.Data(data: jsonValue)
                        return queryData.setsByType?.fragments.sectionedSets
                    case .byYear:
                        let queryData = try await SetsByYearQuery.Data(data: jsonValue)
                        return queryData.setsByYear?.fragments.sectionedSets
                    }
                } else {
                    // fallback: fetchRemote = true
                    return try await sets(fetchRemote: true, type: type)
                }
            }
        } catch {
            throw error
        }
    }

    public func set(fetchRemote: Bool, setID: String, languageID: String) async throws -> SetQuery.Data.Set? {
        guard let cachePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first else {
            return nil
        }
        
        let parentURL = URL(fileURLWithPath: cachePath.appending("/sets/\(setID)"), isDirectory: true)
        let fileURL = parentURL.appendingPathComponent("\(setID)_\(languageID)", conformingTo: .json)
        let bundleName = "\(setID)_\(languageID)"
        
        do {
            if fetchRemote {
                var set: SetQuery.Data.Set?
                var jsonData: [String: Any]?
                
                // fetch remotely
                let input = SetByIDInput(setID: setID, languageID: languageID)
                let response = try await apollo.fetch(query: SetQuery(input: input))
                set = response.data?.set
                jsonData = response.asJSONDictionary()

                // write to disk
                if let set, let jsonData {
                    try write(to: fileURL, parent: parentURL, jsonData: jsonData)
                }
                return set
            } else {
                // read from disk (previously downloaded) or from Bundle
                if let data = try read(from: fileURL, or: bundleName),
                   let jsonObject = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as? [String: AnyHashable],
                   let jsonValue = jsonObject["data"] as? [String: AnyHashable] {
                    let queryData = try await SetQuery.Data(data: jsonValue)
                    return queryData.set
                } else {
                    // fallback: fetchRemote = true
                    return try await set(fetchRemote: true, setID: setID, languageID: languageID)
                }
            }
        } catch {
            throw error
        }
    }

    public func card(fetchRemote: Bool, id: String) async throws -> CardQuery.Data.Card? {
        guard let cachePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first else {
            return nil
        }
        
        let array = id.split(separator: "_")
        let parentURL = URL(fileURLWithPath: cachePath.appending("/sets/\(array[0])/\(array[1])"), isDirectory: true)
        let fileURL = parentURL.appendingPathComponent("\(array[2])", conformingTo: .json)
        let bundleName = id
        
        do {
            if fetchRemote {
                var card: CardQuery.Data.Card?
                var jsonData: [String: Any]?
                
                // fetch remotely
                let response = try await apollo.fetch(query: CardQuery(id: id))
                card = response.data?.card
                jsonData = response.asJSONDictionary()

                // write to disk
                if let jsonData {
                    try write(to: fileURL, parent: parentURL, jsonData: jsonData)
                }
                return card
            } else {
                // read from disk (previously downloaded) or from Bundle
                if let data = try read(from: fileURL, or: bundleName),
                   let jsonObject = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as? [String: AnyHashable],
                   let jsonValue = jsonObject["data"] as? [String: AnyHashable] {
                    let queryData = try await CardQuery.Data(data: jsonValue)
                    return queryData.card
                } else {
                    // fallback: fetchRemote = true
                    return try await card(fetchRemote: true, id: id)
                }
            }
        } catch {
            throw error
        }
    }
    
    public func cardPrintings(fetchRemote: Bool, id: String, languageID: String) async throws -> CardPrintingsQuery.Data.CardPrintings? {
        guard let cachePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first else {
            return nil
        }
        
        let array = id.split(separator: "_")
        let parentURL = URL(fileURLWithPath: cachePath.appending("/printings/\(array[0])/\(array[1])"), isDirectory: true)
        let fileURL = parentURL.appendingPathComponent("\(array[2])", conformingTo: .json)
        let bundleName: String? = nil
        
        do {
            if fetchRemote {
                var cardPrintings: CardPrintingsQuery.Data.CardPrintings?
                var jsonData: [String: Any]?
                
                // fetch remotely
                let response = try await apollo.fetch(query: CardPrintingsQuery(id: id, languageID: languageID))
                cardPrintings = response.data?.cardPrintings
                jsonData = response.asJSONDictionary()

                // write to disk
                if let jsonData {
                    try write(to: fileURL, parent: parentURL, jsonData: jsonData)
                }
                return cardPrintings
            } else {
                // read from disk (previously downloaded) or from Bundle
                if let data = try read(from: fileURL, or: bundleName),
                   let jsonObject = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as? [String: AnyHashable],
                   let jsonValue = jsonObject["data"] as? [String: AnyHashable] {
                    let queryData = try await CardPrintingsQuery.Data(data: jsonValue)
                    return queryData.cardPrintings
                } else {
                    // fallback: fetchRemote = true
                    return try await cardPrintings(fetchRemote: true, id: id, languageID: languageID)
                }
            }
        } catch {
            throw error
        }
    }
    
    public func cardsByIDs(fetchRemote: Bool, cardIDs: [String]) async throws -> CardsByIDsQuery.Data.CardsByIDs? {
        guard let cachePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first else {
            return nil
        }
        
        let string = cardIDs.joined(separator: "_")
        let stringData = Data(string.utf8)
        let digest = Insecure.MD5.hash(data: stringData)
        let hash = digest.map { String(format: "%02x", $0) }.joined()
        
        let parentURL = URL(filePath: cachePath.appending("/cardsByIDs"))
        let fileURL = parentURL.appendingPathComponent("\(hash)", conformingTo: .json)
        let bundleName:String? = nil
        
        do {
            if fetchRemote {
                var cardByIDs: CardsByIDsQuery.Data.CardsByIDs?
                var jsonData: [String: Any]?
                
                // fetch remotely
                let response = try await apollo.fetch(query: CardsByIDsQuery(ids: cardIDs))
                cardByIDs = response.data?.cardsByIDs
                jsonData = response.asJSONDictionary()

                // write to disk
                if let jsonData {
                    try write(to: fileURL, parent: parentURL, jsonData: jsonData)
                }
                return cardByIDs
            } else {
                // read from disk (previously downloaded) or from Bundle
                if let data = try read(from: fileURL, or: bundleName),
                   let jsonObject = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as? [String: AnyHashable],
                   let jsonValue = jsonObject["data"] as? [String: AnyHashable] {
                    let queryData = try await CardsByIDsQuery.Data(data: jsonValue)
                    return queryData.cardsByIDs
                } else {
                    // fallback: fetchRemote = true
                    return try await cardsByIDs(fetchRemote: true, cardIDs: cardIDs)
                }
            }
        } catch {
            throw error
        }
    }

    public func feeds(fetchRemote: Bool) async throws -> FeedsQuery.Data.Feeds? {
        guard let cachePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first else {
            return nil
        }

        let parentURL = URL(filePath: cachePath.appending("/feeds"))
        let fileURL = parentURL.appendingPathComponent("feeds", conformingTo: .json)
        let bundleName = "feeds"
        
        do {
            if fetchRemote {
                var feeds: FeedsQuery.Data.Feeds?
                var jsonData: [String: Any]?

                // fetch remotely
                let response = try await ManaKitUtilities.shared.apollo.fetch(query: FeedsQuery())
                feeds = response.data?.feeds
                jsonData = response.asJSONDictionary()
                
                // write to disk
                if let feeds, let jsonData {
                    try write(to: fileURL, parent: parentURL, jsonData: jsonData)
                }
                return feeds
            } else {
                // read from disk (previously downloaded) or from Bundle
                if let data = try read(from: fileURL, or: "feeds"),
                    let jsonObject = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as? [String: AnyHashable],
                    let jsonValue = jsonObject["data"] as? [String: AnyHashable] {
                    let queryData = try await FeedsQuery.Data(data: jsonValue)
                    return queryData.feeds
                } else {
                    // fallback: fetchRemote = true
                    return try await feeds(fetchRemote: true)
                }
            }
        } catch {
            throw error
        }
    }
    
    // MARK: Private methods
    
    func write(to file: URL, parent: URL?, jsonData: [String: Any]) throws {
        do {
            if let parent,
               !FileManager.default.fileExists(atPath: parent.path) {
                try FileManager.default.createDirectory(at: parent,
                                                        withIntermediateDirectories: true,
                                                        attributes: nil)
            }
            
            let data = try JSONSerialization.data(withJSONObject: jsonData, options: [])
            try data.write(to: file, options: [])
            print("Saved: \(file.path())")
        } catch {
            throw error
        }
    }

    func read(from file: URL, or bundle: String?) throws -> Data? {
        guard let cachePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first else {
            return nil
        }
        
        do {
            var data: Data?
            
            // read from disk (previously downloaded) or from Bundle
            if FileManager.default.fileExists(atPath: file.path()) {
                data = try Data(contentsOf: file, options: .mappedIfSafe)
                print("Loaded from disk: \(file.path())")
            } else {
                if let bundle,
                    let path = Bundle.module.path(forResource: bundle, ofType: "json") {
                    data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                    print("Loaded from bundle: \(file.path())")
                }
            }
            return data
        } catch {
            throw error
        }
    }
}
