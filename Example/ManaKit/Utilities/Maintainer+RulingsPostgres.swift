//
//  Maintainer+RulingsPostgres.swift
//  ManaKit_Example
//
//  Created by Vito Royeca on 11/5/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation
import ManaKit
import PromiseKit

extension Maintainer {
    func createRulingPromise(dict: [String: Any]) -> Promise<(data: Data, response: URLResponse)> {
        let oracle_id = dict["oracle_id"] ?? "null"
        let text = dict["comment"] ?? "null"
        let date_published = dict["published_at"] ?? "null"
        
        let httpBody = """
                        oracle_id=\(oracle_id)&
                        text=\(text)&
                        date_published=\(date_published)
                        """
        let urlString = "\(ManaKit.Constants.APIURL)/rulings"
        
        return createNodePromise(urlString: urlString,
                                 httpMethod: "POST",
                                 httpBody: httpBody)
    }
    
    func createDeleteRulingPromise() -> Promise<(data: Data, response: URLResponse)> {
        let urlString = "\(ManaKit.Constants.APIURL)/rulings"
        
        return createNodePromise(urlString: urlString,
                                 httpMethod: "DELETE",
                                 httpBody: nil)
    }
}
