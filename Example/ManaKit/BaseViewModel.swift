//
//  BaseViewModel.swift
//  ManaKit
//
//  Created by Vito Royeca on 11/29/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import CoreData
import ManaKit
import PromiseKit

class BaseViewModel: NSObject {
    // MARK: public variables
    var entitiyName = ""
    var sortDescriptors: [NSSortDescriptor]?
    var sectionName: String?
    var title: String?
    var queryString = ""
    var searchCancelled = false
    
    // MARK: private variables
    private let context = ManaKit.sharedInstance.dataStack!.viewContext
    private var _sectionIndexTitles = [String]()
    private var _sectionTitles = [String]()
    private var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>?
    
    // MARK: UITableView methods
    func numberOfRows(inSection section: Int) -> Int {
        guard let fetchedResultsController = fetchedResultsController,
            let sections = fetchedResultsController.sections else {
            return 0
        }
        
        return sections[section].numberOfObjects
    }
    
    func numberOfSections() -> Int {
        guard let fetchedResultsController = fetchedResultsController,
            let sections = fetchedResultsController.sections else {
                return 0
        }
        
        return sections.count
    }
    
    func sectionIndexTitles() -> [String]? {
        return _sectionIndexTitles
    }
    
    func sectionForSectionIndexTitle(title: String, at index: Int) -> Int {
        var sectionIndex = 0
        
        for i in 0..._sectionTitles.count - 1 {
            if _sectionTitles[i].hasPrefix(title) {
                sectionIndex = i
                break
            }
        }
        
        return sectionIndex
    }
    
    func titleForHeaderInSection(section: Int) -> String? {
        guard let fetchedResultsController = fetchedResultsController,
            let sections = fetchedResultsController.sections else {
            return nil
        }
        
        return sections[section].name
    }
    
    // MARK: Custom methods
    func isEmpty() -> Bool {
        guard let objects = allObjects() else {
            return true
        }
        return objects.count == 0
    }
    
    func object(forRowAt indexPath: IndexPath) -> NSManagedObject {
        guard let fetchedResultsController = fetchedResultsController else {
            fatalError("fetchedResultsController is nil")
        }
        return fetchedResultsController.object(at: indexPath) as! NSManagedObject
    }
    
    func allObjects() -> [NSManagedObject]? {
        guard let fetchedResultsController = fetchedResultsController else {
            return nil
        }
        return fetchedResultsController.fetchedObjects as? [NSManagedObject]
    }
    
    func willFetchCache() -> Bool {
        return ManaKit.sharedInstance.willFetchCache(entitiyName,
                                                     objectFinder: nil)
    }
    
    func deleteCache() {
        return ManaKit.sharedInstance.deleteCache(entitiyName,
                                                   objectFinder: nil)
    }
    
    func composePredicate() -> NSPredicate? {
        return nil
    }
    
    func composeFetchRequest() -> NSFetchRequest<NSFetchRequestResult>? {
        return nil
    }

    func fetchRemoteData() -> Promise<(data: Data, response: URLResponse)> {
        let urlString = "\(ManaKit.Constants.APIURL)/sets"
        
        return ManaKit.sharedInstance.createNodePromise(urlString: urlString,
                                                        httpMethod: "GET",
                                                        httpBody: nil)
    }
    
    func saveLocalData(data: [[String: Any]]) -> Promise<Void> {
        return Promise { seal in
            let completion = { (error: NSError?) in
                seal.fulfill(())
            }
            ManaKit.sharedInstance.dataStack?.sync(data,
                                                   inEntityNamed: entitiyName,
                                                   predicate: composePredicate(),
                                                   operations: [.all],
                                                   completion: completion)
        }
    }
    
    func fetchLocalData() -> Promise<Void> {
        return Promise { seal in
            if let request: NSFetchRequest<NSFetchRequestResult> = composeFetchRequest() {
                request.predicate = composePredicate()
                request.sortDescriptors = self.sortDescriptors
            
                self.fetchedResultsController = self.getFetchedResultsController(with: request)
                self.updateSections()
            }
            seal.fulfill(())
        }
    }
    
    func updateSections() {
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
    
    func getFetchedResultsController(with fetchRequest: NSFetchRequest<NSFetchRequestResult>?) -> NSFetchedResultsController<NSFetchRequestResult> {
        var request: NSFetchRequest<NSFetchRequestResult>?
        
        if let fetchRequest = fetchRequest {
            request = fetchRequest
        } else {
            // Create a default fetchRequest
            request = NSFetchRequest<NSFetchRequestResult>(entityName: entitiyName)
            request!.predicate = composePredicate()
            request!.sortDescriptors = sortDescriptors
        }
        
        // Create Fetched Results Controller
        let frc = NSFetchedResultsController(fetchRequest: request!,
                                             managedObjectContext: context,
                                             sectionNameKeyPath: sectionName,
                                             cacheName: nil)
        
        // Configure Fetched Results Controller
//        frc.delegate = self
        
        // perform fetch
        do {
            try frc.performFetch()
        } catch {
            let fetchError = error as NSError
            print("Unable to Perform Fetch Request")
            print("\(fetchError), \(fetchError.localizedDescription)")
        }
        
        return frc
    }
}

