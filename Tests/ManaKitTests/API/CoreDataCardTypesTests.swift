//
//  CoreDataCardTypesTests.swift
//
//
//  Created by Vito Royeca on 1/29/24.
//

import XCTest
import ManaKit

final class CoreDataCardTypesTests: XCTestCase {

    override func setUpWithError() throws {
        ManaKit.shared.configure(apiURL: "https://managuideapp.com")
        Task {
            await ManaKit.shared.setupResources()
        }
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testWillFetchCardTypes() throws {
        do {
            let _ = try ManaKit.shared.willFetchCardTypes()
        } catch {
            print(error)
            XCTFail("willCardTypes() error")
        }
    }

    func testFetchCardTypes() async throws {
        do {
            let cardTypes = try await ManaKit.shared.fetchCardTypes()
            XCTAssert(!cardTypes.isEmpty)
        } catch {
            print(error)
            XCTFail("fetchCardTypes(:) error")
        }
    }    
}
