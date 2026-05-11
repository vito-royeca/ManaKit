//
//  CoreDataArtistsTests.swift
//
//
//  Created by Vito Royeca on 1/29/24.
//

import XCTest
import ManaKit

final class CoreDataArtistsTests: XCTestCase {

    override func setUpWithError() throws {
        ManaKit.shared.configure(apiURL: "https://managuideapp.com")
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testWillFetchArtists() throws {
        do {
            let _ = try ManaKit.shared.willFetchArtists()
        } catch {
            XCTFail("willFetchArtists() error")
            print(error)
        }
    }

    func testFetchArtists() async throws {
        do {
            let artists = try await ManaKit.shared.fetchArtists()
            XCTAssert(!artists.isEmpty)
        } catch {
            print(error)
            XCTFail("fetchArtists(:) error")
        }
    }
}
