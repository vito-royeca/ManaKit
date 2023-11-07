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

    func willFetchCards(query: String) throws -> Bool
    func fetchCards(query: String,
                    sortDescriptors: [NSSortDescriptor]?) async throws -> [MGCard]

    func willFetchCardOtherPrintings(newID: String,
                                     languageCode: String) throws -> Bool
    func fetchCardOtherPrintings(newID: String,
                                 languageCode: String,
                                 sortDescriptors: [NSSortDescriptor]?) async throws -> [MGCard]
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
                                          predicate: predicate,
                                          sortDescriptors: sortDescriptors)
            saveCache(forUrl: url)
            return entities ?? []
        } catch {
            deleteCache(forUrl: url)
            throw error
        }
    }

    public func willFetchSet(code: String,
                             languageCode: String) throws -> Bool {
        var urlComponents = URLComponents(string: apiURL)
        urlComponents?.path = "/set/\(code)/\(languageCode)"
        urlComponents?.queryItems = [URLQueryItem(name: "json", value: "true"),
                                     URLQueryItem(name: "mobile", value: "true")]
        
        guard let url = urlComponents?.url else {
            throw ManaKitError.badURL
        }
        
        return willFetchCache(forUrl: url)
    }

    public func fetchSet(code: String,
                         languageCode: String) async throws -> MGSet? {
        var urlComponents = URLComponents(string: apiURL)
        urlComponents?.path = "/set/\(code)/\(languageCode)"
        urlComponents?.queryItems = [URLQueryItem(name: "json", value: "true"),
                                     URLQueryItem(name: "mobile", value: "true")]
        
        guard let url = urlComponents?.url else {
            throw ManaKitError.badURL
        }
        
        let predicate = NSPredicate(format: "code == %@", code)
        let results = try await fetchData(url: url,
                                          jsonType: MSet.self,
                                          coreDataType: MGSet.self,
                                          predicate: predicate,
                                          sortDescriptors: nil)
        return results.first
    }
    
    public func willFetchSets() throws -> Bool {
        var urlComponents = URLComponents(string: apiURL)
        urlComponents?.path = "/sets"
        urlComponents?.queryItems = [URLQueryItem(name: "json", value: "true"),
                                     URLQueryItem(name: "mobile", value: "true")]
        
        guard let url = urlComponents?.url else {
            throw ManaKitError.badURL
        }
        
        return willFetchCache(forUrl: url)
    }

    public func fetchSets(sortDescriptors: [NSSortDescriptor]?) async throws -> [MGSet] {
        var urlComponents = URLComponents(string: apiURL)
        urlComponents?.path = "/sets"
        urlComponents?.queryItems = [URLQueryItem(name: "json", value: "true"),
                                     URLQueryItem(name: "mobile", value: "true")]
        
        guard let url = urlComponents?.url else {
            throw ManaKitError.badURL
        }
        
        return try await fetchData(url: url,
                                   jsonType: MSet.self,
                                   coreDataType: MGSet.self,
                                   predicate: nil,
                                   sortDescriptors: sortDescriptors)
    }

    public func willFetchCard(newID: String) throws -> Bool {
        var urlComponents = URLComponents(string: apiURL)
        urlComponents?.path = "/card/\(newID)"
        urlComponents?.queryItems = [URLQueryItem(name: "json", value: "true"),
                                     URLQueryItem(name: "mobile", value: "true")]
        
        guard let url = urlComponents?.url else {
            throw ManaKitError.badURL
        }
        
        return willFetchCache(forUrl: url)
    }

    public func fetchCard(newID: String) async throws -> MGCard? {
        var urlComponents = URLComponents(string: apiURL)
        urlComponents?.path = "/card/\(newID)"
        urlComponents?.queryItems = [URLQueryItem(name: "json", value: "true"),
                                     URLQueryItem(name: "mobile", value: "true")]
        
        guard let url = urlComponents?.url else {
            throw ManaKitError.badURL
        }
        
        let predicate = NSPredicate(format: "newID == %@", newID)
        let results = try await fetchData(url: url,
                                          jsonType: MCard.self,
                                          coreDataType: MGCard.self,
                                          predicate: predicate,
                                          sortDescriptors: nil)
        return results.first
    }

    public func willFetchCards(query: String) throws -> Bool {
        var urlComponents = URLComponents(string: apiURL)
        urlComponents?.path = "/search"
        urlComponents?.queryItems = [URLQueryItem(name: "sortedBy", value: ""),
                                     URLQueryItem(name: "orderBy", value: ""),
                                     URLQueryItem(name: "query", value: query),
                                     URLQueryItem(name: "json", value: "true"),
                                     URLQueryItem(name: "mobile", value: "true")]
        
        guard let url = urlComponents?.url else {
            throw ManaKitError.badURL
        }
        
        return willFetchCache(forUrl: url)
    }

    public func fetchCards(query: String,
                           sortDescriptors: [NSSortDescriptor]?) async throws -> [MGCard] {
        var urlComponents = URLComponents(string: apiURL)
        urlComponents?.path = "/search"
        urlComponents?.queryItems = [URLQueryItem(name: "sortedBy", value: ""),
                                     URLQueryItem(name: "orderBy", value: ""),
                                     URLQueryItem(name: "query", value: query),
                                     URLQueryItem(name: "json", value: "true"),
                                     URLQueryItem(name: "mobile", value: "true")]
        
        guard let url = urlComponents?.url else {
            throw ManaKitError.badURL
        }
        
        let predicate = NSPredicate(format: "newID != nil AND newID != '' AND collectorNumber != nil AND language.code = %@ AND name CONTAINS[cd] %@",
                                    "en",
                                    query)
        let results = try await fetchData(url: url,
                                          jsonType: MCard.self,
                                          coreDataType: MGCard.self,
                                          predicate: predicate,
                                          sortDescriptors: nil)
        return results
    }
    
    public func willFetchCardOtherPrintings(newID: String,
                                     languageCode: String) throws -> Bool {
        var urlComponents = URLComponents(string: apiURL)
        urlComponents?.path = "/printings/\(newID)/\(languageCode)"
        urlComponents?.queryItems = [URLQueryItem(name: "json", value: "true"),
                                     URLQueryItem(name: "mobile", value: "true")]
        
        guard let url = urlComponents?.url else {
            throw ManaKitError.badURL
        }
        
        return willFetchCache(forUrl: url)
    }

    public func fetchCardOtherPrintings(newID: String,
                                        languageCode: String,
                                        sortDescriptors: [NSSortDescriptor]?) async throws -> [MGCard] {
        var urlComponents = URLComponents(string: apiURL)
        urlComponents?.path = "/printings/\(newID)/\(languageCode)"
        urlComponents?.queryItems = [URLQueryItem(name: "json", value: "true"),
                                     URLQueryItem(name: "mobile", value: "true")]
        
        guard let url = urlComponents?.url else {
            throw ManaKitError.badURL
        }
        
        let predicate = NSPredicate(format: "newID == %@", newID)
        let results = try await fetchData(url: url,
                                          jsonType: MCard.self,
                                          coreDataType: MGCard.self,
                                          predicate: predicate,
                                          sortDescriptors: nil)
        return results
    }
}
