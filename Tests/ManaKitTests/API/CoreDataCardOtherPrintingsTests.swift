//
//  CoreDataCardOtherPrintingsTests.swift
//
//
//  Created by Vito Royeca on 1/29/24.
//

import XCTest
import ManaKit

final class CoreDataCardOtherPrintingsTests: XCTestCase {
    let newID = "isd_en_51" // Delver of Secrets
    let languageCode = "en"

    override func setUpWithError() throws {
        ManaKit.sharedCoreData.configure(apiURL: "https://managuideapp.com")
        Task {
            await ManaKit.sharedCoreData.setupResources()
        }
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testWillFetchCardOtherPrintingsTest() throws {
        do {
            let _ = try ManaKit.sharedCoreData.willFetchCardOtherPrintings(newID: newID,
                                                                   languageCode: languageCode)
        } catch {
            print(error)
            XCTFail("willFetchCardOtherPrintings(::) error")
        }
    }

    func testFetchCardOtherPrintings() async throws {
        do {
            let objectID = try await ManaKit.sharedCoreData.fetchCard(newID: newID)
            XCTAssert(objectID != nil)

            let card = ManaKit.sharedCoreData.viewContext.object(with: objectID!) as? MGCard
            XCTAssert(card != nil)
            
            let language = card!.language
            XCTAssert(language != nil)
                
            let code = language!.code
            let cards = try await ManaKit.sharedCoreData.fetchCardOtherPrintings(newID: card!.newID,
                                                                                 languageCode: code)
            XCTAssert(!cards.isEmpty)
        } catch {
            print(error)
            XCTFail("fetchCardOtherPrintings(:::) error")
        }
    }

}
