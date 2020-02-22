//
//  SetsViewModel.swift
//  ManaKit_Example
//
//  Created by Jovito Royeca on 31.08.18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import CoreData
import PromiseKit

public class SetsViewModel: BaseViewModel {
    // MARK: Variables
    var _predicate: NSPredicate?
    override public var predicate: NSPredicate? {
        get {
            if _predicate == nil {
                guard let queryString = queryString else {
                    return nil
                }
                let count = queryString.count
                
                if count > 0 {
                    if count == 1 {
                        _predicate = NSPredicate(format: "name BEGINSWITH[cd] %@ OR code BEGINSWITH[cd] %@", queryString, queryString)
                    } else {
                        _predicate = NSPredicate(format: "name CONTAINS[cd] %@ OR code CONTAINS[cd] %@", queryString, queryString)
                    }
                }
            }
            return _predicate
        }
        set {
            _predicate = newValue
        }
    }
    
    var _fetchRequest: NSFetchRequest<NSFetchRequestResult>?
    override public var fetchRequest: NSFetchRequest<NSFetchRequestResult>? {
        get {
            if _fetchRequest == nil {
                _fetchRequest = MGSet.fetchRequest()
            }
            return _fetchRequest
        }
        set {
            _fetchRequest = newValue
        }
    }
    
    // MARK: initialization
    override public init() {
        super.init()
        
        entityName = String(describing: MGSet.self)
        sortDescriptors = [NSSortDescriptor(key: "releaseDate", ascending: false)]
        sectionName = "myYearSection"
    }
    
    // MARK: Overrides
    override public func fetchRemoteData() -> Promise<(data: Data, response: URLResponse)> {
        let path = "/sets?json=true"
        
        return ManaKit.sharedInstance.createNodePromise(apiPath: path,
                                                        httpMethod: "GET",
                                                        httpBody: nil)
    }
}

