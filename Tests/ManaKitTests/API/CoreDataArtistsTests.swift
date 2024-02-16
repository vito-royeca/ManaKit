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
            print(error)
            XCTFail("fetchArtists(:) error")
        }
    }
    
    func testBatchInsertArtists() async throws {
        do {
            let url = try ManaKit.sharedCoreData.fetchArtistsURL()
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let response = response as? HTTPURLResponse,
                  response.statusCode == 200 else {
                throw ManaKitError.invalidHttpResponse
            }

            let decoder = JSONDecoder()
            let jsonData = try decoder.decode([MArtist].self, from: data)
            print("jsonData=\(jsonData.count)")
            try await ManaKit.sharedCoreData.syncToCoreData(jsonData,
                                                            jsonType: MArtist.self)
            
            let request: NSFetchRequest<MGArtist> = MGArtist.fetchRequest()
            let artists = try ManaKit.sharedCoreData.viewContext.fetch(request)
            print("artists=\(artists.count)")

            XCTAssert(jsonData.count == artists.count)
        } catch {
            print(error)
            XCTFail("testBatchInsertArtists() error")
        }
    }
}
