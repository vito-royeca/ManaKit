//
//  Maintainer+RulingsPostgres.swift
//  ManaKit_Example
//
//  Created by Vito Royeca on 11/5/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation
import ManaKit
import PostgresClientKit
import PromiseKit

extension Maintainer {
    func createRulingPromise(dict: [String: Any], connection: Connection) -> Promise<Void> {
        let oracleId = dict["oracle_id"] as? String ?? "NULL"
        let text = dict["comment"] as? String ?? "NULL"
        let datePublished = dict["published_at"] as? String ?? "NULL"
        
        let query = "SELECT createOrUpdateRuling($1,$2,$3)"
        let parameters = [oracleId,
                          text,
                          datePublished]
        return createPromise(with: query,
                             parameters: parameters,
                             connection: connection)
    }
    
    func createDeleteRulingsPromise(connection: Connection) -> Promise<Void> {
        let query = "DELETE FROM cmruling"
        return createPromise(with: query,
                             parameters: nil,
                             connection: connection)
    }
}
