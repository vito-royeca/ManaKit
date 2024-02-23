//
//  ManaKit+CoreData+API.swift
//  Pods
//
//  Created by Vito Royeca on 2/15/24.
//

import Combine
import CoreData
import SwiftData

extension ManaKit: API {
//    func fetchData<T: MEntity>(url: URL,
//                               jsonType: T.Type) async throws -> [NSManagedObjectID] {
//        
//        do {
//            let (data, response) = try await URLSession.shared.data(from: url)
//            
//            guard let response = response as? HTTPURLResponse,
//                  response.statusCode == 200 else {
//                throw ManaKitError.invalidHttpResponse
//            }
//
//            let decoder = JSONDecoder()
//            let jsonData = try decoder.decode([T].self, from: data)
//            
//            if jsonData.count > 1 {
//                let objectIDs = try await batchInsertToCoreData(jsonData,
//                                                                jsonType: jsonType)
//                saveCache(forUrl: url)
//                return objectIDs
//            } else {
//                var objectID: NSManagedObjectID?
//                
//                if let entity = jsonData.first as? MSet {
//                    objectID = try await insert(set: entity)
//                } else if let entity = jsonData.first as? MCard {
//                    objectID = try await insert(card: entity)
//                }
//                saveCache(forUrl: url)
//                
//                guard let objectID = objectID else {
//                    return []
//                }
//
//                return [objectID]
//            }
//        } catch {
//            deleteCache(forUrl: url)
//            throw error
//        }
//    }
    
