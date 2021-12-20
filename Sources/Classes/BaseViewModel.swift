//
//  BaseViewModel.swift
//  ManaKit
//
//  Created by Vito Royeca on 11/29/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import CoreData
import PromiseKit

public enum ViewModelMode: Int {
    case standBy
    case loading
    case noResultsFound
    case resultsFound
    case error
    
    var cardArt: [String: String]? {
        switch self {
        case .standBy:
            return ["setCode": "tmp",
                    "name": "Scroll Rack",
                    "artCropURL": "https://img.scryfall.com/cards/art_crop/en/tmp/308.jpg?1517813031"]
        case .loading:
            return ["setCode": "chk",
                    "name": "Azami, Lady of Scrolls",
                    "artCropURL": "https://img.scryfall.com/cards/art_crop/en/chk/52.jpg?1517813031"]
        case .noResultsFound:
            return ["setCode": "chk",
                    "name": "Azusa, Lost but Seeking",
                    "artCropURL": "https://img.scryfall.com/cards/art_crop/en/chk/201.jpg?1517813031"]
        case .resultsFound:
            return nil
        case .error:
            return ["setCode": "plc",
                    "name": "Dismal Failure",
                    "artCropURL": "https://img.scryfall.com/cards/art_crop/en/plc/39.jpg?1517813031"]
        }
    }
    
    var description : String? {
        switch self {
        // Use Internationalization, as appropriate.
        case .standBy: return "Ready"
        case .loading: return "Loading..."
        case .noResultsFound: return "No data found"
        case .resultsFound: return nil
        case .error: return nil
        }
    }
}

open class BaseViewModel: NSObject {
    // MARK: - public variables
    public var entityName: String?
    public var sortDescriptors: [NSSortDescriptor]?
    public var sectionName: String?
    public var title: String?
    public var queryString: String?
    public var searchCancelled = false
    public var mode: ViewModelMode = .loading
    
    open var predicate: NSPredicate?
    open var fetchRequest: NSFetchRequest<NSFetchRequestResult>?
    
    // MARK: - private variables
//    private let context = ManaKit.sharedInstance.dataStack!.viewContext
    private var _sectionIndexTitles = [String]()
    private var _sectionTitles = [String]()
    private var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>?
    
    // MARK: - Initializer
//    public init(withEntityName entityName: String,
//                andPredicate predicate: NSPredicate?,
//                andSortDescriptors sortDescriptors: [NSSortDescriptor]?,
//                andTitle title: String?,
//                andMode mode: ViewModelMode) {
//
//        super.init()
//        self.entityName = entityName
//        self.predicate = predicate
//        self.sortDescriptors = sortDescriptors
//        self.title = title
//        self.mode = mode
//    }
    
    // MARK: - UITableView methods
    public func numberOfRows(inSection section: Int) -> Int {
        guard let fetchedResultsController = fetchedResultsController,
            let sections = fetchedResultsController.sections else {
            return 0
        }
        
        return sections[section].numberOfObjects
    }
    
    public func numberOfSections() -> Int {
        guard let fetchedResultsController = fetchedResultsController,
            let sections = fetchedResultsController.sections else {
            return 0
        }
        
        return sections.count
    }
    
    public func sectionIndexTitles() -> [String]? {
        return mode == .resultsFound ? _sectionIndexTitles : nil
    }
    
    public func sectionForSectionIndexTitle(title: String, at index: Int) -> Int {
        if mode == .resultsFound {
            var sectionIndex = 0
            
            for i in 0..._sectionTitles.count - 1 {
                if _sectionTitles[i].hasPrefix(title) {
                    sectionIndex = i
                    break
                }
            }
            
            return sectionIndex
        } else {
            return 0
        }
    }
    
    public func titleForHeaderInSection(section: Int) -> String? {
        if mode == .resultsFound {
            guard let fetchedResultsController = fetchedResultsController,
                let sections = fetchedResultsController.sections else {
                return nil
            }
            
            return sections[section].name
        } else {
            return nil
        }
    }
    
    // MARK: - Custom methods
    public func isEmpty() -> Bool {
        guard let objects = allObjects() else {
            return true
        }
        return objects.count == 0
    }
    
    public func object(forRowAt indexPath: IndexPath) -> NSManagedObject {
        guard let fetchedResultsController = fetchedResultsController else {
            fatalError("fetchedResultsController is nil")
        }
        return fetchedResultsController.object(at: indexPath) as! NSManagedObject
    }
    
    public func allObjects() -> [NSManagedObject]? {
        guard let fetchedResultsController = fetchedResultsController else {
            return nil
        }
        return fetchedResultsController.fetchedObjects as? [NSManagedObject]
    }
    
