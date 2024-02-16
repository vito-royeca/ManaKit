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
        ManaKit.sharedCoreData.configure(apiURL: "https://managuideapp.com")
        Task {
            await ManaKit.sharedCoreData.setupResources()
        }
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testWillFetchCardTypes() throws {
        do {
            let _ = try ManaKit.sharedCoreData.willFetchCardTypes()
        } catch {
            print(error)
            XCTFail("willCardTypes() error")
        }
    }

    func testFetchCardTypes() async throws {
        do {
            let cardTypes = try await ManaKit.sharedCoreData.fetchCardTypes(sortDescriptors: nil)
            XCTAssert(!cardTypes.isEmpty)
        } catch {
            print(error)
            XCTFail("fetchCardTypes(:) error")
        }
    }
    
    func testBatchInsertCardTypes() async throws {
        do {
            let url = try ManaKit.sharedCoreData.fetchCardTypesURL()
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let response = response as? HTTPURLResponse,
                  response.statusCode == 200 else {
                throw ManaKitError.invalidHttpResponse
            }

            let decoder = JSONDecoder()
            let jsonData = try decoder.decode([MCardType].self, from: data)
            print("jsonData=\(jsonData.count)")
            try await ManaKit.sharedCoreData.syncToCoreData(jsonData,
                                                            jsonType: MCardType.self)
            
            let request: NSFetchRequest<MGCardType> = MGCardType.fetchRequest()
            let cardTypes = try ManaKit.sharedCoreData.viewContext.fetch(request)
            print("cardTypes=\(cardTypes.count)")

            XCTAssert(jsonData.count == cardTypes.count)
        } catch {
            print(error)
            XCTFail("testBatchInsertCardTypes() error")
        }
    }

}
