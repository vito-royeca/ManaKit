//
//  CreateDatabaseTests.swift
//  
//
//  Created by Vito Royeca on 4/3/24.
//

import XCTest
import ManaKit

final class CreateDatabaseTests: XCTestCase {

    override func setUpWithError() throws {
        ManaKit.shared.configure(apiURL: "https://managuideapp.com")
        
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        do {
            try ManaKit.shared.vacuumLocalDB()
        } catch {
            print(error)
        }
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
    
    func testCreateDatabase() async throws {
        do {
            let setIDs = try await ManaKit.shared.fetchSets()
            XCTAssert(!setIDs.isEmpty)
            
            let request = MGSet.fetchRequest()
            let sorter = NSSortDescriptor(key: "releaseDate", ascending: false)
            
            request.sortDescriptors = [sorter]
            let sets = try ManaKit.shared.viewContext.fetch(request)
            
            for set in sets {
                if let languages = set.sortedLanguages,
                   let language = languages.filter({ $0.code == "en" }).first ?? languages.first {
//                for language in set.sortedLanguages ?? [] {
                    if let setID = try await ManaKit.shared.fetchSet(code: set.code,
                                                                     languageCode: language.code),
                       let set = ManaKit.shared.viewContext.object(with: setID) as? MGSet {
                        let cards = (set.cards?.allObjects as? [MGCard] ?? [])
                            .filter { $0.language?.code == language.code }
                        print("Fetched \(set.code)_\(language.code): \(cards.count) cards")
                        sleep(1)
                    }
//                }
                }
            }
        } catch {
            print(error)
            XCTFail("testCreateDatabase error")
        }
    }

//    func testVacuumDatabase() async throws {
//        do {
//            try ManaKit.shared.vacuumLocalDB()
//            XCTAssert(true)
//            
//            sleep(10)
//        } catch {
//            print(error)
//            XCTFail("testVacuumDatabase error")
//        }
//    }

//    func createLocalDB() {
//        let group = DispatchGroup()
//
//        // 1) start fetch sets
//        group.enter()
//        ManaKit.shared.fetchSets(completion: { result in
//            switch result {
//            case .success:
//                let sets = self.fetchLocalSets()
//                let setsCount = sets.count
//                var index = 0
//
//                for set in sets {
//                    for language in set.sortedLanguages ?? [] {
//
//                        // 2) start fetch set/language
//                        group.enter()
//                        ManaKit.shared.fetchSet(code: set.code, languageCode: language.code ?? "", completion: { result in
//                            switch result {
//                            case .success(let set):
//                                if let set = set {
//                                    for card in self.fetchLocalCards(setCode: set.code, languageCode: language.code ?? "") {
//
//                                        // 3) start fetch card
//                                        group.enter()
//                                        ManaKit.shared.fetchCard(newID: card.newIDCopy, completion: { result in
//                                            switch result {
//                                            case .success(let card):
//                                                if let card = card {
//                                                    print("fetched \(card.newIDCopy)")
//                                                } else {
//                                                    print("fail!!!")
//                                                }
//                                            case .failure(let error):
//                                                print(error)
//                                            }
//
//                                            // 3) end fetch card
//                                            sleep(1)
//                                            group.leave()
//                                        })
//                                    }
//                                }
//
//                            case .failure(let error):
//                                print(error)
//                            }
//
//                            print("Sleeping... \(index)/\(setsCount)")
//                            index += 1
//                            sleep(1)
//                            // 2) end fetch set/language
//                            group.leave()
//                        })
//                    }
//                }
//            case .failure(let error):
//                print(error)
//            }
//
//            // 1) end fetch sets
//            group.leave()
//        })
//
//        group.notify(queue: DispatchQueue.global()) {
//            print("Done")
//        }
//    }
}
