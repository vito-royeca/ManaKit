//
//  FetchCardOtherPrintingsTests.swift
//  
//
//  Created by Vito Royeca on 1/29/24.
//

import XCTest
import ManaKit

final class FetchCardOtherPrintingsTests: XCTestCase {
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
            XCTFail("willFetchCardOtherPrintings(::) error")
            print(error)
        }
    }

    func testFetchCardOtherPrintings() async throws {
        do {
            let card = try await ManaKit.sharedCoreData.fetchCard(newID: newID)
            XCTAssert(card != nil)

            let language = card!.language
            XCTAssert(language != nil)
            
            let code = language!.code
            XCTAssert(code != nil)
            
            let cards = try await ManaKit.sharedCoreData.fetchCardOtherPrintings(newID: card!.newID,
                                                                         languageCode: code!,
                                                                         sortDescriptors: nil)
            XCTAssert(!cards.isEmpty)
        } catch {
            XCTFail("fetchCardOtherPrintings(:::) error")
            print(error)
        }
    }

}
