import UIKit
import XCTest
import ManaKit
import PromiseKit

class Tests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        ManaKit.sharedInstance.setupResources()
        ManaKit.sharedInstance.configureTCGPlayer(partnerKey: "ManaGuide", publicKey: "A49D81FB-5A76-4634-9152-E1FB5A657720", privateKey: nil)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        XCTAssert(true, "Pass")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure() {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testSuppliers() {
        let expectation = XCTestExpectation(description: "testSuppliers()")
        
        if let card = ManaKit.sharedInstance.realm.objects(CMCard.self).filter("name == %@ AND set.code == %@", "Air Elemental", "XLN").first {
            firstly {
                ManaKit.sharedInstance.fetchTCGPlayerStorePricing(card: card)
            }.done {
                if let storePricing = card.tcgplayerStorePricing {
                    for supplier in storePricing.suppliers {
                        print("\(supplier)")
                    }
                }
                
                expectation.fulfill()
            }.catch { error in
                XCTFail("\(error.localizedDescription)")
            }
        }
        
        wait(for: [expectation], timeout: 20.0)
    }
    
}