    func fetchData<T: MEntity>(url: URL,
                               jsonType: T.Type) async throws -> [NSManagedObjectID] {
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let response = response as? HTTPURLResponse,
                  response.statusCode == 200 else {
                throw ManaKitError.invalidHttpResponse
            }

            let decoder = JSONDecoder()
            let jsonData = try decoder.decode([T].self, from: data)
            let objectIDs = syncToCoreData(jsonData,
                                           jsonType: jsonType)
            
            saveCache(forUrl: url)
            return objectIDs
        } catch {
            deleteCache(forUrl: url)
            throw error
        }
    }

    // MARK: - fetchSet(::)

    public func willFetchSet(code: String,
                             languageCode: String) throws -> Bool {
        let url = try fetchSetURL(code: code,
                                  languageCode: languageCode)
        
        return willFetchCache(forUrl: url)
    }
    
    public func fetchSet(code: String,
                         languageCode: String) async throws -> NSManagedObjectID? {
        let url = try fetchSetURL(code: code,
                                  languageCode: languageCode)
        
        return try await fetchData(url: url,
                                   jsonType: MSet.self).first
    }
    
    // MARK: - fetchSets

    public func willFetchSets() throws -> Bool {
        let url = try fetchSetsURL()
        
        return willFetchCache(forUrl: url)
    }
    
    public func fetchSets() async throws -> [NSManagedObjectID] {
        let url = try fetchSetsURL()
        
        return try await fetchData(url: url,
                                   jsonType: MSet.self)
        
    }

    // MARK: - fetchCard(:)

    public func willFetchCard(newID: String) throws -> Bool {
        let url = try fetchCardURL(newID: newID)
        
        return willFetchCache(forUrl: url)
    }
    
    public func fetchCard(newID: String) async throws -> NSManagedObjectID? {
        let url = try fetchCardURL(newID: newID)
        
        return try await fetchData(url: url,
                                   jsonType: MCard.self).first
    }
    
    // MARK: - fetchCards(::::)

    public func willFetchCards(name: String,
                               rarities: [String],
                               types: [String],
                               keywords: [String],
                               pageSize: Int,
                               pageOffset: Int) throws -> Bool {
        let url = try fetchCardsURL(name: name,
                                    rarities: rarities,
                                    types: types,
                                    keywords: keywords,
                                    pageSize: pageSize,
                                    pageOffset: pageOffset)
        
        return willFetchCache(forUrl: url)
    }
    
    public func fetchCards(name: String,
                           rarities: [String],
                           types: [String],
                           keywords: [String],
                           pageSize: Int,
                           pageOffset: Int) async throws -> [NSManagedObjectID] {
        let url = try fetchCardsURL(name: name,
                                    rarities: rarities,
                                    types: types,
                                    keywords: keywords,
                                    pageSize: pageSize,
                                    pageOffset: pageOffset)
        
        // delete old searchResults
        try await delete(MGSearchResult.self,
                         predicate: NSPredicate(format: "pageOffset == %i AND url = %@",
                                                pageOffset,
                                                url.absoluteString))

        let objectIDs = try await fetchData(url: url,
                                            jsonType: MCard.self)
        
        // add cards to searchResults
//        let context = newBackgroundContext()
//        for card in cards {
//            let predicate = NSPredicate(format: "pageOffset == %i AND newID == %@",
//                                        pageOffset,
//                                        card.newIDCopy)
//
//            var props = [String: Any]()
//            props["pageOffset"] = pageOffset
//            props["newID"] = card.newIDCopy
//            props["url"] = url.absoluteString
//
//            let _ = find(MGSearchResult.self,
//                         properties: props,
//                         predicate: predicate,
//                         sortDescriptors: nil,
//                         createIfNotFound: true,
//                         context: context)
//        }
//        save(context: context)

        return objectIDs
    }
    
    // MARK: - fetchCardOtherPrintings(::)

    public func willFetchCardOtherPrintings(newID: String,
                                            languageCode: String) throws -> Bool {
        let url = try fetchCardOtherPrintingsURL(newID: newID,
                                             languageCode: languageCode)
        
        return willFetchCache(forUrl: url)
    }
    
    public func fetchCardOtherPrintings(newID: String,
                                        languageCode: String) async throws -> [NSManagedObjectID] {
        let url = try fetchCardOtherPrintingsURL(newID: newID,
                                                 languageCode: languageCode)

        let objectIDs = try await fetchData(url: url,
                                            jsonType: MCard.self)

        
        // add otherPrintings to card
        let context = viewContext
        let predicate = NSPredicate(format: "newID == %@", newID)
        if let card = find(MGCard.self,
                           properties: nil,
                           predicate: predicate,
                           sortDescriptors: nil,
                           createIfNotFound: true,
                           context: context)?.first {
            for objectID in objectIDs {
                card.addToOtherPrintings(object(MGCard.self,
                                                with: objectID))
            }
        }
        
        return objectIDs
    }
    
    // MARK: - fetchArtists()

    public func willFetchArtists() throws -> Bool {
        let url = try fetchArtistsURL()
        
        return willFetchCache(forUrl: url)
    }

    public func fetchArtists() async throws -> [NSManagedObjectID] {
        let url = try fetchArtistsURL()

        return try await fetchData(url: url,
                                   jsonType: MArtist.self)
    }
    
    // MARK: - fetchColors()

    public func willFetchColors() throws -> Bool {
        let url = try fetchColorsURL()
        
        return willFetchCache(forUrl: url)
    }

    public func fetchColors() async throws -> [NSManagedObjectID] {
        let url = try fetchColorsURL()

        return try await fetchData(url: url,
                                   jsonType: MColor.self)
    }
    
    // MARK: - fetchGames()

    public func willFetchGames() throws -> Bool {
        let url = try fetchGamesURL()
        
        return willFetchCache(forUrl: url)
    }

    public func fetchGames() async throws -> [NSManagedObjectID] {
        let url = try fetchGamesURL()

        return try await fetchData(url: url,
                                   jsonType: MGame.self)
    }

    // MARK: - fetchKeywords()

    public func willFetchKeywords() throws -> Bool {
        let url = try fetchKeywordsURL()
        
        return willFetchCache(forUrl: url)
    }

    public func fetchKeywords() async throws -> [NSManagedObjectID] {
        let url = try fetchKeywordsURL()

        return try await fetchData(url: url,
                                   jsonType: MKeyword.self)
    }
    
    // MARK: - fetchRarities()

    public func willFetchRarities() throws -> Bool {
        let url = try fetchRaritiesURL()
        
        return willFetchCache(forUrl: url)
    }
    
    public func fetchRarities() async throws -> [NSManagedObjectID] {
        let url = try fetchRaritiesURL()

        return try await fetchData(url: url,
                                   jsonType: MRarity.self)
    }

    // MARK: - fetchCardTypes()

    public func willFetchCardTypes() throws -> Bool {
        let url = try fetchCardTypesURL()
        
        return willFetchCache(forUrl: url)
    }

    public func fetchCardTypes() async throws -> [NSManagedObjectID] {
        let url = try fetchCardTypesURL()

        return try await fetchData(url: url,
                                   jsonType: MCardType.self)
    }
}
