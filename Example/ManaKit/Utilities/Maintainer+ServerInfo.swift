//
//  Maintainer+ServerInfo.swift
//  ManaKit
//
//  Created by Vito Royeca on 12/7/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import ManaKit
import PromiseKit

extension Maintainer {
    func createScryfallPromise() -> Promise<(data: Data, response: URLResponse)> {
        let httpBody = """
                        scryfall_version=\(ManaKit.Constants.ScryfallDate)
                        """
        let urlString = "\(ManaKit.Constants.APIURL)/serverinfo/updatescryfall"
        
        return ManaKit.sharedInstance.createNodePromise(urlString: urlString,
                                                        httpMethod: "POST",
                                                        httpBody: httpBody)
    }
}
