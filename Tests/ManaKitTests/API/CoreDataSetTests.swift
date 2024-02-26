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
        ManaKit.shared.configure(apiURL: "https://managuideapp.com")
        Task {
            await ManaKit.shared.setupResources()
        }
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testWillFetchSet() throws {
        do {
            let _ = try ManaKit.shared.willFetchSet(code: code,
                                                    languageCode: languageCode)
        } catch {
            print(error)
            XCTFail("willFetchSet(::) error")
        }
    }
    
    func testFetchSet() async throws {
        do {
            let objectID = try await ManaKit.shared.fetchSet(code: code,
                                                             languageCode: languageCode)
            XCTAssert(objectID != nil)
        } catch {
            print(error)
            XCTFail("fetchSet(::) error")
        }
    }

    func testWillFetchSets() throws {
        do {
            let _ = try ManaKit.shared.willFetchSets()
        } catch {
            print(error)
            XCTFail("willFetchSets() error")
        }
    }

    func testFetchSets() async throws {
        do {
            let sets = try await ManaKit.shared.fetchSets()
            XCTAssert(!sets.isEmpty)
        } catch {
            print(error)
            XCTFail("fetchSets(:) error")
        }
    }
}
