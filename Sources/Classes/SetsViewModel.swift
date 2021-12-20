//
//  SetsViewModel.swift
//  ManaKit_Example
//
//  Created by Jovito Royeca on 31.08.18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import CoreData
import PromiseKit
import Combine

public class ViewModel: ObservableObject {
    
    @Published public var page = 0
    @Published public var pageLimit = 0
    @Published public var pageCount = 0
    @Published public var rowCount = 0
    @Published public var data: [AnyObject] = []
    
    public init() {
        
    }

    public func fetchRemoteData() {
        
    }
}

/*public class SetsViewModel: ViewModel {
    private let url = "\(ManaKit.sharedInstance.apiURL)/sets?json=true&page=1&limit=100"
//    private var task: AnyCancellable?
    
    override public func fetchRemoteData() {
//        task = URLSession.shared.dataTaskPublisher(for: URL(string: url)!)
//            .map { $0.data }
//            .decode(type: [AnyObject].self, decoder: JSONDecoder())
//            .replaceError(with: [])
//            .eraseToAnyPublisher()
//            .receive(on: RunLoop.main)
//            .assign(to: \SetsViewModel.data, on: self)
    }
}*/

public class SetsViewModel: BaseViewModel {
    // MARK: - Variables
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
    
    // MARK: - Initialization
    override public init() {
        super.init()
        
        entityName = String(describing: MGSet.self)
        sortDescriptors = [NSSortDescriptor(key: "releaseDate", ascending: false)]
        sectionName = "myYearSection"
    }
    
    // MARK: - Overrides
    override public func fetchRemoteData() -> Promise<(data: Data, response: URLResponse)> {
        let path = "/sets?json=true"
        
        return ManaKit.shared.createNodePromise(apiPath: path,
                                                httpMethod: "GET",
                                                httpBody: nil)
    }
}

