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
import SwiftKuery
import SwiftKueryPostgreSQL

extension Maintainer {
    func createRulingPromise(dict: [String: Any], connection: PostgreSQLConnection) -> Promise<Void> {
        let oracleId = dict["oracle_id"] ?? "null"
        let text = dict["comment"] ?? "null"
        let datePublished = dict["published_at"] ?? "null"
        
        let query = "SELECT createOrUpdateRuling($1,$2,$3)"
        let parameters = [oracleId,
                          text,
                          datePublished]
        return createPromise(with: query,
                             parameters: parameters,
                             connection: connection)
    }
    
    func createDeleteRulingsPromise(connection: PostgreSQLConnection) -> Promise<Void> {
        let query = "DELETE FROM cmruling"
        return createPromise(with: query,
                             parameters: nil,
                             connection: connection)
    }
}
