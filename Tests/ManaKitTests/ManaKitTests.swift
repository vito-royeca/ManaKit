import XCTest
@testable import ManaKit

final class ManaKitTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        
    }

    static var allTests = [
        ("testExample", testExample),
    ]
    
    func testFetchAll() {
        let expectation = XCTestExpectation(description: "testFetchSets")

        let sortDescriptors = [NSSortDescriptor(key: "releaseDate", ascending: false),
                               NSSortDescriptor(key: "name", ascending: true)]
        
//        ManaKit.shared.fetchSets(completion: { result in
//            switch result {
//            case .success:
//                for code in sets.map({ $0.code}) {
//                    ManaKit.shared.fetchSet(code: code,
//                                            languageCode: "en",
//                                            completion: { result in
//                        switch result {
//                        case .success(let set):
//                            XCTAssert(set.code == code)
//                            
//                            for newID in (ManaKit.shared.find(MCard.self,
//                                                             properties: nil,
//                                                             predicate: NSPredicate(format: "set.code == %@ AND language.code == %@", code, "en"),
//                                                             sortDescriptors: nil,
//                                                              createIfNotFound: false) ?? []).map({ $0.newID})  {
//                                
//                                var cancellables3 = Set<AnyCancellable>()
//                                
//                                ManaKit.shared.fetchCard(newID: newID,
//                                                         cancellables: &cancellables3,
//                                                         completion: { result in
//                                    switch result {
//                                    case .success(let card):
//                                        XCTAssert(card.newID == newID)
//                                        expectation.fulfill()
//                                    case .failure(let error):
//                                        print(error)
//                                        XCTFail()
//                                        expectation.fulfill()
//                                    }
//                                })
//                            }
//
//                        case .failure(let error):
//                            print(error)
//                            XCTFail()
//                        }
//                    })
//                }
//                
//            case .failure(let error):
//                print(error)
//                XCTFail()
//            }
//        })

        wait(for: [expectation], timeout: 3600.0)
    }
    
    func testFetchSets() {
        let expectation = XCTestExpectation(description: "testFetchSets")

        let sortDescriptors = [NSSortDescriptor(key: "releaseDate", ascending: false),
                               NSSortDescriptor(key: "name", ascending: true)]
        
        ManaKit.shared.fetchSets(completion: { result in
            switch result {
            case .success:
//                XCTAssert(!sets.isEmpty)
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

        ManaKit.shared.fetchSet(code: code,
                                languageCode: languageCode,
                                completion: { result in
            switch result {
            case .success(let set):
                XCTAssert(set?.code == code)
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
        
        let newID = "emn_en_15a" // Bruna, the Fading Light - for testing component parts
        ManaKit.shared.fetchCard(newID: newID,
                                 completion: { result in
            switch result {
            case .success(let card):
                XCTAssert(card != nil)
                XCTAssert(card!.newID == newID)
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
