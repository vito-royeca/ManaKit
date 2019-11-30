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

class SetViewModel: NSObject {
    // MARK: Variables
    var queryString = ""
    var searchCancelled = false
    
    private var _set: CMSet?
    private var _languageCode: String?
    private var _sectionIndexTitles = [String]()
    private var _sectionTitles = [String]()
    private let context = ManaKit.sharedInstance.dataStack!.viewContext
    private var _fetchedResultsController: NSFetchedResultsController<CMCard>?
    
    // MARK: Settings
    private let _sortDescriptors = [NSSortDescriptor(key: "name", ascending: true),
                                    NSSortDescriptor(key: "collectorNumber", ascending: true)]
    private var _sectionName = "myNameSection"
    
    // MARK: Overrides
    init(withSet set: CMSet, languageCode: String) {
        super.init()
        _set = set
        _languageCode = languageCode
    }
    
    // MARK: UITableView methods
    func numberOfRows(inSection section: Int) -> Int {
        guard let fetchedResultsController = _fetchedResultsController,
            let sections = fetchedResultsController.sections else {
            return 0
        }
        
        return sections[section].numberOfObjects
    }
    
    func numberOfSections() -> Int {
        guard let fetchedResultsController = _fetchedResultsController,
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
        guard let fetchedResultsController = _fetchedResultsController,
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
    
    func objectTitle() -> String? {
        guard let set = _set else {
            return nil
        }
        return set.name
    }
    
    func object(forRowAt indexPath: IndexPath) -> CMCard {
        guard let fetchedResultsController = _fetchedResultsController else {
            fatalError("fetchedResultsController is nil")
        }
        return fetchedResultsController.object(at: indexPath)
    }
    
    func allObjects() -> [CMCard]? {
        guard let fetchedResultsController = _fetchedResultsController else {
            return nil
        }
        return fetchedResultsController.fetchedObjects
    }

    func willFetchRemoteData() -> Bool {
        guard let set = _set,
            let setCode = set.code,
            let languageCode = _languageCode else {
            fatalError("set and languageCode are nil")
        }
        
        return ManaKit.sharedInstance.willFetchData(name: String(describing: CMSet.self),
                                                    query: "/cards/\(setCode)/\(languageCode)")
    }
    
    func deleteDataInformation() {
        guard let set = _set,
            let setCode = set.code,
            let languageCode = _languageCode else {
            fatalError("set and languageCode are nil")
        }
        let objectFinder = ["name": String(describing: CMSet.self) as AnyObject,
                            "query": "/cards/\(setCode)/\(languageCode)" as AnyObject]
        
        return ManaKit.sharedInstance.deleteObject(String(describing: DataInformation.self),
                                                   objectFinder: objectFinder)
    }
    
    func fetchRemoteData() -> Promise<(data: Data, response: URLResponse)> {
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
    
    func saveLocalData(data: [[String: Any]]) -> Promise<Void> {
        return Promise { seal in
            ManaKit.sharedInstance.dataStack?.sync(data,
                                                   inEntityNamed: "CMCard",
                                                   completion: { error in
                                                    seal.fulfill(())
            })
            
        }
    }
    
    func fetchLocalData() -> Promise<Void> {
        return Promise { seal in
            guard let set = _set,
                let languageCode = _languageCode else {
                seal.fulfill(())
                return
            }
            
            let request: NSFetchRequest<CMCard> = CMCard.fetchRequest()
            let count = queryString.count
            var predicate = NSPredicate(format: "set.code = %@ AND language.code = %@", set.code!, languageCode)
            
            
            if count > 0 {
                if count == 1 {
                    let newPredicate = NSPredicate(format: "name BEGINSWITH[cd] %@", queryString)
                    predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate, newPredicate])
                } else {
                    let newPredicate = NSPredicate(format: "name CONTAINS[cd] %@", queryString)
                    predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate, newPredicate])
                }
            }
            request.predicate = predicate
            request.sortDescriptors = self._sortDescriptors
            
            self._fetchedResultsController = self.getFetchedResultsController(with: request)
            self.updateSections()
            
            seal.fulfill(())
        }
    }

    // MARK: private methods
    private func getFetchedResultsController(with fetchRequest: NSFetchRequest<CMCard>?) -> NSFetchedResultsController<CMCard> {
        var request: NSFetchRequest<CMCard>?
        
        if let fetchRequest = fetchRequest {
            request = fetchRequest
        } else {
            // Create a default fetchRequest
            request = CMCard.fetchRequest()
            request!.sortDescriptors = _sortDescriptors
        }
        
        // Create Fetched Results Controller
        let frc = NSFetchedResultsController(fetchRequest: request!,
                                             managedObjectContext: context,
                                             sectionNameKeyPath: _sectionName,
                                             cacheName: nil)
        
        // Configure Fetched Results Controller
        frc.delegate = self
        
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
    
//    func fetchPrices() {
//        guard let set = _set else {
//            return
//        }
//
//        firstly {
//            ManaKit.sharedInstance.authenticateTcgPlayer()
//        }.then {
//            ManaKit.sharedInstance.getTcgPlayerPrices(forSet: set)
//        }.done {
//            print("Done fetching prices")
//        }.catch { error in
//            print(error)
//        }
//    }

    private func updateSections() {
        guard let fetchedResultsController = _fetchedResultsController,
            let sections = fetchedResultsController.sections else {
            return
        }
        
        _sectionIndexTitles = [String]()
        _sectionTitles = [String]()
        
//        for card in results {
//            if let section = set.myNameSection {
//                if !_sectionTitles.contains(section) {
//                    _sectionTitles.append(section)
//                }
//
//                if !_sectionIndexTitles.contains(section) {
//                    _sectionIndexTitles.append(section)
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
}

// MARK: NSFetchedResultsControllerDelegate
extension SetViewModel : NSFetchedResultsControllerDelegate {
    
}
