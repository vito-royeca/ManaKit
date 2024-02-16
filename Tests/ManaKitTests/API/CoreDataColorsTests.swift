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
            print(error)
            XCTFail("willFetchColors() error")
        }
    }

    func testFetchColors() async throws {
        do {
            let colors = try await ManaKit.sharedCoreData.fetchColors(sortDescriptors: nil)
            XCTAssert(!colors.isEmpty)
        } catch {
            print(error)
            XCTFail("fetchColors(:) error")
        }
    }
    
    func testBatchInsertColors() async throws {
        do {
            let url = try ManaKit.sharedCoreData.fetchColorsURL()
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let response = response as? HTTPURLResponse,
                  response.statusCode == 200 else {
                throw ManaKitError.invalidHttpResponse
            }

            let decoder = JSONDecoder()
            let jsonData = try decoder.decode([MColor].self, from: data)
            print("jsonData=\(jsonData.count)")
            try await ManaKit.sharedCoreData.syncToCoreData(jsonData,
                                                            jsonType: MColor.self)
            
            let request: NSFetchRequest<MGColor> = MGColor.fetchRequest()
            let colors = try ManaKit.sharedCoreData.viewContext.fetch(request)
            print("colors=\(colors.count)")

            XCTAssert(jsonData.count == colors.count)
        } catch {
            print(error)
            XCTFail("testBatchInsertColors() error")
        }
    }

}
