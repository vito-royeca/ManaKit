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
        ManaKit.shared.configure(apiURL: "https://managuideapp.com")
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testWillFetchCardOtherPrintingsTest() throws {
        do {
            let _ = try ManaKit.shared.willFetchCardOtherPrintings(newID: newID,
                                                                   languageCode: languageCode)
        } catch {
            print(error)
            XCTFail("willFetchCardOtherPrintings(::) error")
        }
    }

    func testFetchCardOtherPrintings() async throws {
        do {
            let objectID = try await ManaKit.shared.fetchCard(newID: newID)
            XCTAssert(objectID != nil)

            let card = ManaKit.shared.viewContext.object(with: objectID!) as? MGCard
            XCTAssert(card != nil)
            
            let language = card!.language
            XCTAssert(language != nil)
                
            let code = language!.code
            let cards = try await ManaKit.shared.fetchCardOtherPrintings(newID: card!.newID,
                                                                         languageCode: code)
            XCTAssert(!cards.isEmpty)
        } catch {
            print(error)
            XCTFail("fetchCardOtherPrintings(:::) error")
        }
    }

}
