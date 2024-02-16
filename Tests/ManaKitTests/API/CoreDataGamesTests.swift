//
//  CoreDataGamesTests.swift
//
//
//  Created by Vito Royeca on 1/29/24.
//

import XCTest
import ManaKit

final class CoreDataGamesTests: XCTestCase {

    override func setUpWithError() throws {
        ManaKit.sharedCoreData.configure(apiURL: "https://managuideapp.com")
        Task {
            await ManaKit.sharedCoreData.setupResources()
        }
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testWillFetchGames() throws {
        do {
            let _ = try ManaKit.sharedCoreData.willFetchGames()
        } catch {
            print(error)
            XCTFail("willFetchGames() error")
        }
    }

    func testFetchGames() async throws {
        do {
            let games = try await ManaKit.sharedCoreData.fetchGames(sortDescriptors: nil)
            XCTAssert(!games.isEmpty)
        } catch {
            print(error)
            XCTFail("fetchGames(:) error")
        }
    }
    
    func testBatchInsertGames() async throws {
        do {
            let url = try ManaKit.sharedCoreData.fetchGamesURL()
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let response = response as? HTTPURLResponse,
                  response.statusCode == 200 else {
                throw ManaKitError.invalidHttpResponse
            }

            let decoder = JSONDecoder()
            let jsonData = try decoder.decode([MGame].self, from: data)
            print("jsonData=\(jsonData.count)")
            try await ManaKit.sharedCoreData.syncToCoreData(jsonData,
                                                            jsonType: MGame.self)
            
            let request: NSFetchRequest<MGGame> = MGGame.fetchRequest()
            let games = try ManaKit.sharedCoreData.viewContext.fetch(request)
            print("games=\(games.count)")

            XCTAssert(jsonData.count == games.count)
        } catch {
            print(error)
            XCTFail("testBatchInsertGames() error")
        }
    }

}
