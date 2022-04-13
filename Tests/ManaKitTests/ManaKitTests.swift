import XCTest
import CoreData
@testable import ManaKit

final class ManaKitTests: XCTestCase {
    override func setUp() {
        ManaKit.shared.configure(apiURL: "http://managuideapp.com")
        ManaKit.shared.setupResources()
    }

    func testFetchAll() {
        let expectation = XCTestExpectation(description: "testFetchAll")
        let group = DispatchGroup()
        
        // 1) start fetch sets
        group.enter()
        ManaKit.shared.fetchSets(completion: { result in
            switch result {
            case .success:
                
                for set in self.fetchLocalSets() {
                    for language in set.sortedLanguages ?? [] {
                        
                        // 2) start fetch set/language
                        group.enter()
                        ManaKit.shared.fetchSet(code: set.code, languageCode: language.code ?? "", completion: { result in
                            switch result {
                            case .success(let set):
                                if let set = set {
                                    for card in self.fetchLocalCards(setCode: set.code, languageCode: language.code ?? "") {
                                        
                                        // 3) start fetch card
                                        group.enter()
                                        ManaKit.shared.fetchCard(newID: card.newIDCopy, completion: { result in
                                            switch result {
                                            case .success(let card):
                                                if let card = card {
                                                    print("fetched \(card.newIDCopy)")
                                                } else {
                                                    print("fail!!!")
                                                }
                                                // 3) end fetch card
                                                group.leave()
                                                
                                            case .failure(let error):
                                                print(error)
                                                XCTFail()
                                            }
                                        })
                                    }
                                }
                                
                                // 2) end fetch set/language
                                group.leave()
                                
                            case .failure(let error):
                                print(error)
                                XCTFail()
                            }
                        })
                    }
                }
                
                // 1) end fetch sets
                group.leave()
                
            case .failure(let error):
                print(error)
                XCTFail()
            }
        })

        group.notify(queue: DispatchQueue.global()) {
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 3600.0)
    }
    
    func fetchLocalSets() -> [MGSet] {
        let request: NSFetchRequest<MGSet> = MGSet.fetchRequest()
        let sortDescriptors = [NSSortDescriptor(key: "releaseDate", ascending: false),
                               NSSortDescriptor(key: "name", ascending: true)]
        
        request.sortDescriptors = sortDescriptors
        
        let frc = NSFetchedResultsController(fetchRequest: request,
                                             managedObjectContext: ManaKit.shared.viewContext,
                                             sectionNameKeyPath: nil,
                                             cacheName: nil)
        var sets = [MGSet]()
        
        do {
            try frc.performFetch()
            sets = frc.fetchedObjects ?? []
        } catch {
            print(error)
        }
        
        return sets
    }
    
    func fetchLocalCards(setCode: String, languageCode: String) -> [MGCard] {
        let request: NSFetchRequest<MGCard> = MGCard.fetchRequest()
        let predicate = NSPredicate(format: "set.code == %@ AND language.code == %@ AND collectorNumber != null ", setCode, languageCode)
        let sortDescriptors = [NSSortDescriptor(key: "collectorNumber", ascending: true)]
        
        request.predicate = predicate
        request.sortDescriptors = sortDescriptors
        
        let frc = NSFetchedResultsController(fetchRequest: request,
                                             managedObjectContext: ManaKit.shared.viewContext,
                                             sectionNameKeyPath: nil,
                                             cacheName: nil)
        var cards = [MGCard]()
        
        do {
            try frc.performFetch()
            cards = frc.fetchedObjects ?? []
        } catch {
            print(error)
        }
        
        return cards
    }
    
    func testFetchSets() {
        let expectation = XCTestExpectation(description: "testFetchSets")

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
