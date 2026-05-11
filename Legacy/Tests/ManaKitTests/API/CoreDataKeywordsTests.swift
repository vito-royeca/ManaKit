//
//  CoreDataKeywordsTests.swift
//
//
//  Created by Vito Royeca on 1/29/24.
//

import XCTest
import ManaKit

final class CoreDataKeywordsTests: XCTestCase {

    override func setUpWithError() throws {
        ManaKit.shared.configure(apiURL: "https://managuideapp.com")
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testWillFetchKeywords() throws {
        do {
            let _ = try ManaKit.shared.willFetchKeywords()
        } catch {
            print(error)
            XCTFail("willFetchKeywords() error")
        }
    }

    func testFetchKeywords() async throws {
        do {
            let keywords = try await ManaKit.shared.fetchKeywords()
            XCTAssert(!keywords.isEmpty)
        } catch {
            print(error)
            XCTFail("fetchKeywords(:) error")
        }
    }
}
