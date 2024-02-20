//
//  CoreDataSetTests.swift
//
//
//  Created by Vito Royeca on 1/29/24.
//

import XCTest
import ManaKit

final class CoreDataSetTests: XCTestCase {
    let code = "rvr"
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
            let objectID = try await ManaKit.sharedCoreData.fetchSet(code: code,
                                                                     languageCode: languageCode)
            XCTAssert(objectID != nil)
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
            let sets = try await ManaKit.sharedCoreData.fetchSets()
            XCTAssert(!sets.isEmpty)
        } catch {
            print(error)
            XCTFail("fetchSets(:) error")
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
            let objectIDs = try await ManaKit.sharedCoreData.syncToCoreData(jsonData,
                                                                            jsonType: MSet.self)
            
            for objectID in objectIDs {
                if let set = ManaKit.sharedCoreData.viewContext.object(with: objectID) as? MGSet {
                    for language in set.sortedLanguages ?? [] {
                        print("\(Date()) fetching \(set.code)_\(language.code)...")
                        try await fetchCards(from: set.code,
                                             languageCode: language.code)
                    }
                }
            }
        } catch {
            print(error)
            XCTFail("testBatchInsertSets() error")
        }
    }
    
    func fetchCards(from setCode: String, languageCode: String) async throws {
        do {
            let objectID = try await ManaKit.sharedCoreData.fetchSet(code: setCode,
                                                                     languageCode: languageCode)
            XCTAssert(objectID != nil)
        } catch {
            print(error)
            XCTFail("testCards() error")
        }
    }
}
