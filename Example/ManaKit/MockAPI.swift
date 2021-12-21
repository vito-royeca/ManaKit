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
    func fetchSets(query: [String: Any]?,
                   sortDescriptors: [NSSortDescriptor]?,
                   cancellables: inout Set<AnyCancellable>,
                   completion: @escaping (Result<[MGSet], Error>) -> Void) {
        do {
            let data = try JSONSerialization.data(withJSONObject: [
                [
                    "cardCount": Int32(295),
                    "code": "lea",
                    "keyruneClass": "lea",
                    "keyruneUnicode": "e600",
                    "name": "Limited Edition Alpha",
                    "releaseDate": "1993-08-06"
                ],
                [
                    "cardCount": Int32(295),
                    "code": "leb",
                    "keyruneClass": "leb",
                    "keyruneUnicode": "e601",
                    "name": "Limited Edition Beta",
                    "releaseDate": "1993-10-04"
                ]
            ], options: [])
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            decoder.userInfo[CodingUserInfoKey.managedObjectContext] = ManaKit.shared.persistentContainer.viewContext
            let sets = try decoder.decode([MGSet].self, from: data)
            
            completion(.success(sets))
        } catch {
            completion(.failure(JSONDataError.unableToParse))
        }
    }
    
    func fetchSet(code: String,
                  languageCode: String,
                  cancellables: inout Set<AnyCancellable>,
                  completion: @escaping (Result<[MGSet], Error>) -> Void) {
        
    }
    
    func fetchCards(query: String,
                    cancellables: inout Set<AnyCancellable>,
                    completion: @escaping (Result<[MGCard], Error>) -> Void) {
        
    }
    
    func fetchCard(id: String,
                   cancellables: inout Set<AnyCancellable>,
                   completion: @escaping (Result<[MGCard], Error>) -> Void) {
        
    }
}
