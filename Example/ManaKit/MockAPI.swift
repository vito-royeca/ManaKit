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
                    "card_count": Int32(295),
                    "code": "lea",
                    "keyrune_class": "lea",
                    "keyrune_unicode": "e600",
                    "name": "Limited Edition Alpha",
                    "release_date": "1993-08-06"
                ],
                [
                    "card_count": Int32(302),
                    "code": "2ed",
                    "keyrune_class": "2ed",
                    "keyrune_unicode": "e602",
                    "name": "Unlimited Edition",
                    "release_date": "1993-12-01"
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
            let data = try JSONSerialization.data(withJSONObject: [
                [
                    "name": "Unlimited Edition",
                    "code": "2ed",
                    "cards":
                    [
                        [
                            "new_id": "2ed_en_29",
                            "name": "Mesa Pegasus",
                            "set": ["name": "Unlimited Edition", "code": "2ed", "keyrune_class": "2ed"],
                            "rarity": ["name": "Common", "name_section": "C"],
                            "mana_cost": "{1}{W}",
                            "image_uris":
                            [
                                ["art_crop": "/images/cards/2ed/en/29/art_crop.jpg", "normal": "/images/cards/2ed/en/29/normal.jpg", "png": "/images/cards/2ed/en/29/png.png"]
                            ]
                        ]
                    ]
                ]
            ], options: [])
            let set = try decoder.decode(MGSet.self, from: data)
            
            completion(.success(set))
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
