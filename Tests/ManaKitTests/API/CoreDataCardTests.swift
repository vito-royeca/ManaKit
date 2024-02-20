//
//  CoreDataCardTests.swift
//
//
//  Created by Vito Royeca on 1/29/24.
//

import XCTest
import ManaKit

final class CoreDataCardTests: XCTestCase {
    let newID = "wwk_en_31"

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
            print(error)
            XCTFail("willFetchCard(:) error")
        }
    }
    
    func testFetchCard() async throws {
        do {
            let objectID = try await ManaKit.sharedCoreData.fetchCard(newID: newID)
            XCTAssert(objectID != nil)
        } catch {
            print(error)
            XCTFail("fetchCard(:) error")
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
            print(error)
            XCTFail("willFetchCards(::::::) error")
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
            print(error)
            XCTFail("fetchCards(::::::) error")
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
            print(error)
            XCTFail("fetchCards(::::::) error")
        }
    }
}
