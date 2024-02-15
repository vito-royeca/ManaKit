//
//  CoreDataCardTests.swift
//
//
//  Created by Vito Royeca on 1/29/24.
//

import XCTest
import ManaKit

final class CoreDataCardTests: XCTestCase {
    let newID = "isd_en_51" // Delver of Secrets

    override func setUpWithError() throws {
        ManaKit.sharedCoreData.configure(apiURL: "https://managuideapp.com")
        Task {
            await ManaKit.sharedCoreData.setupResources()
        }
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testWillFetchCard() throws {
        do {
            let _ = try ManaKit.sharedCoreData.willFetchCard(newID: newID)
        } catch {
            XCTFail("willFetchCard(:) error")
            print(error)
        }
    }
    
    func testFetchCard() async throws {
        do {
            let card = try await ManaKit.sharedCoreData.fetchCard(newID: newID)
            XCTAssert(card != nil)
        } catch {
            XCTFail("fetchCard(:) error")
            print(error)
        }
    }

    func testWillFetchCards() throws {
        do {
            let _ = try ManaKit.sharedCoreData.willFetchCards(name: "angel",
                                                      rarities: [],
                                                      types: [],
                                                      keywords: [],
                                                      pageSize: 20,
                                                      pageOffset: 0)
        } catch {
            XCTFail("willFetchCards(::::::) error")
            print(error)
        }
    }

    func testFetchCards() async throws {
        do {
            let pageSize = 20
            let pageOffSet = 0

            let cards = try await ManaKit.sharedCoreData.fetchCards(name: "angel",
                                                            rarities: [],
                                                            types: [],
                                                            keywords: [],
                                                            pageSize: pageSize,
                                                            pageOffset: pageOffSet)
            XCTAssert(!cards.isEmpty)
        } catch {
            XCTFail("fetchCards(::::::) error")
            print(error)
        }
    }
    
    func testFetchCardsAllPages() async throws {
        do {
            let pageSize = 20
            var pageOffSet = 0

            var cards = try await ManaKit.sharedCoreData.fetchCards(name: "angel",
                                                            rarities: [],
                                                            types: [],
                                                            keywords: [],
                                                            pageSize: pageSize,
                                                            pageOffset: pageOffSet)
            XCTAssert(!cards.isEmpty)
            print("pageOffset \(pageOffSet) = \(cards.count) cards")
            
            repeat {
                pageOffSet += pageSize
                cards = try await ManaKit.sharedCoreData.fetchCards(name: "angel",
                                                            rarities: [],
                                                            types: [],
                                                            keywords: [],
                                                            pageSize: pageSize,
                                                            pageOffset: pageOffSet)
                XCTAssert(!cards.isEmpty)
                print("pageOffset \(pageOffSet) = \(cards.count) cards")
            } while cards.count >= pageSize

        } catch {
            XCTFail("fetchCards(::::::) error")
            print(error)
        }
    }
}
