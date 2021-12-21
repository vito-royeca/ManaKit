//
//  SetsDataManager.swift
//  ManaKit_Example
//
//  Created by Vito Royeca on 10/7/21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import Foundation
import Combine

public protocol SetsDataManagerProtocol {
    func fetchData(completion: @escaping (Result<[MGSet], Error>) -> Void)
}

public class SetsDataManager {
    public static let shared: SetsDataManagerProtocol = SetsDataManager()
        
    private var sets = [MGSet]()
        
    private init() { }
    deinit {
        cancelable?.cancel()
    }
    
    private var cancelable: AnyCancellable?
    private static let sessionProcessingQueue = DispatchQueue(label: "SessionProcessingQueue")

}

// MARK: - SetsDataManagerProtocol

extension SetsDataManager: SetsDataManagerProtocol {
    public func fetchData(completion: @escaping (Result<[MGSet], Error>) -> Void) {
        let query = ["page": Int32(0)]
        let sortDescriptors = [NSSortDescriptor(key: "releaseDate", ascending: false),
                               NSSortDescriptor(key: "name", ascending: true)]
        let done = {
            self.sets = ManaKit.shared.find(MGSet.self,
                                            query: nil,
                                            sortDescriptors: sortDescriptors,
                                            createIfNotFound: false) ?? [MGSet]()
            completion(.success(self.sets))
        }
        
        if ManaKit.shared.willFetchCache(MGSet.self, query: query) {
            guard let url = URL(string: "\(ManaKit.shared.apiURL)/sets?json=true") else {
                completion(.failure(ManaKitError.badURL))
                return
            }
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            decoder.userInfo[CodingUserInfoKey.managedObjectContext] = ManaKit.shared.persistentContainer.viewContext
            
            cancelable = URLSession.shared.dataTaskPublisher(for: url)
                .subscribe(on: Self.sessionProcessingQueue)
                .map({
                    return $0.data
                })
                .decode(type: [MGSet].self, decoder: decoder)
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { (suscriberCompletion) in
                    switch suscriberCompletion {
                    case .finished:
                        done()
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }, receiveValue: { _ /*[weak self] (sets)*/ in
                    do {
                        try ManaKit.shared.persistentContainer.viewContext.save()
                    } catch {
                        print(error)
                    }
                })
            
    //
    //        let request = URLRequest(url: url)
    //        URLSession.shared.dataTask(with: request) { data, response, error in
    //            if let error = error {
    //                completion(.failure(error))
    //            } else {
    //                if let data = data {
    //                    let decoder = JSONDecoder()
    //                    decoder.keyDecodingStrategy = .convertFromSnakeCase
    //
    //                    if let response_obj = try? decoder.decode([SetModel].self, from: data) {
    //                        self.sets = response_obj
    //                        completion(.success(self.sets))
    //                    }
    //                }
    //            }
    //        }.resume()
        } else {
            done()
        }
    }
}
