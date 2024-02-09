//
//  FetchArtistsTests.swift
//  
//
//  Created by Vito Royeca on 1/29/24.
//

import XCTest
import ManaKit

final class FetchArtistsTests: XCTestCase {

    override func setUpWithError() throws {
        ManaKit.sharedCoreData.configure(apiURL: "https://managuideapp.com")
        Task {
            await ManaKit.sharedCoreData.setupResources()
        }
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testWillFetchArtists() throws {
        do {
            let _ = try ManaKit.sharedCoreData.willFetchArtists()
        } catch {
            XCTFail("willFetchArtists() error")
            print(error)
        }
    }

    func testFetchArtists() async throws {
        do {
            let artists = try await ManaKit.sharedCoreData.fetchArtists(sortDescriptors: nil)
            XCTAssert(!artists.isEmpty)
        } catch {
            XCTFail("fetchArtists(:) error")
            print(error)
        }
    }

}
