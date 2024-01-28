//
//  ManaKit+API.swift
//  Pods
//
//  Created by Vito Royeca on 11/27/19.
//

import Combine
import CoreData

public protocol API {
    func willFetchSet(code: String,
                      languageCode: String) throws -> Bool
    func fetchSet(code: String,
                  languageCode: String) async throws -> MGSet?

    func willFetchSets() throws -> Bool
    func fetchSets(sortDescriptors: [NSSortDescriptor]?) async throws -> [MGSet]
    
    func willFetchCard(newID: String) throws -> Bool
    func fetchCard(newID: String) async throws -> MGCard?

    func willFetchCards(name: String,
                        colors: [String],
                        rarities: [String],
                        types: [String],
                        keywords: [String]) throws -> Bool
    func fetchCards(name: String,
                    colors: [String],
                    rarities: [String],
                    types: [String],
                    keywords: [String],
                    sortDescriptors: [NSSortDescriptor]?) async throws -> [MGCard]

    func willFetchCardOtherPrintings(newID: String,
                                     languageCode: String) throws -> Bool
    func fetchCardOtherPrintings(newID: String,
                                 languageCode: String,
                                 sortDescriptors: [NSSortDescriptor]?) async throws -> [MGCard]
    
    func willFetchArtists() throws -> Bool
    func fetchArtists(sortDescriptors: [NSSortDescriptor]?) async throws -> [MGArtist]

    func willFetchColors() throws -> Bool
    func fetchColors(sortDescriptors: [NSSortDescriptor]?) async throws -> [MGColor]
    
    func willFetchGames() throws -> Bool
    func fetchGames(sortDescriptors: [NSSortDescriptor]?) async throws -> [MGGame]

    func willFetchKeywords() throws -> Bool
    func fetchKeywords(sortDescriptors: [NSSortDescriptor]?) async throws -> [MGKeyword]

    func willFetchRarities() throws -> Bool
    func fetchRarities(sortDescriptors: [NSSortDescriptor]?) async throws -> [MGRarity]
    
