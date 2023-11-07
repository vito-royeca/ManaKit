//
//  ManaKit+API.swift
//  Pods
//
//  Created by Vito Royeca on 11/27/19.
//

import Combine
import CoreData

public protocol API {
    func fetchSet(code: String,
                  languageCode: String) async throws -> MGSet?
    func fetchSets(sortDescriptors: [NSSortDescriptor]?) async throws -> [MGSet]
    
    func fetchCard(newID: String) async throws -> MGCard?
    func fetchCards(query: String,
                    sortDescriptors: [NSSortDescriptor]?) async throws -> [MGCard]

    func fetchCardOtherPrintings(newID: String,
                                 languageCode: String,
                                 sortDescriptors: [NSSortDescriptor]?) async throws -> [MGCard]
}

extension ManaKit: API {
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
