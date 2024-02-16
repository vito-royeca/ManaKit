//
//  CoreDataKeywordsTests.swift
//
//
//  Created by Vito Royeca on 1/29/24.
//

import XCTest
import ManaKit

final class CoreDataKeywordsTests: XCTestCase {

    override func setUpWithError() throws {
        ManaKit.sharedCoreData.configure(apiURL: "https://managuideapp.com")
        Task {
            await ManaKit.sharedCoreData.setupResources()
        }
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testWillFetchKeywords() throws {
        do {
            let _ = try ManaKit.sharedCoreData.willFetchKeywords()
        } catch {
            print(error)
            XCTFail("willFetchKeywords() error")
        }
    }

    func testFetchKeywords() async throws {
        do {
            let keywords = try await ManaKit.sharedCoreData.fetchKeywords(sortDescriptors: nil)
            XCTAssert(!keywords.isEmpty)
        } catch {
            print(error)
            XCTFail("fetchKeywords(:) error")
        }
    }
    
    func testBatchInsertKeywords() async throws {
        do {
            let url = try ManaKit.sharedCoreData.fetchKeywordsURL()
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let response = response as? HTTPURLResponse,
                  response.statusCode == 200 else {
                throw ManaKitError.invalidHttpResponse
            }

            let decoder = JSONDecoder()
            let jsonData = try decoder.decode([MKeyword].self, from: data)
            print("jsonData=\(jsonData.count)")
            try await ManaKit.sharedCoreData.syncToCoreData(jsonData,
                                                            jsonType: MKeyword.self)
            
            let request: NSFetchRequest<MGKeyword> = MGKeyword.fetchRequest()
            let keywords = try ManaKit.sharedCoreData.viewContext.fetch(request)
            print("keywords=\(keywords.count)")

            XCTAssert(jsonData.count == keywords.count)
        } catch {
            print(error)
            XCTFail("testBatchInsertKeywords() error")
        }
    }

}