    func willFetchCardTypes() throws -> Bool
    func fetchCardTypes(sortDescriptors: [NSSortDescriptor]?) async throws -> [MGCardType]
}

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
    
    private func fetchSetURL(code: String,
                             languageCode: String) throws -> URL {
        var urlComponents = URLComponents(string: apiURL)
        urlComponents?.path = "/set/\(code)/\(languageCode)"
        urlComponents?.queryItems = [URLQueryItem(name: "json", value: "true"),
                                     URLQueryItem(name: "mobile", value: "true")]
        
        guard let url = urlComponents?.url else {
            throw ManaKitError.badURL
        }
        
        return url
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

    private func fetchSetsURL() throws -> URL {
        var urlComponents = URLComponents(string: apiURL)
        urlComponents?.path = "/sets"
        urlComponents?.queryItems = [URLQueryItem(name: "json", value: "true"),
                                     URLQueryItem(name: "mobile", value: "true")]
        
        guard let url = urlComponents?.url else {
            throw ManaKitError.badURL
        }
        
        return url
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
    
    private func fetchCardURL(newID: String) throws -> URL {
        var urlComponents = URLComponents(string: apiURL)
        urlComponents?.path = "/card/\(newID)"
        urlComponents?.queryItems = [URLQueryItem(name: "json", value: "true"),
                                     URLQueryItem(name: "mobile", value: "true")]
        
        guard let url = urlComponents?.url else {
            throw ManaKitError.badURL
        }
        
        return url
    }
    
    // MARK: - fetchCards(::::)

    public func willFetchCards(name: String,
                               colors: [String],
                               rarities: [String],
                               types: [String],
                               keywords: [String]) throws -> Bool {
        let url = try fetchCardsURL(name: name,
                                    colors: colors,
                                    rarities: rarities,
                                    types: types,
                                    keywords: keywords)
        
        return willFetchCache(forUrl: url)
    }
    
    public func fetchCards(name: String,
                           colors: [String],
                           rarities: [String],
                           types: [String],
                           keywords: [String],
                           sortDescriptors: [NSSortDescriptor]?) async throws -> [MGCard] {
        let url = try fetchCardsURL(name: name,
                                    colors: colors,
                                    rarities: rarities,
                                    types: types,
                                    keywords: keywords)
        let format = "newID != nil AND newID != '' AND collectorNumber != nil AND language.code = %@"
        var predicate = NSPredicate(format: format,
                                    "en")
        
        if !name.isEmpty {
            predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate,
                                                                            NSPredicate(format: "name CONTAINS[cd] %@",
                                                                                        name)
            ])
        }
        if !colors.isEmpty {
            predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate,
                                                                            NSPredicate(format: "ANY colors.symbol IN %@",
                                                                                        colors)
            ])
        }
        if !rarities.isEmpty {
            predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate,
                                                                            NSPredicate(format: "rarity.name IN %@",
                                                                                        rarities)
            ])
        }
        if !types.isEmpty {
            predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate,
                                                                            NSPredicate(format: "ANY supertypes.name IN %@",
                                                                                        types)
            ])
        }
        if !keywords.isEmpty {
            predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate,
                                                                            NSPredicate(format: "ANY keywords.name IN %@",
                                                                                        keywords)
            ])
        }
        
        return try await fetchData(url: url,
                                   jsonType: MCard.self,
                                   coreDataType: MGCard.self,
                                   predicate: predicate,
                                   sortDescriptors: sortDescriptors)
    }
    
    private func fetchCardsURL(name: String,
                               colors: [String],
                               rarities: [String],
                               types: [String],
                               keywords: [String]) throws -> URL {
        var queryItems = [URLQueryItem(name: "sortedBy", value: ""),
                          URLQueryItem(name: "orderBy", value: ""),
                          URLQueryItem(name: "name", value: name),
                          URLQueryItem(name: "json", value: "true"),
                          URLQueryItem(name: "mobile", value: "true")]
        queryItems.append(contentsOf: colors.map { URLQueryItem(name: "colors[]", value: $0) })
        queryItems.append(contentsOf: rarities.map { URLQueryItem(name: "rarities[]", value: $0) })
        queryItems.append(contentsOf: types.map { URLQueryItem(name: "types[]", value: $0) })
        queryItems.append(contentsOf: keywords.map { URLQueryItem(name: "keywords[]", value: $0) })
        
        var urlComponents = URLComponents(string: apiURL)
        urlComponents?.path = "/advancesearch"
        urlComponents?.queryItems = queryItems
        
        
        guard let url = urlComponents?.url else {
            throw ManaKitError.badURL
        }
        
        return url
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
            let newIDs = jsonData.map{ $0.newID }
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
    
    private func fetchCardOtherPrintingsURL(newID: String,
                                         languageCode: String) throws -> URL {
        var urlComponents = URLComponents(string: apiURL)
        urlComponents?.path = "/printings/\(newID)/\(languageCode)"
        urlComponents?.queryItems = [URLQueryItem(name: "json", value: "true"),
                                     URLQueryItem(name: "mobile", value: "true")]
        
        guard let url = urlComponents?.url else {
            throw ManaKitError.badURL
        }
        
        return url
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
    
    private func fetchArtistsURL() throws -> URL {
        var urlComponents = URLComponents(string: apiURL)
        urlComponents?.path = "/artists"
        urlComponents?.queryItems = [URLQueryItem(name: "json", value: "true"),
                                     URLQueryItem(name: "mobile", value: "true")]
        
        guard let url = urlComponents?.url else {
            throw ManaKitError.badURL
        }
        
        return url
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
    
    private func fetchColorsURL() throws -> URL {
        var urlComponents = URLComponents(string: apiURL)
        urlComponents?.path = "/colors"
        urlComponents?.queryItems = [URLQueryItem(name: "json", value: "true"),
                                     URLQueryItem(name: "mobile", value: "true")]
        
        guard let url = urlComponents?.url else {
            throw ManaKitError.badURL
        }
        
        return url
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
    
    private func fetchGamesURL() throws -> URL {
        var urlComponents = URLComponents(string: apiURL)
        urlComponents?.path = "/games"
        urlComponents?.queryItems = [URLQueryItem(name: "json", value: "true"),
                                     URLQueryItem(name: "mobile", value: "true")]
        
        guard let url = urlComponents?.url else {
            throw ManaKitError.badURL
        }
        
        return url
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
    
    private func fetchKeywordsURL() throws -> URL {
        var urlComponents = URLComponents(string: apiURL)
        urlComponents?.path = "/keywords"
        urlComponents?.queryItems = [URLQueryItem(name: "json", value: "true"),
                                     URLQueryItem(name: "mobile", value: "true")]
        
        guard let url = urlComponents?.url else {
            throw ManaKitError.badURL
        }
        
        return url
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

    private func fetchRaritiesURL() throws -> URL {
        var urlComponents = URLComponents(string: apiURL)
        urlComponents?.path = "/rarities"
        urlComponents?.queryItems = [URLQueryItem(name: "json", value: "true"),
                                     URLQueryItem(name: "mobile", value: "true")]
        
        guard let url = urlComponents?.url else {
            throw ManaKitError.badURL
        }
        
        return url
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
    
    private func fetchCardTypesURL() throws -> URL {
        var urlComponents = URLComponents(string: apiURL)
        urlComponents?.path = "/cardtypes"
        urlComponents?.queryItems = [URLQueryItem(name: "json", value: "true"),
                                     URLQueryItem(name: "mobile", value: "true")]
        
        guard let url = urlComponents?.url else {
            throw ManaKitError.badURL
        }
        
        return url
    }
}
