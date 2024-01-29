//
//  FetchKeywordsTests.swift
//  
//
//  Created by Vito Royeca on 1/29/24.
//

import XCTest
import ManaKit

final class FetchKeywordsTests: XCTestCase {

    override func setUpWithError() throws {
        ManaKit.shared.configure(apiURL: "https://managuideapp.com")
        Task {
            await ManaKit.shared.setupResources()
        }
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testWillFetchKeywords() throws {
        do {
            let _ = try ManaKit.shared.willFetchKeywords()
        } catch {
            XCTFail("willFetchKeywords() error")
            print(error)
        }
    }

    func testFetchKeywords() async throws {
        do {
            let keywords = try await ManaKit.shared.fetchKeywords(sortDescriptors: nil)
            XCTAssert(!keywords.isEmpty)
        } catch {
            XCTFail("fetchKeywords(:) error")
            print(error)
        }
    }

}
