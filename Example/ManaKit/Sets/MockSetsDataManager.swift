//
//  MockSetsDataManager.swift
//  ManaKit
//
//  Created by Vito Royeca on 10/7/21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import Foundation
import ManaKit

class MockSetsDataManager {
    private var sets = [MGSet]()
        
}

extension MockSetsDataManager: SetsDataManagerProtocol {
    func fetchData(completion: @escaping (Result<[MGSet], Error>) -> Void) {
        do {
            let data = try JSONSerialization.data(withJSONObject: [
                [
                    "cardCount": Int32(295),
                    "code": "lea",
                    "dateCreated": Date(),
                    "dateUpdated": Date(),
                    "isFoilOnly": false,
                    "isOnlineOnly": false,
                    "keyruneClass": "lea",
                    "keyruneUnicode": "e600",
                    "name": "Limited Edition Alpha",
                    "releaseDate": "1993-08-06"
                ],
                [
                    "cardCount": Int32(295),
                    "code": "leb",
                    "dateCreated": Date(),
                    "dateUpdated": Date(),
                    "isFoilOnly": false,
                    "isOnlineOnly": false,
                    "keyruneClass": "leb",
                    "keyruneUnicode": "e601",
                    "name": "Limited Edition Beta",
                    "releaseDate": "1993-10-04"
                ]
            ], options: [])
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            decoder.userInfo[CodingUserInfoKey.managedObjectContext] = ManaKit.shared.persistentContainer.viewContext
            sets = try decoder.decode([MGSet].self, from: data)
            
            completion(.success(sets))
        } catch {
            completion(.failure(JSONDataError.unableToParse))
        }
    }
}
