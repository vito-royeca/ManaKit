//
//  ManaKit+API.swift
//  Pods
//
//  Created by Vito Royeca on 11/27/19.
//

import Combine
import CoreData

public protocol API {
    func fetchSets(query: [String: Any]?,
                   sortDescriptors: [NSSortDescriptor]?,
                   cancellables: inout Set<AnyCancellable>,
                   completion: @escaping (Result<[MGSet], Error>) -> Void)
    
    func fetchSet(code: String,
                  languageCode: String,
                  cancellables: inout Set<AnyCancellable>,
                  completion: @escaping (Result<[MGSet], Error>) -> Void)
    
    func fetchCards(query: String,
                    cancellables: inout Set<AnyCancellable>,
                    completion: @escaping (Result<[MGCard], Error>) -> Void)
    
    func fetchCard(id: String,
                   cancellables: inout Set<AnyCancellable>,
                   completion: @escaping (Result<[MGCard], Error>) -> Void)
}

extension ManaKit: API {
    public func fetchSets(query: [String: Any]?,
                          sortDescriptors: [NSSortDescriptor]?,
                          cancellables: inout Set<AnyCancellable>,
                          completion: @escaping (Result<[MGSet], Error>) -> Void) {
        guard let url = URL(string: "\(apiURL)/sets?json=true") else {
            completion(.failure(ManaKitError.badURL))
            return
        }
        
        fetchData(MGSet.self,
                  query: query,
                  sortDescriptors: sortDescriptors,
                  url: url,
                  cancellables: &cancellables,
                  completion: completion)
    }
    
    public func fetchSet(code: String,
                         languageCode: String,
                         cancellables: inout Set<AnyCancellable>,
                         completion: @escaping (Result<[MGSet], Error>) -> Void) {
        guard let url = URL(string: "\(apiURL)/set/\(code)/\(languageCode)?json=true") else {
            completion(.failure(ManaKitError.badURL))
            return
        }
        
        fetchData(MGSet.self,
                  query: nil,
                  sortDescriptors: nil,
                  url: url,
                  cancellables: &cancellables,
                  completion: completion)
    }
    
    public func fetchCards(query: String,
                           cancellables: inout Set<AnyCancellable>,
                           completion: @escaping (Result<[MGCard], Error>) -> Void) {
        guard let url = URL(string: "\(apiURL)/search?query=\(query)?json=true") else {
            completion(.failure(ManaKitError.badURL))
            return
        }
        
        fetchData(MGCard.self,
                  query: nil,
                  sortDescriptors: nil,
                  url: url,
                  cancellables: &cancellables,
                  completion: completion)
    }
    
    public func fetchCard(id: String,
                          cancellables: inout Set<AnyCancellable>,
                          completion: @escaping (Result<[MGCard], Error>) -> Void) {
        guard let url = URL(string: "\(apiURL)/card/\(id)?json=true") else {
            completion(.failure(ManaKitError.badURL))
            return
        }
        
        fetchData(MGCard.self,
                  query: nil,
                  sortDescriptors: nil,
                  url: url,
                  cancellables: &cancellables,
                  completion: completion)
    }
}
