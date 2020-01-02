//
//  CardViewModel.swift
//  ManaKit_Example
//
//  Created by Vito Royeca on 11/30/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import CoreData
import PromiseKit

public class CardViewModel: BaseViewModel {
    // MARK: Variables
    private var _id: String?
    
    var _predicate: NSPredicate?
    override public var predicate: NSPredicate? {
        get {
            if _predicate == nil {
                guard let id = _id else {
                    return nil
                }
                _predicate = NSPredicate(format: "id = %@", id)
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
                _fetchRequest = MGCard.fetchRequest()
            }
            return _fetchRequest
        }
        set {
            _fetchRequest = newValue
        }
    }
    
    // MARK: Initialization
    public init(withId id: String) {
        super.init()
        _id = id
        
        entityName = String(describing: MGCard.self)
        sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
    }
    
    // MARK: Overrides
    override public func willFetchCache() -> Bool {
        guard let id = _id else {
            fatalError("id is nil")
        }
        let objectFinder = ["id": id] as [String : AnyObject]
        
        return ManaKit.sharedInstance.willFetchCache(entityName,
                                                     objectFinder: objectFinder)
    }
    
    override public func deleteCache() {
        guard let id = _id else {
            fatalError("id is nil")
        }
        let objectFinder = ["id": id] as [String : AnyObject]
        
        return ManaKit.sharedInstance.deleteCache(entityName,
                                                  objectFinder: objectFinder)
    }
    
    override public func fetchRemoteData() -> Promise<(data: Data, response: URLResponse)> {
        guard let id = _id else {
            fatalError("id is nil")
        }
        let path = "/cards/\(id)"
        
        return ManaKit.sharedInstance.createNodePromise(apiPath: path,
                                                        httpMethod: "GET",
                                                        httpBody: nil)
    }
}
