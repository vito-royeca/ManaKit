//
//  APITest.swift
//  ManaKit_ExampleTests
//
//  Created by Vito Royeca on 12/22/21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import XCTest
import Combine
import ManaKit

class APITest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        print("docsPath = \(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])")
        ManaKit.shared.configure(apiURL: "http://managuideapp.com")
        ManaKit.shared.setupResources()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

    func testFetchAll() {
        let expectation = XCTestExpectation(description: "testFetchSets")

        let sortDescriptors = [NSSortDescriptor(key: "releaseDate", ascending: false),
                               NSSortDescriptor(key: "name", ascending: true)]
        
        var cancellables1 = Set<AnyCancellable>()
        ManaKit.shared.fetchSets(query: nil, sortDescriptors: sortDescriptors, cancellables: &cancellables1, completion: { result in
            switch result {
            case .success(let sets):
                XCTAssert(!sets.isEmpty)
        
                for code in sets.map({ $0.code ?? ""}) {
                    var cancellables2 = Set<AnyCancellable>()
                    ManaKit.shared.fetchSet(code: code, languageCode: "en", cancellables: &cancellables2, completion: { result in
                        switch result {
                        case .success(let set):
                            XCTAssert(set.code == code)
                            
                            for newId in (set.cards?.allObjects as? [MGCard] ?? [MGCard]()).map({ $0.newId ?? ""}) {
                                var cancellables3 = Set<AnyCancellable>()
                                ManaKit.shared.fetchCard(id: newId, cancellables: &cancellables3, completion: { result in
                                    switch result {
                                    case .success(let card):
                                        XCTAssert(card.newId == newId)
                                        expectation.fulfill()
                                    case .failure(let error):
                                        print(error)
                                        XCTFail()
                                        expectation.fulfill()
                                    }
                                })
                            }

                            
                        case .failure(let error):
                            print(error)
                            XCTFail()
                        }
                    })
                }
                
            case .failure(let error):
                print(error)
                XCTFail()
            }
        })

        wait(for: [expectation], timeout: 3600.0)
    }
    
    func testFetchSets() {
        let expectation = XCTestExpectation(description: "testFetchSets")

        let sortDescriptors = [NSSortDescriptor(key: "releaseDate", ascending: false),
                               NSSortDescriptor(key: "name", ascending: true)]
        var cancellables = Set<AnyCancellable>()
        ManaKit.shared.fetchSets(query: nil, sortDescriptors: sortDescriptors, cancellables: &cancellables, completion: { result in
            switch result {
            case .success(let sets):
                XCTAssert(!sets.isEmpty)
                expectation.fulfill()
            case .failure(let error):
                print(error)
                XCTFail()
            }
        })

        wait(for: [expectation], timeout: 10.0)
    }
    
    func testFetchSet() {
        let expectation = XCTestExpectation(description: "testFetchSet")
        
        
        let code = "voc"
        let languageCode = "en"
        var cancellables = Set<AnyCancellable>()
        ManaKit.shared.fetchSet(code: code, languageCode: languageCode, cancellables: &cancellables, completion: { result in
            switch result {
            case .success(let set):
                XCTAssert(set.code == code)
                expectation.fulfill()
            case .failure(let error):
                print(error)
                XCTFail()
            }
        })
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testFetchCard() {
        let expectation = XCTestExpectation(description: "testFetchCard")
        var cancellables = Set<AnyCancellable>()
        
        let newId = "emn_en_15a" // Bruna, the Fading Light - for testing component parts
        ManaKit.shared.fetchCard(id: newId, cancellables: &cancellables, completion: { result in
            switch result {
            case .success(let card):
                XCTAssert(card.newId == newId)
                expectation.fulfill()
            case .failure(let error):
                print(error)
                XCTFail()
                expectation.fulfill()
            }
        })
        
        wait(for: [expectation], timeout: 10.0)
    }
}
