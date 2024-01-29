//
//  FetchRaritiesTests.swift
//  
//
//  Created by Vito Royeca on 1/29/24.
//

import XCTest
import ManaKit

final class FetchRaritiesTests: XCTestCase {

    override func setUpWithError() throws {
        ManaKit.shared.configure(apiURL: "https://managuideapp.com")
        Task {
            await ManaKit.shared.setupResources()
        }
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testWillFetchRarities() throws {
        do {
            let _ = try ManaKit.shared.willFetchRarities()
        } catch {
            XCTFail("willFetchRarities() error")
            print(error)
        }
    }

    func testFetchRarities() async throws {
        do {
            let rarities = try await ManaKit.shared.fetchRarities(sortDescriptors: nil)
            XCTAssert(!rarities.isEmpty)
        } catch {
            XCTFail("fetchRarities(:) error")
            print(error)
        }
    }

}
