//
//  CoreDataColorsTests.swift
//
//
//  Created by Vito Royeca on 1/29/24.
//

import XCTest
import ManaKit

final class CoreDataColorsTests: XCTestCase {

    override func setUpWithError() throws {
        ManaKit.sharedCoreData.configure(apiURL: "https://managuideapp.com")
        Task {
            await ManaKit.sharedCoreData.setupResources()
        }
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testWillFetchColors() throws {
        do {
            let _ = try ManaKit.sharedCoreData.willFetchColors()
        } catch {
            XCTFail("willFetchColors() error")
            print(error)
        }
    }

    func testFetchColors() async throws {
        do {
            let colors = try await ManaKit.sharedCoreData.fetchColors(sortDescriptors: nil)
            XCTAssert(!colors.isEmpty)
        } catch {
            XCTFail("fetchColors(:) error")
            print(error)
        }
    }

}
