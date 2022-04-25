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
                  languageCode: String,
                  completion: @escaping (Result<MGSet?, Error>) -> Void)
    
    func fetchSets(completion: @escaping (Result<Void, Error>) -> Void)

    func fetchCard(newID: String,
                   completion: @escaping (Result<MGCard?, Error>) -> Void)

    func fetchCards(query: String,
                    completion: @escaping (Result<Void, Error>) -> Void)
}

extension ManaKit: API {
    public func fetchSet(code: String,
                         languageCode: String,
                         completion: @escaping (Result<MGSet?, Error>) -> Void) {
        var urlComponents = URLComponents(string: apiURL)
        urlComponents?.path = "/set/\(code)/\(languageCode)"
        urlComponents?.queryItems = [URLQueryItem(name: "json", value: "true"),
                                     URLQueryItem(name: "mobile", value: "true")]
        
        guard let url = urlComponents?.url else {
            completion(.failure(ManaKitError.badURL))
            return
        }
        
        fetchData(MSet.self,
                  url: url,
                  completion: { result in
            switch result {
            case .success:
                let result = self.find(MGSet.self,
                                       properties: nil,
                                       predicate: NSPredicate(format: "code == %@", code),
                                       sortDescriptors: nil,
                                       createIfNotFound: false,
                                       context: self.viewContext)

                completion(.success(result?.first))
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }

    public func fetchSets(completion: @escaping (Result<Void, Error>) -> Void) {
        var urlComponents = URLComponents(string: apiURL)
        urlComponents?.path = "/sets"
        urlComponents?.queryItems = [URLQueryItem(name: "json", value: "true"),
                                     URLQueryItem(name: "mobile", value: "true")]
        
        guard let url = urlComponents?.url else {
            completion(.failure(ManaKitError.badURL))
            return
        }
        
        fetchData(MSet.self,
                  url: url,
                  completion: { result in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }

    public func fetchCard(newID: String,
                          completion: @escaping (Result<MGCard?, Error>) -> Void) {
        var urlComponents = URLComponents(string: apiURL)
        urlComponents?.path = "/card/\(newID)"
        urlComponents?.queryItems = [URLQueryItem(name: "json", value: "true"),
                                     URLQueryItem(name: "mobile", value: "true")]
        
        guard let url = urlComponents?.url else {
            completion(.failure(ManaKitError.badURL))
            return
        }
        
        fetchData(MCard.self,
                  url: url,
                  completion: { result in
            switch result {
            case .success:
                let result = self.find(MGCard.self,
                                       properties: nil,
                                       predicate: NSPredicate(format: "newID == %@", newID),
                                       sortDescriptors: nil,
                                       createIfNotFound: false,
                                       context: self.viewContext)
                
                completion(.success(result?.first))
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }

    public func fetchCards(query: String,
                           completion: @escaping (Result<Void, Error>) -> Void) {
        var urlComponents = URLComponents(string: apiURL)
        urlComponents?.path = "/search"
        urlComponents?.queryItems = [URLQueryItem(name: "sortedBy", value: ""),
                                     URLQueryItem(name: "sortedBy", value: ""),
                                     URLQueryItem(name: "orderBy", value: ""),
                                     URLQueryItem(name: "query", value: query),
                                     URLQueryItem(name: "json", value: "true"),
                                     URLQueryItem(name: "mobile", value: "true")]
        
        guard let url = urlComponents?.url else {
            completion(.failure(ManaKitError.badURL))
            return
        }
        
        fetchData(MCard.self,
                  url: url,
                  completion:  { result in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
}
