//
//  ManaKit_ExampleTests.swift
//  ManaKit_ExampleTests
//
//  Created by Vito Royeca on 12/25/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import XCTest
import ManaKit
import PromiseKit

class ManaKit_ExampleTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testTCGPlayerPricing() {
        let exp = expectation(description: "testTCGPlayerPricing")
        
        let groupId = 2655
        let tcgplayerAPIToken = "FxhEfPq0CjnzL8JRjymVPGYndRUCjNOGgV4V13Ew5PBTZxRXotLc6mPu2AdK4hWUhDYCK9eA3sBLV0W4gHShej9qILlERFehQoUJc9jDFpFtImwKvlDPSQRwlsnJCNjg_XbxgFYSJ6m3uGtHhhnkSzXpU-GR1xbnl8PLESBirAnn7dRso93VzXsE79rFrg_kn8HuAmQ3ht-f9qa6hbjl2_ABvqXt15WixMj8gqOC8Z6gkaKrV7vX81e5SmNJi5G7O5AB0Iju0Jx89r_6s0VXpn6z-PdpkjeSwE3s_lb82ZNipHuijpFj14yClxvBDQyn23Nktw"
        
        guard let urlString = "https://api.tcgplayer.com/\(ManaKit.Constants.TcgPlayerApiVersion)/pricing/group/\(groupId)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
            let url = URL(string: urlString) else {
            fatalError("Malformed url")
        }
        
        var rq = URLRequest(url: url)
        rq.httpMethod = "GET"
        rq.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        rq.setValue("*/*", forHTTPHeaderField: "Accept")
        rq.setValue("Bearer \(tcgplayerAPIToken)", forHTTPHeaderField: "Authorization")
        
        firstly {
            URLSession.shared.dataTask(.promise, with:rq)
        }.compactMap {
            try JSONSerialization.jsonObject(with: $0.data) as? [String: Any]
        }.done { json in
            guard let results = json["results"] as? [[String: Any]] else {
                fatalError("results is nil")
            }
            print(results)
            exp.fulfill()
        }.catch { error in
            print(error)
            exp.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }

}
