//
//  SwiftDataSetTests.swift
//  
//
//  Created by Vito Royeca on 2/14/24.
//

import XCTest
import ManaKit

final class SwiftDataSetTests: XCTestCase {
    let code = "lea"
    let languageCode = "en"

    override func setUpWithError() throws {
        ManaKit.sharedSwiftData.configure(apiURL: "https://managuideapp.com")
        Task {
            await ManaKit.sharedSwiftData.setupResources()
        }
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testWillFetchSet() throws {
        do {
            let _ = try ManaKit.sharedSwiftData.willFetchSet(code: code,
                                                             languageCode: languageCode)
        } catch {
            XCTFail("willFetchSet(::) error")
            print(error)
        }
    }
    
    func testFetchSet() async throws {
        do {
            if let set: SDSet = try await ManaKit.sharedSwiftData.fetchSet(code: code,
                                                                           languageCode: languageCode) {
                XCTAssert(set.code == code)
            } else {
                XCTFail("fetchSet(::) error")
            }
        } catch {
            XCTFail("fetchSet(::) error")
            print(error)
        }
    }

}
