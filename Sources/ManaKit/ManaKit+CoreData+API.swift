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
    func fetchData<T: MEntity, U: MGEntity>(url: URL,
                                            jsonType: T.Type,
                                            coreDataType: U.Type,
                                            predicate: NSPredicate?,
                                            sortDescriptors: [NSSortDescriptor]?) async throws -> [U] {
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let response = response as? HTTPURLResponse,
                  response.statusCode == 200 else {
                throw ManaKitError.invalidHttpResponse
            }

            let decoder = JSONDecoder()
            let jsonData = try decoder.decode([T].self, from: data)
            let entities = syncToCoreData(jsonData,
                                          jsonType: jsonType,
                                          coreDataType: coreDataType,
                                          sortDescriptors: sortDescriptors)
            saveCache(forUrl: url)
            return entities ?? []
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
                         languageCode: String) async throws -> MGSet? {
        let url = try fetchSetURL(code: code,
                                  languageCode: languageCode)
        let predicate = NSPredicate(format: "code == %@", code)
        
        return try await fetchData(url: url,
                                   jsonType: MSet.self,
                                   coreDataType: MGSet.self,
                                   predicate: predicate,
                                   sortDescriptors: nil).first
    }
    
    // MARK: - fetchSets

    public func willFetchSets() throws -> Bool {
        let url = try fetchSetsURL()
        
        return willFetchCache(forUrl: url)
    }
    
    public func fetchSets(sortDescriptors: [NSSortDescriptor]?) async throws -> [MGSet] {
        let url = try fetchSetsURL()
        
        return try await fetchData(url: url,
                                   jsonType: MSet.self,
                                   coreDataType: MGSet.self,
                                   predicate: nil,
                                   sortDescriptors: sortDescriptors)
    }

    // MARK: - fetchCard(:)

    public func willFetchCard(newID: String) throws -> Bool {
        let url = try fetchCardURL(newID: newID)
        
        return willFetchCache(forUrl: url)
    }
    
    public func fetchCard(newID: String) async throws -> MGCard? {
        let url = try fetchCardURL(newID: newID)
        let predicate = NSPredicate(format: "newID == %@", newID)
        
        return try await fetchData(url: url,
                                   jsonType: MCard.self,
                                   coreDataType: MGCard.self,
                                   predicate: predicate,
                                   sortDescriptors: nil).first
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
                           pageOffset: Int) async throws -> [MGCard] {
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
//        try await delete(SearchResult.self,
//                         predicate: NSPredicate(format: "url != %@",
//                                                url.absoluteString))
//        try await delete(LocalCache.self,
//                         predicate: NSPredicate(format: "url != %@",
//                                                url.absoluteString))

        let cards = try await fetchData(url: url,
                                        jsonType: MCard.self,
                                        coreDataType: MGCard.self,
                                        predicate: nil,
                                        sortDescriptors: nil)
        
        // add cards to searchResults
        let context = newBackgroundContext()
        for card in cards {
            let predicate = NSPredicate(format: "pageOffset == %i AND newID == %@",
                                        pageOffset,
                                        card.newIDCopy)

            var props = [String: Any]()
            props["pageOffset"] = pageOffset
            props["newID"] = card.newIDCopy
            props["url"] = url.absoluteString

            let _ = find(MGSearchResult.self,
                         properties: props,
                         predicate: predicate,
                         sortDescriptors: nil,
                         createIfNotFound: true,
                         context: context)
        }
        save(context: context)

        return cards
    }
    
    // MARK: - fetchCardOtherPrintings(::)

    public func willFetchCardOtherPrintings(newID: String,
                                            languageCode: String) throws -> Bool {
        let url = try fetchCardOtherPrintingsURL(newID: newID,
                                             languageCode: languageCode)
        
        return willFetchCache(forUrl: url)
    }
    
    public func fetchCardOtherPrintings(newID: String,
                                        languageCode: String,
                                        sortDescriptors: [NSSortDescriptor]?) async throws -> [MGCard] {
        let url = try fetchCardOtherPrintingsURL(newID: newID,
                                             languageCode: languageCode)
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let response = response as? HTTPURLResponse,
                  response.statusCode == 200 else {
                throw ManaKitError.invalidHttpResponse
            }
            
            let decoder = JSONDecoder()
            let jsonData = try decoder.decode([MCard].self, from: data)
            let predicate = NSPredicate(format: "newID == %@", newID)
            let context = newBackgroundContext()
            if let card = find(MGCard.self,
                               properties: nil,
                               predicate: predicate,
                               sortDescriptors: nil,
                               createIfNotFound: true,
                               context: context)?.first,
               let otherPrintings = syncToCoreData(jsonData,
                                                   jsonType: MCard.self,
                                                   coreDataType: MGCard.self,
                                                   sortDescriptors: sortDescriptors) {
                for otherPrinting in otherPrintings {
                    card.addToOtherPrintings(otherPrinting)
                }
                save(context: context)
                
                saveCache(forUrl: url)
                return otherPrintings
            } else {
                return []
            }
        } catch {
            deleteCache(forUrl: url)
            throw error
        }
    }
    
    // MARK: - fetchArtists()

    public func willFetchArtists() throws -> Bool {
        let url = try fetchArtistsURL()
        
        return willFetchCache(forUrl: url)
    }

    public func fetchArtists(sortDescriptors: [NSSortDescriptor]?) async throws -> [MGArtist] {
        let url = try fetchArtistsURL()
        let predicate = NSPredicate(format: "name != nil")

        return try await fetchData(url: url,
                                   jsonType: MArtist.self,
                                   coreDataType: MGArtist.self,
                                   predicate: predicate,
                                   sortDescriptors: sortDescriptors)
    }
    
    // MARK: - fetchColors()

    public func willFetchColors() throws -> Bool {
        let url = try fetchColorsURL()
        
        return willFetchCache(forUrl: url)
    }

    public func fetchColors(sortDescriptors: [NSSortDescriptor]?) async throws -> [MGColor] {
        let url = try fetchColorsURL()
        let predicate = NSPredicate(format: "name != nil")

        return try await fetchData(url: url,
                                   jsonType: MColor.self,
                                   coreDataType: MGColor.self,
                                   predicate: predicate,
                                   sortDescriptors: sortDescriptors)
    }
    
    // MARK: - fetchGames()

    public func willFetchGames() throws -> Bool {
        let url = try fetchGamesURL()
        
        return willFetchCache(forUrl: url)
    }

    public func fetchGames(sortDescriptors: [NSSortDescriptor]?) async throws -> [MGGame] {
        let url = try fetchGamesURL()
        let predicate = NSPredicate(format: "name != nil")

        return try await fetchData(url: url,
                                   jsonType: MGame.self,
                                   coreDataType: MGGame.self,
                                   predicate: predicate,
                                   sortDescriptors: sortDescriptors)
    }

    // MARK: - fetchKeywords()

    public func willFetchKeywords() throws -> Bool {
        let url = try fetchKeywordsURL()
        
        return willFetchCache(forUrl: url)
    }

    public func fetchKeywords(sortDescriptors: [NSSortDescriptor]?) async throws -> [MGKeyword] {
        let url = try fetchKeywordsURL()
        let predicate = NSPredicate(format: "name != nil")

        return try await fetchData(url: url,
                                   jsonType: MKeyword.self,
                                   coreDataType: MGKeyword.self,
                                   predicate: predicate,
                                   sortDescriptors: sortDescriptors)
    }
    
    // MARK: - fetchRarities()

    public func willFetchRarities() throws -> Bool {
        let url = try fetchRaritiesURL()
        
        return willFetchCache(forUrl: url)
    }
    
    public func fetchRarities(sortDescriptors: [NSSortDescriptor]?) async throws -> [MGRarity] {
        let url = try fetchRaritiesURL()
        let predicate = NSPredicate(format: "name != nil")

        return try await fetchData(url: url,
                                   jsonType: MRarity.self,
                                   coreDataType: MGRarity.self,
                                   predicate: predicate,
                                   sortDescriptors: sortDescriptors)
    }

    // MARK: - fetchCardTypes()

    public func willFetchCardTypes() throws -> Bool {
        let url = try fetchCardTypesURL()
        
        return willFetchCache(forUrl: url)
    }

    public func fetchCardTypes(sortDescriptors: [NSSortDescriptor]?) async throws -> [MGCardType] {
        let url = try fetchCardTypesURL()
        let predicate = NSPredicate(format: "name != nil")

        return try await fetchData(url: url,
                                   jsonType: MCardType.self,
                                   coreDataType: MGCardType.self,
                                   predicate: predicate,
                                   sortDescriptors: sortDescriptors)
    }
}
