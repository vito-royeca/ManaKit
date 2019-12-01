//
//  CardViewModel.swift
//  ManaKit_Example
//
//  Created by Vito Royeca on 11/30/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import ManaKit
import CoreData
import PromiseKit

class CardViewModel: BaseViewModel {
    // MARK: Variables
    private var _id: String?
    
    // MARK: Initialization
    init(withId id: String) {
        super.init()
        _id = id
        
        entitiyName = String(describing: CMCard.self)
        sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
    }
    
    // MARK: Overrides
    override func willFetchCache() -> Bool {
        guard let id = _id else {
            fatalError("id is nil")
        }
        let objectFinder = ["id": id] as [String : AnyObject]
        
        return ManaKit.sharedInstance.willFetchCache(entitiyName,
                                                     objectFinder: objectFinder)
    }
    
    override func deleteCache() {
        guard let id = _id else {
            fatalError("id is nil")
        }
        let objectFinder = ["id": id] as [String : AnyObject]
        
        return ManaKit.sharedInstance.deleteCache(entitiyName,
                                                  objectFinder: objectFinder)
    }
    
    override func composePredicate() -> NSPredicate? {
        guard let id = _id else {
            return nil
        }
        
        return NSPredicate(format: "id = %@", id)
    }
    
    override func composeFetchRequest() -> NSFetchRequest<NSFetchRequestResult>? {
        return CMCard.fetchRequest()
    }
    
    override func fetchRemoteData() -> Promise<(data: Data, response: URLResponse)> {
        guard let id = _id else {
            fatalError("id is nil")
        }
        let urlString = "\(ManaKit.Constants.APIURL)/cards/\(id)"
        
        return ManaKit.sharedInstance.createNodePromise(urlString: urlString,
                                                        httpMethod: "GET",
                                                        httpBody: nil)
    }
}
