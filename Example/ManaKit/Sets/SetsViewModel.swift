//
//  SetsViewModel.swift
//  ManaKit_Example
//
//  Created by Jovito Royeca on 31.08.18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import ManaKit
import CoreData
import PromiseKit

class SetsViewModel: BaseViewModel {
    // MARK: initialization
    override init() {
        super.init()
        
        entitiyName = String(describing: CMSet.self)
        sortDescriptors = [NSSortDescriptor(key: "releaseDate", ascending: false)]
        sectionName = "myYearSection"
    }

    // MARK: Overrides
    override func fetchRemoteData() -> Promise<(data: Data, response: URLResponse)> {
        let urlString = "\(ManaKit.Constants.APIURL)/sets"
        
        return ManaKit.sharedInstance.createNodePromise(urlString: urlString,
                                                        httpMethod: "GET",
                                                        httpBody: nil)
    }
    
    override func composePredicate() -> NSPredicate? {
        let count = self.queryString.count
        var predicate: NSPredicate?
        
        if count > 0 {
            if count == 1 {
                predicate = NSPredicate(format: "name BEGINSWITH[cd] %@ OR code BEGINSWITH[cd] %@", self.queryString, self.queryString)
            } else {
                predicate = NSPredicate(format: "name CONTAINS[cd] %@ OR code CONTAINS[cd] %@", self.queryString, self.queryString)
            }
        }
        return predicate
    }
    
    override func composeFetchRequest() -> NSFetchRequest<NSFetchRequestResult>? {
        return CMSet.fetchRequest()
    }
}

