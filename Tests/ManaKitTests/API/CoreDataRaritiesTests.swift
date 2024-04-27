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
        ManaKit.shared.configure(apiURL: "https://managuideapp.com")
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testWillFetchRarities() throws {
        do {
            let _ = try ManaKit.shared.willFetchRarities()
        } catch {
            print(error)
            XCTFail("willFetchRarities() error")
        }
    }

    func testFetchRarities() async throws {
        do {
            let rarities = try await ManaKit.shared.fetchRarities()
            XCTAssert(!rarities.isEmpty)
        } catch {
            print(error)
            XCTFail("fetchRarities(:) error")
        }
    }
}
