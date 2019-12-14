//
//  SetViewModel.swift
//  ManaKit_Example
//
//  Created by Jovito Royeca on 06.09.18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import ManaKit
import CoreData
import PromiseKit

class SetViewModel: BaseViewModel {
    // MARK: Variables
    private var _set: CMSet?
    private var _languageCode: String?
    
    // MARK: Initialization
    init(withSet set: CMSet, languageCode: String) {
        super.init()
        _set = set
        _languageCode = languageCode
        
        entityName = String(describing: CMCard.self)
        sortDescriptors = [NSSortDescriptor(key: "name", ascending: true),
                           NSSortDescriptor(key: "collectorNumber", ascending: true)]
        sectionName = "myNameSection"
        
        
        if let set = _set {
            title = set.name
        }
    }
    
    // MARK: Overrides
    func modelTitle() -> String? {
        if let set = _set {
            return set.name
        } else {
            return nil
        }
    }
    
    override func willFetchCache() -> Bool {
        guard let set = _set,
            let setCode = set.code,
            let languageCode = _languageCode else {
            fatalError("set and languageCode are nil")
        }
        let objectFinder = ["setCode": setCode,
                            "languageCode": languageCode] as [String : AnyObject]
        
        return ManaKit.sharedInstance.willFetchCache(entityName,
                                                     objectFinder: objectFinder)
    }
    
    override func deleteCache() {
        guard let set = _set,
            let setCode = set.code,
            let languageCode = _languageCode else {
            fatalError("set and languageCode are nil")
        }
        let objectFinder = ["setCode": setCode,
                            "languageCode": languageCode] as [String : AnyObject]
        
        ManaKit.sharedInstance.deleteCache(entityName,
                                           objectFinder: objectFinder)
    }
    
    override func composePredicate() -> NSPredicate? {
        guard let set = _set,
            let setCode = set.code,
            let languageCode = _languageCode else {
            return nil
        }
        
        let count = queryString.count
        var predicate = NSPredicate(format: "set.code = %@ AND language.code = %@", setCode, languageCode)
        
        if count > 0 {
            if count == 1 {
                let newPredicate = NSPredicate(format: "name BEGINSWITH[cd] %@", queryString)
                predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate, newPredicate])
            } else {
                let newPredicate = NSPredicate(format: "name CONTAINS[cd] %@", queryString)
                predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate, newPredicate])
            }
        }
        return predicate
    }
    
    override func composeFetchRequest() -> NSFetchRequest<NSFetchRequestResult>? {
        return CMCard.fetchRequest()
    }
    
    override func fetchRemoteData() -> Promise<(data: Data, response: URLResponse)> {
        guard let set = _set,
            let setCode = set.code,
            let languageCode = _languageCode else {
            fatalError("set and languageCode are nil")
        }
        let urlString = "\(ManaKit.Constants.APIURL)/cards/\(setCode)/\(languageCode)"
        
        return ManaKit.sharedInstance.createNodePromise(urlString: urlString,
                                                        httpMethod: "GET",
                                                        httpBody: nil)
    }
}
