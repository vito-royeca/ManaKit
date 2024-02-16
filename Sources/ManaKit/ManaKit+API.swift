//
//  ManaKit+API.swift
//
//
//  Created by Vito Royeca on 11/27/19.
//

import Foundation

public protocol API {
    // fetchSet
    func willFetchSet(code: String,
                      languageCode: String) throws -> Bool
    func fetchSet(code: String,
                  languageCode: String) async throws -> MGSet?

    // fetchSets
    func willFetchSets() throws -> Bool
    func fetchSets(sortDescriptors: [NSSortDescriptor]?) async throws -> [MGSet]

    // fetchCard
    func willFetchCard(newID: String) throws -> Bool
    func fetchCard(newID: String) async throws -> MGCard?

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
                    pageOffset: Int) async throws -> [MGCard]

    // fetchCardOtherPrintings
    func willFetchCardOtherPrintings(newID: String,
                                     languageCode: String) throws -> Bool
    func fetchCardOtherPrintings(newID: String,
                                 languageCode: String,
                                 sortDescriptors: [NSSortDescriptor]?) async throws -> [MGCard]
    
    // fetchArtists
    func willFetchArtists() throws -> Bool
    func fetchArtists(sortDescriptors: [NSSortDescriptor]?) async throws -> [MGArtist]

    // fetchColors
    func willFetchColors() throws -> Bool
    func fetchColors(sortDescriptors: [NSSortDescriptor]?) async throws -> [MGColor]

    // fetchGames
    func willFetchGames() throws -> Bool
    func fetchGames(sortDescriptors: [NSSortDescriptor]?) async throws -> [MGGame]

    // fetchKeywords
    func willFetchKeywords() throws -> Bool
    func fetchKeywords(sortDescriptors: [NSSortDescriptor]?) async throws -> [MGKeyword]

    // fetchRarities
    func willFetchRarities() throws -> Bool
    func fetchRarities(sortDescriptors: [NSSortDescriptor]?) async throws -> [MGRarity]

    // fetchCardTypes
    func willFetchCardTypes() throws -> Bool
    func fetchCardTypes(sortDescriptors: [NSSortDescriptor]?) async throws -> [MGCardType]
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
