//
//  FetchGamesTests.swift
//  
//
//  Created by Vito Royeca on 1/29/24.
//

import XCTest
import ManaKit

final class FetchGamesTests: XCTestCase {

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
            XCTFail("willFetchGames() error")
            print(error)
        }
    }

    func testFetchGames() async throws {
        do {
            let games = try await ManaKit.sharedCoreData.fetchGames(sortDescriptors: nil)
            XCTAssert(!games.isEmpty)
        } catch {
            XCTFail("fetchGames(:) error")
            print(error)
        }
    }

}
