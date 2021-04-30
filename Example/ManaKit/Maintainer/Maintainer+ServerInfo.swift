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
    func createScryfallPromise() -> Promise<Void> {
        let query = "UPDATE server_info SET scryfall_version = $1"
        let parameters = [ManaKit.Constants.ScryfallDate]
        
        return createPromise(with: query,
                             parameters: parameters)
    }
}
