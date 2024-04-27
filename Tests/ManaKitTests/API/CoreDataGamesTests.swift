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
        ManaKit.shared.configure(apiURL: "https://managuideapp.com")
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testWillFetchGames() throws {
        do {
            let _ = try ManaKit.shared.willFetchGames()
        } catch {
            print(error)
            XCTFail("willFetchGames() error")
        }
    }

    func testFetchGames() async throws {
        do {
            let games = try await ManaKit.shared.fetchGames()
            XCTAssert(!games.isEmpty)
        } catch {
            print(error)
            XCTFail("fetchGames(:) error")
        }
    }
}
