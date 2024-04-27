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
        ManaKit.shared.configure(apiURL: "https://managuideapp.com")
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testWillFetchColors() throws {
        do {
            let _ = try ManaKit.shared.willFetchColors()
        } catch {
            print(error)
            XCTFail("willFetchColors() error")
        }
    }

    func testFetchColors() async throws {
        do {
            let colors = try await ManaKit.shared.fetchColors()
            XCTAssert(!colors.isEmpty)
        } catch {
            print(error)
            XCTFail("fetchColors(:) error")
        }
    }
}
