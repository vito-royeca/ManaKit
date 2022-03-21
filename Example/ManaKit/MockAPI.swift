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
    let setFile = "unf_en"
    let setCode = "unf"
    let newID   = "unf_en_279"

    init() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSZ"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        
        decoder.dateDecodingStrategy = .formatted(formatter)
        decoder.userInfo[CodingUserInfoKey.managedObjectContext] = ManaKit.shared.viewContext
    }
    
    func fetchSets(cancellables: inout Set<AnyCancellable>,
                   completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let bundle = Bundle(for: MockAPI.self)
            
            guard let jsonURL = bundle.url(forResource: "data/sets", withExtension: "json") else {
                fatalError("Can't load file: data/sets.json")
            }
            
            let data = try Data(contentsOf: jsonURL)
            let sets = try decoder.decode([MSet].self, from: data)
            ManaKit.shared.syncToCoreData(sets)
            
            completion(.success(()))
        } catch {
            completion(.failure(JSONDataError.unableToParse))
        }
    }
    
    func fetchSet(code: String,
                  languageCode: String,
                  cancellables: inout Set<AnyCancellable>,
                  completion: @escaping (Result<MGSet?, Error>) -> Void) {
        do {
            let bundle = Bundle(for: MockAPI.self)
            
            guard let jsonURL = bundle.url(forResource: "data/\(setFile)", withExtension: "json") else {
                fatalError("Can't load file: data/\(setFile).json")
            }
            
            let data = try Data(contentsOf: jsonURL)
            let set = try decoder.decode([MSet].self, from: data)
            ManaKit.shared.syncToCoreData(set)
            
            let result = ManaKit.shared.find(MGSet.self,
                                             properties: nil,
                                             predicate: NSPredicate(format: "code == %@", setCode),
                                             sortDescriptors: nil,
                                             createIfNotFound: false,
                                             context: ManaKit.shared.viewContext)
            
            completion(.success(result?.first))
        } catch {
            completion(.failure(JSONDataError.unableToParse))
        }
    }
    
    func fetchCards(query: String,
                    cancellables: inout Set<AnyCancellable>,
                    completion: @escaping (Result<Void, Error>) -> Void) {
        
    }
    
    func fetchCard(newID: String,
                   cancellables: inout Set<AnyCancellable>,
                   completion: @escaping (Result<MGCard?, Error>) -> Void) {
        do {
            let bundle = Bundle(for: MockAPI.self)
            
            guard let jsonURL = bundle.url(forResource: "data/\(newID)", withExtension: "json") else {
                fatalError("Can't load file: data/\(newID).json")
            }
            
            let data = try Data(contentsOf: jsonURL)
            let cards = try decoder.decode([MCard].self, from: data)
            ManaKit.shared.syncToCoreData(cards)
            
            let result = ManaKit.shared.find(MGCard.self,
                                             properties: nil,
                                             predicate: NSPredicate(format: "newID == %@", newID),
                                             sortDescriptors: nil,
                                             createIfNotFound: false,
                                             context: ManaKit.shared.viewContext)
            
            completion(.success(result?.first))
        } catch {
            completion(.failure(JSONDataError.unableToParse))
        }
    }
}