    open func willFetchCache() -> Bool {
        guard let entityName = entityName else {
            fatalError("entityName is nil")
        }

        return ManaKit.shared.willFetchCache(entityName, objectFinder: nil)
    }
    
    open func deleteCache() {
        guard let entityName = entityName else {
            fatalError("entityName is nil")
        }

        ManaKit.shared.deleteCache(entityName, objectFinder: nil)
    }
    
    open func deleteAllCache() {
        let entities = [String(describing: MGSet.self),
                        String(describing: MGCard.self)]

        for entity in entities {
            ManaKit.shared.deleteCache(entity, objectFinder: nil)
        }
    }
    
//    open func fetchData(callback: ((_ error: Error?) -> Void)?) {
//        if willFetchCache() {
//            firstly {
//                fetchRemoteData()
//            }.compactMap { (data, result) in
//                try JSONSerialization.jsonObject(with: data) as? [[String: Any]]
//            }.then { data in
//                self.saveLocalData(data: data)
//            }.then {
//                self.fetchLocalData()
//            }.done {
//                if let callback = callback {
//                    callback(nil)
//                }
//            }.catch { error in
//                self.deleteCache()
//                
//                if let callback = callback {
//                    callback(error)
//                }
//            }
//        } else {
//            firstly {
//                fetchLocalData()
//            }.done {
//                if let callback = callback {
//                    callback(nil)
//                }
//            }.catch { error in
//                self.deleteCache()
//                
//                if let callback = callback {
//                    callback(error)
//                }
//            }
//        }
//    }
        
    open func fetchRemoteData() -> Promise<(data: Data, response: URLResponse)> {
        let path = "/"
        
        return ManaKit.shared.createNodePromise(apiPath: path,
                                                httpMethod: "GET",
                                                httpBody: nil)
    }
    
    open func saveLocalData(data: [[String: Any]]) -> Promise<Void> {
        return Promise { seal in
            guard let entityName = entityName else {
                fatalError("entityName is nil")
            }

            let completion = { (error: NSError?) in
                seal.fulfill(())
            }
//            ManaKit.sharedInstance.dataStack?.sync(data,
//                                                   inEntityNamed: entityName,
//                                                   predicate: predicate,
//                                                   operations: .all,
//                                                   completion: completion)
        }
    }
    
//    open func fetchLocalData() -> Promise<Void> {
//        return Promise { seal in
//            if let request: NSFetchRequest<NSFetchRequestResult> = fetchRequest {
//                request.predicate = predicate
//                request.sortDescriptors = self.sortDescriptors
//
//                self.fetchedResultsController = self.getFetchedResultsController(with: request)
//                self.updateSections()
//            }
//            seal.fulfill(())
//        }
//    }
    
    open func updateSections() {
        guard let fetchedResultsController = fetchedResultsController,
            let sections = fetchedResultsController.sections else {
            return
        }
        
//        _sectionIndexTitles = [String]()
        _sectionTitles = [String]()
        
//        for set in sets {
//            if let nameSection = set.myNameSection {
//                if !_sectionIndexTitles.contains(nameSection) {
//                    _sectionIndexTitles.append(nameSection)
//                }
//            }
//        }
        
        let count = sections.count
        if count > 0 {
            for i in 0...count - 1 {
//                if let sectionTitle = sections[i].indexTitle {
//                    _sectionTitles.append(sectionTitle)
//                }
                _sectionTitles.append(sections[i].name)
            }
        }
        
        _sectionIndexTitles.sort()
        _sectionTitles.sort()
    }
    
//    open func getFetchedResultsController(with fetchRequest: NSFetchRequest<NSFetchRequestResult>?) -> NSFetchedResultsController<NSFetchRequestResult> {
//        guard let entityName = entityName else {
//            fatalError("entityName is nil")
//        }
//
//        var request: NSFetchRequest<NSFetchRequestResult>?
//
//        if let fetchRequest = fetchRequest {
//            request = fetchRequest
//        } else {
//            // Create a default fetchRequest
//            request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
//            request!.predicate = predicate
//            request!.sortDescriptors = sortDescriptors
//        }
//
//        // Create Fetched Results Controller
//        let frc = NSFetchedResultsController(fetchRequest: request!,
//                                             managedObjectContext: context,
//                                             sectionNameKeyPath: sectionName,
//                                             cacheName: nil)
//
//        // Configure Fetched Results Controller
////        frc.delegate = self
//
//        // perform fetch
//        do {
//            try frc.performFetch()
//        } catch {
//            let fetchError = error as NSError
//            print("Unable to Perform Fetch Request")
//            print("\(fetchError), \(fetchError.localizedDescription)")
//        }
//
//        return frc
//    }
}
