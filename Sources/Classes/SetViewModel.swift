//
//  SetViewModel.swift
//  ManaKit_Example
//
//  Created by Jovito Royeca on 06.09.18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import CoreData
import PromiseKit

public class SetViewModel: BaseViewModel {
    // MARK: - Variables
    private var _set: MGSet?
    private var _languageCode: String?
    
    var _predicate: NSPredicate?
    override public var predicate: NSPredicate? {
        get {
            if _predicate == nil {
                guard let set = _set,
                    let setCode = set.code,
                    let languageCode = _languageCode,
                    let queryString = queryString else {
                    return nil
                }
                
                let count = queryString.count
                _predicate = NSPredicate(format: "set.code = %@ AND language.code = %@", setCode, languageCode)
                
                if count > 0 {
                    if count == 1 {
                        let newPredicate = NSPredicate(format: "name BEGINSWITH[cd] %@", queryString)
                        _predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [_predicate!, newPredicate])
                    } else {
                        let newPredicate = NSPredicate(format: "name CONTAINS[cd] %@", queryString)
                        _predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [_predicate!, newPredicate])
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
    
    // MARK: - Initialization
    public init(withSet set: MGSet, languageCode: String) {
        super.init()
        _set = set
        _languageCode = languageCode
        
        let _ = predicate // init the predicate
        entityName = String(describing: MGSet.self)
        sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        sectionName = "myNameSection"
        
        if let set = _set {
            title = set.name
        }
    }
    
    // MARK: - Overrides
    public func modelTitle() -> String? {
        if let set = _set {
            return set.name
        } else {
            return nil
        }
    }
    
    override public func willFetchCache() -> Bool {
        guard let set = _set,
            let setCode = set.code,
            let languageCode = _languageCode,
            let entityName = entityName else {
            fatalError("set, languageCode, entityName are nil")
        }
        let objectFinder = ["setCode": setCode,
                            "languageCode": languageCode] as [String : AnyObject]
        
        return ManaKit.sharedInstance.willFetchCache(entityName,
                                                     objectFinder: objectFinder)
    }
    
    override public func deleteCache() {
        guard let set = _set,
            let setCode = set.code,
            let languageCode = _languageCode,
            let entityName = entityName else {
            fatalError("set, languageCode, and entityName are nil")
        }
        let objectFinder = ["setCode": setCode,
                            "languageCode": languageCode] as [String : AnyObject]
        
        ManaKit.sharedInstance.deleteCache(entityName,
                                           objectFinder: objectFinder)
    }
    
    override public func fetchRemoteData() -> Promise<(data: Data, response: URLResponse)> {
        guard let set = _set,
            let setCode = set.code,
            let languageCode = _languageCode else {
            fatalError("set and languageCode are nil")
        }
        let path = "/set/\(setCode)/\(languageCode)?json=true"
        
        return ManaKit.sharedInstance.createNodePromise(apiPath: path,
                                                        httpMethod: "GET",
                                                        httpBody: nil)
    }
}
