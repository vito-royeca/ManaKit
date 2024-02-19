//
//  CoreDataSetTests.swift
//
//
//  Created by Vito Royeca on 1/29/24.
//

import XCTest
import ManaKit

final class CoreDataSetTests: XCTestCase {
    let code = "lea"
    let languageCode = "en"

    override func setUpWithError() throws {
        ManaKit.sharedCoreData.configure(apiURL: "https://managuideapp.com")
        Task {
            await ManaKit.sharedCoreData.setupResources()
        }
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testWillFetchSet() throws {
        do {
            let _ = try ManaKit.sharedCoreData.willFetchSet(code: code,
                                                            languageCode: languageCode)
        } catch {
            print(error)
            XCTFail("willFetchSet(::) error")
        }
    }
    
    func testFetchSet() async throws {
        do {
            if let set: MGSet = try await ManaKit.sharedCoreData.fetchSet(code: code,
                                                                             languageCode: languageCode) {
                XCTAssert(set.code == code)
            } else {
                XCTFail("fetchSet(::) error")
            }
        } catch {
            print(error)
            XCTFail("fetchSet(::) error")
        }
    }

    func testWillFetchSets() throws {
        do {
            let _ = try ManaKit.sharedCoreData.willFetchSets()
        } catch {
            print(error)
            XCTFail("willFetchSets() error")
        }
    }

    func testFetchSets() async throws {
        do {
            let sets = try await ManaKit.sharedCoreData.fetchSets(sortDescriptors: nil)
            XCTAssert(!sets.isEmpty)
        } catch {
            print(error)
            XCTFail("fetchSets(:) error")
        }
    }
    
    func testBatchInsertSets() async throws {
        do {
            let url = try ManaKit.sharedCoreData.fetchSetsURL()
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let response = response as? HTTPURLResponse,
                  response.statusCode == 200 else {
                throw ManaKitError.invalidHttpResponse
            }

            let decoder = JSONDecoder()
            let jsonData = try decoder.decode([MSet].self, from: data)
            print("jsonData=\(jsonData.count)")
            try await ManaKit.sharedCoreData.syncToCoreData(jsonData,
                                                            jsonType: MSet.self)
            
            let request: NSFetchRequest<MGSet> = MGSet.fetchRequest()
            let sets = try ManaKit.sharedCoreData.viewContext.fetch(request)
            print("sets=\(sets.count)")

            XCTAssert(jsonData.count == sets.count)
        } catch {
            print(error)
            XCTFail("testBatchInsertSets() error")
        }
    }

    func testBatchInsertSet() async throws {
        do {
            let setCode = "rvr"
            let languageCode = "en"
            let url = try ManaKit.sharedCoreData.fetchSetURL(code: setCode,
                                                             languageCode: languageCode)
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let response = response as? HTTPURLResponse,
                  response.statusCode == 200 else {
                throw ManaKitError.invalidHttpResponse
            }

            let decoder = JSONDecoder()
            let jsonData = try decoder.decode([MSet].self, from: data)
            try await ManaKit.sharedCoreData.syncToCoreData(jsonData,
                                                            jsonType: MSet.self)
            
            let request: NSFetchRequest<MGCard> = MGCard.fetchRequest()
            let predicate = NSPredicate(format: "set.code == %@ AND language.code == %@",
                                        setCode,
                                        languageCode)
            request.predicate = predicate

            let cards = try ManaKit.sharedCoreData.viewContext.fetch(request)
//            print("cards=\(cards.count)")

            XCTAssert(!cards.isEmpty)
        } catch {
            print(error)
            XCTFail("testBatchInsertSets() error")
        }
    }

    func testBatchInsertAllCards() async throws {
        do {
            let url = try ManaKit.sharedCoreData.fetchSetsURL()
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let response = response as? HTTPURLResponse,
                  response.statusCode == 200 else {
                throw ManaKitError.invalidHttpResponse
            }

            let decoder = JSONDecoder()
            let jsonData = try decoder.decode([MSet].self, from: data)
            try await ManaKit.sharedCoreData.syncToCoreData(jsonData,
                                                            jsonType: MSet.self)
            
            let request: NSFetchRequest<MGSet> = MGSet.fetchRequest()
            let sets = try ManaKit.sharedCoreData.viewContext.fetch(request)

            for set in sets {
                for language in set.sortedLanguages ?? [] {
                    print("\(Date()) fetching \(set.code)_\(language.code)...")
                    try await fetchCards(from: set.code,
                                         languageCode: language.code)
                }
                
            }
        } catch {
            print(error)
            XCTFail("testBatchInsertSets() error")
        }
    }
    
    func fetchCards(from setCode: String, languageCode: String) async throws {
        do {
            let url = try ManaKit.sharedCoreData.fetchSetURL(code: setCode,
                                                             languageCode: languageCode)
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let response = response as? HTTPURLResponse,
                  response.statusCode == 200 else {
                throw ManaKitError.invalidHttpResponse
            }

            let decoder = JSONDecoder()
            let jsonData = try decoder.decode([MSet].self, from: data)
            try await ManaKit.sharedCoreData.syncToCoreData(jsonData,
                                                            jsonType: MSet.self)
            
            let request: NSFetchRequest<MGSet> = MGSet.fetchRequest()
            let sets = try ManaKit.sharedCoreData.viewContext.fetch(request)
        } catch {
            print(error)
            XCTFail("testCards() error")
        }
    }
}
