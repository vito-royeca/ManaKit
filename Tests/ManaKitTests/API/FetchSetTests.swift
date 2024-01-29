//
//  FetchSetTests.swift
//  
//
//  Created by Vito Royeca on 1/29/24.
//

import XCTest
import ManaKit

final class FetchSetTests: XCTestCase {
    let code = "lea"
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
            XCTFail("willFetchSet(::) error")
            print(error)
        }
    }
    
    func testFetchSet() async throws {
        do {
            let set = try await ManaKit.shared.fetchSet(code: code,
                                                        languageCode: languageCode)
            XCTAssert(set != nil)
        } catch {
            XCTFail("fetchSet(::) error")
            print(error)
        }
    }

    func testWillFetchSets() throws {
        do {
            let _ = try ManaKit.shared.willFetchSets()
        } catch {
            XCTFail("willFetchSets() error")
            print(error)
        }
    }

    func testFetchSets() async throws {
        do {
            let sets = try await ManaKit.shared.fetchSets(sortDescriptors: nil)
            XCTAssert(!sets.isEmpty)
        } catch {
            XCTFail("fetchSets(:) error")
            print(error)
        }
    }
}
