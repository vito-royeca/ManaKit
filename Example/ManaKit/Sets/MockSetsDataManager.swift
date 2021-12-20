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
//        sets = [
//            SetModel(
//                cardCount: Int32(295),
//                code: "lea",
//                dateCreated: Date(),
//                dateUpdated: Date(),
//                isFoilOnly: false,
//                isOnlineOnly: false,
//                keyruneClass: "",
//                keyruneUnicode: "e600",
//                mtgoCode: "",
//                myNameSection: "",
//                myYearSection: "",
//                name: "Limited Edition Alpha",
//                releaseDate: "1993-08-06",
//                tcgPlayerId: Int32(0)
//            ),
//            SetModel(
//                cardCount: Int32(295),
//                code: "leb",
//                dateCreated: Date(),
//                dateUpdated: Date(),
//                isFoilOnly: false,
//                isOnlineOnly: false,
//                keyruneClass: "",
//                keyruneUnicode: "e601",
//                mtgoCode: "",
//                myNameSection: "",
//                myYearSection: "",
//                name: "Limited Edition Beta",
//                releaseDate: "1993-10-04",
//                tcgPlayerId: Int32(0)
//            )
//        ]
        completion(.success(self.sets))
    }
}
