//
//  CoreDataRaritiesTests.swift
//
//
//  Created by Vito Royeca on 1/29/24.
//

import XCTest
import ManaKit

final class CoreDataRaritiesTests: XCTestCase {

    override func setUpWithError() throws {
        ManaKit.sharedCoreData.configure(apiURL: "https://managuideapp.com")
        Task {
            await ManaKit.sharedCoreData.setupResources()
        }
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testWillFetchRarities() throws {
        do {
            let _ = try ManaKit.sharedCoreData.willFetchRarities()
        } catch {
            print(error)
            XCTFail("willFetchRarities() error")
        }
    }

    func testFetchRarities() async throws {
        do {
            let rarities = try await ManaKit.sharedCoreData.fetchRarities(sortDescriptors: nil)
            XCTAssert(!rarities.isEmpty)
        } catch {
            print(error)
            XCTFail("fetchRarities(:) error")
        }
    }
    
    func testBatchInsertRarities() async throws {
        do {
            let url = try ManaKit.sharedCoreData.fetchRaritiesURL()
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let response = response as? HTTPURLResponse,
                  response.statusCode == 200 else {
                throw ManaKitError.invalidHttpResponse
            }

            let decoder = JSONDecoder()
            let jsonData = try decoder.decode([MRarity].self, from: data)
            print("jsonData=\(jsonData.count)")
            try await ManaKit.sharedCoreData.syncToCoreData(jsonData,
                                                            jsonType: MRarity.self)
            
            let request: NSFetchRequest<MGRarity> = MGRarity.fetchRequest()
            let rarities = try ManaKit.sharedCoreData.viewContext.fetch(request)
            print("rarities=\(rarities.count)")

            XCTAssert(jsonData.count == rarities.count)
        } catch {
            print(error)
            XCTFail("testBatchInsertKeywords() error")
        }
    }

}
