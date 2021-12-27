//
//  MockAPI.swift
//  ManaKit
//
//  Created by Vito Royeca on 10/7/21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import Foundation
import Combine
import ManaKit

class MockAPI: API {
    let decoder = JSONDecoder()
    
    init() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSZ"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .formatted(formatter)
        decoder.userInfo[CodingUserInfoKey.managedObjectContext] = ManaKit.shared.persistentContainer.viewContext
    }
    
    func fetchSets(query: [String: Any]?,
                   sortDescriptors: [NSSortDescriptor]?,
                   cancellables: inout Set<AnyCancellable>,
                   completion: @escaping (Result<[MGSet], Error>) -> Void) {
        do {
            let data = try JSONSerialization.data(withJSONObject: [
                [
                    "card_count": Int32(199),
                    "code": "all",
                    "keyrune_class": "all",
                    "keyrune_unicode": "e61a",
                    "name": "Alliances",
                    "release_date": "1996-06-10"
                ],
                [
                    "card_count": Int32(208),
                    "code": "emn",
                    "keyrune_class": "emn",
                    "keyrune_unicode": "e90b",
                    "name": "Eldritch Moon",
                    "release_date": "2016-07-22"
                ]
            ], options: [])
            let sets = try decoder.decode([MGSet].self, from: data)
            
            completion(.success(sets))
        } catch {
            completion(.failure(JSONDataError.unableToParse))
        }
    }
    
    func fetchSet(code: String,
                  languageCode: String,
                  cancellables: inout Set<AnyCancellable>,
                  completion: @escaping (Result<MGSet, Error>) -> Void) {
        do {
            let bundle = Bundle(for: MockAPI.self)
            
            guard let jsonURL = bundle.url(forResource: "data/\(code)_en", withExtension: "json") else {
                fatalError("Can't load file: \(code)_en.json")
            }
            
            let data = try Data(contentsOf: jsonURL)
            let sets = try decoder.decode([MGSet].self, from: data)
            
            completion(.success(sets[0]))
        } catch {
            completion(.failure(JSONDataError.unableToParse))
        }
    }
    
    func fetchCards(query: String,
                    cancellables: inout Set<AnyCancellable>,
                    completion: @escaping (Result<[MGCard], Error>) -> Void) {
        
    }
    
    func fetchCard(id: String,
                   cancellables: inout Set<AnyCancellable>,
                   completion: @escaping (Result<MGCard, Error>) -> Void) {
        
    }
}
