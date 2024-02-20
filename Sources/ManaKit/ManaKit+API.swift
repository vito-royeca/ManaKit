//
//  ManaKit+API.swift
//
//
//  Created by Vito Royeca on 11/27/19.
//

import Foundation
import CoreData

public protocol API {
    // fetchSet
    func willFetchSet(code: String,
                      languageCode: String) throws -> Bool
    func fetchSet(code: String,
                  languageCode: String) async throws -> NSManagedObjectID?

    // fetchSets
    func willFetchSets() throws -> Bool
    func fetchSets() async throws -> [NSManagedObjectID]

    // fetchCard
    func willFetchCard(newID: String) throws -> Bool
    func fetchCard(newID: String) async throws -> NSManagedObjectID?

    // fetchCards
    func willFetchCards(name: String,
                        rarities: [String],
                        types: [String],
                        keywords: [String],
                        pageSize: Int,
                        pageOffset: Int) throws -> Bool
    func fetchCards(name: String,
                    rarities: [String],
                    types: [String],
                    keywords: [String],
                    pageSize: Int,
                    pageOffset: Int) async throws -> [NSManagedObjectID]

    // fetchCardOtherPrintings
    func willFetchCardOtherPrintings(newID: String,
                                     languageCode: String) throws -> Bool
    func fetchCardOtherPrintings(newID: String,
                                 languageCode: String) async throws -> [NSManagedObjectID]
    
    // fetchArtists
    func willFetchArtists() throws -> Bool
    func fetchArtists() async throws -> [NSManagedObjectID]

    // fetchColors
    func willFetchColors() throws -> Bool
    func fetchColors() async throws -> [NSManagedObjectID]

    // fetchGames
    func willFetchGames() throws -> Bool
    func fetchGames() async throws -> [NSManagedObjectID]

    // fetchKeywords
    func willFetchKeywords() throws -> Bool
    func fetchKeywords() async throws -> [NSManagedObjectID]

    // fetchRarities
    func willFetchRarities() throws -> Bool
    func fetchRarities() async throws -> [NSManagedObjectID]

    // fetchCardTypes
    func willFetchCardTypes() throws -> Bool
    func fetchCardTypes() async throws -> [NSManagedObjectID]
}

extension ManaKit {
    public func fetchSetURL(code: String,
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

    public func fetchSetsURL() throws -> URL {
        var urlComponents = URLComponents(string: apiURL)
        urlComponents?.path = "/sets"
        urlComponents?.queryItems = [URLQueryItem(name: "json", value: "true"),
                                     URLQueryItem(name: "mobile", value: "true")]
        
        guard let url = urlComponents?.url else {
            throw ManaKitError.badURL
        }
        
        return url
    }
    
    public func fetchCardURL(newID: String) throws -> URL {
        var urlComponents = URLComponents(string: apiURL)
        urlComponents?.path = "/card/\(newID)"
        urlComponents?.queryItems = [URLQueryItem(name: "json", value: "true"),
                                     URLQueryItem(name: "mobile", value: "true")]
        
        guard let url = urlComponents?.url else {
            throw ManaKitError.badURL
        }
        
        return url
    }
    
    public func fetchCardsURL(name: String,
                              rarities: [String],
                              types: [String],
                              keywords: [String],
                              pageSize: Int,
                              pageOffset: Int) throws -> URL {
        var queryItems = [URLQueryItem(name: "sortedBy", value: ""),
                          URLQueryItem(name: "orderBy", value: ""),
                          URLQueryItem(name: "name", value: name),
                          URLQueryItem(name: "json", value: "true"),
                          URLQueryItem(name: "mobile", value: "true")]
        queryItems.append(contentsOf: rarities.map { URLQueryItem(name: "rarities[]", value: $0) })
        queryItems.append(contentsOf: types.map { URLQueryItem(name: "types[]", value: $0) })
        queryItems.append(contentsOf: keywords.map { URLQueryItem(name: "keywords[]", value: $0) })
        queryItems.append(URLQueryItem(name: "pageSize", value: "\(pageSize)"))
        queryItems.append(URLQueryItem(name: "pageOffset", value: "\(pageOffset)"))

        var urlComponents = URLComponents(string: apiURL)
        urlComponents?.path = "/advancesearch"
        urlComponents?.queryItems = queryItems
        
        
        guard let url = urlComponents?.url else {
            throw ManaKitError.badURL
        }
        
        return url
    }
    
    public func fetchCardOtherPrintingsURL(newID: String,
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

    public func fetchArtistsURL() throws -> URL {
        var urlComponents = URLComponents(string: apiURL)
        urlComponents?.path = "/artists"
        urlComponents?.queryItems = [URLQueryItem(name: "json", value: "true"),
                                     URLQueryItem(name: "mobile", value: "true")]
        
        guard let url = urlComponents?.url else {
            throw ManaKitError.badURL
        }
        
        return url
    }

    public func fetchColorsURL() throws -> URL {
        var urlComponents = URLComponents(string: apiURL)
        urlComponents?.path = "/colors"
        urlComponents?.queryItems = [URLQueryItem(name: "json", value: "true"),
                                     URLQueryItem(name: "mobile", value: "true")]
        
        guard let url = urlComponents?.url else {
            throw ManaKitError.badURL
        }
        
        return url
    }

    public func fetchGamesURL() throws -> URL {
        var urlComponents = URLComponents(string: apiURL)
        urlComponents?.path = "/games"
        urlComponents?.queryItems = [URLQueryItem(name: "json", value: "true"),
                                     URLQueryItem(name: "mobile", value: "true")]
        
        guard let url = urlComponents?.url else {
            throw ManaKitError.badURL
        }
        
        return url
    }

    public func fetchKeywordsURL() throws -> URL {
        var urlComponents = URLComponents(string: apiURL)
        urlComponents?.path = "/keywords"
        urlComponents?.queryItems = [URLQueryItem(name: "json", value: "true"),
                                     URLQueryItem(name: "mobile", value: "true")]
        
        guard let url = urlComponents?.url else {
            throw ManaKitError.badURL
        }
        
        return url
    }

    public func fetchRaritiesURL() throws -> URL {
        var urlComponents = URLComponents(string: apiURL)
        urlComponents?.path = "/rarities"
        urlComponents?.queryItems = [URLQueryItem(name: "json", value: "true"),
                                     URLQueryItem(name: "mobile", value: "true")]
        
        guard let url = urlComponents?.url else {
            throw ManaKitError.badURL
        }
        
        return url
    }

    public func fetchCardTypesURL() throws -> URL {
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
