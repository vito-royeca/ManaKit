//
//  ManaKit+API.swift
//  Pods
//
//  Created by Vito Royeca on 11/27/19.
//

import Combine
import CoreData

public protocol API {
    func fetchSets(predicate: NSPredicate?,
                   sortDescriptors: [NSSortDescriptor]?,
                   cancellables: inout Set<AnyCancellable>,
                   completion: @escaping (Result<[MSet], Error>) -> Void)

    func fetchSet(code: String,
                  languageCode: String,
                  cancellables: inout Set<AnyCancellable>,
                  completion: @escaping (Result<MSet, Error>) -> Void)

    func fetchCards(query: String,
                    predicate: NSPredicate?,
                    sortDescriptors: [NSSortDescriptor]?,
                    cancellables: inout Set<AnyCancellable>,
                    completion: @escaping (Result<[MCard], Error>) -> Void)

    func fetchCard(newId: String,
                   cancellables: inout Set<AnyCancellable>,
                   completion: @escaping (Result<MCard, Error>) -> Void)
}

extension ManaKit: API {
    public func fetchSets(predicate: NSPredicate?,
                          sortDescriptors: [NSSortDescriptor]?,
                          cancellables: inout Set<AnyCancellable>,
                          completion: @escaping (Result<[MSet], Error>) -> Void) {
        guard let url = URL(string: "\(apiURL)/sets?json=true") else {
            completion(.failure(ManaKitError.badURL))
            return
        }
        
        fetchData(MGSet.self,
                  properties: nil,
                  predicate: predicate,
                  sortDescriptors: sortDescriptors,
                  url: url,
                  cancellables: &cancellables,
                  completion: { result in
            switch result {
            case .success(let sets):
                completion(.success(sets.map{ $0.toModel() }))
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
    
    public func fetchSet(code: String,
                         languageCode: String,
                         cancellables: inout Set<AnyCancellable>,
                         completion: @escaping (Result<MSet, Error>) -> Void) {
        guard let url = URL(string: "\(apiURL)/set/\(code)/\(languageCode)?json=true") else {
            completion(.failure(ManaKitError.badURL))
            return
        }
        
        fetchOneData(MGSet.self,
                     properties: nil,
                     predicate: NSPredicate(format: "code == %@", code),
                     sortDescriptors: nil,
                     url: url,
                     cancellables: &cancellables,
                     completion: { result in
            switch result {
            case .success(let set):
                completion(.success(set.toModel()))
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
    
    public func fetchCards(query: String,
                           predicate: NSPredicate?,
                           sortDescriptors: [NSSortDescriptor]?,
                           cancellables: inout Set<AnyCancellable>,
                           completion: @escaping (Result<[MCard], Error>) -> Void) {
        guard let url = URL(string: "\(apiURL)/search?displayAs=&sortedBy=&orderBy=&query=\(query)&json=true") else {
            completion(.failure(ManaKitError.badURL))
            return
        }
        
        fetchData(MGCard.self,
                  properties: nil,
                  predicate: predicate,
                  sortDescriptors: sortDescriptors,
                  url: url,
                  cancellables: &cancellables,
                  completion:  { result in
            switch result {
            case .success(let cards):
                completion(.success(cards.map{ $0.toModel() }))
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
    
    public func fetchCard(newId: String,
                          cancellables: inout Set<AnyCancellable>,
                          completion: @escaping (Result<MCard, Error>) -> Void) {
        guard let url = URL(string: "\(apiURL)/card/\(newId)?json=true") else {
            completion(.failure(ManaKitError.badURL))
            return
        }
        
        fetchOneData(MGCard.self,
                     properties: nil,
                     predicate: NSPredicate(format: "newId == %@", newId),
                     sortDescriptors: nil,
                     url: url,
                     cancellables: &cancellables,
                     completion: { result in
            switch result {
            case .success(let card):
                completion(.success(card.toModel()))
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
}
