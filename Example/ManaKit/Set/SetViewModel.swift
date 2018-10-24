//
//  SetViewModel.swift
//  ManaKit_Example
//
//  Created by Jovito Royeca on 06.09.18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import CoreData
import ManaKit

class SetViewModel: NSObject {
    // MARK: Variables
    var queryString = ""
    
    private var _set: CMSet?
    private var _sectionIndexTitles = [String]()
    private var _sectionTitles = [String]()
    private var _fetchedResultsController: NSFetchedResultsController<CMCard>?
    
    // MARK: Settings
    private let _sortDescriptors = [NSSortDescriptor(key: "name", ascending: true),
                                   NSSortDescriptor(key: "collectorNumber", ascending: true)]
    private var _sectionName = "myNameSection"
    
    // MARK: Overrides
    init(withSet set: CMSet) {
        super.init()
        _set = set
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
    func object(forRowAt indexPath: IndexPath) -> CMCard {
        guard let fetchedResultsController = _fetchedResultsController else {
            fatalError("fetchedResultsController is nil")
        }
        return fetchedResultsController.object(at: indexPath)
    }
    
    func objectTitle() -> String? {
        guard let set = _set else {
            return nil
        }
        return set.name
    }

    func fetchData() {
        guard let set = _set else {
            return
        }
        
        let request: NSFetchRequest<CMCard> = CMCard.fetchRequest()
        let predicate = NSPredicate(format: "set = %@", set)
        let count = queryString.count
        
        if count > 0 {
            if count == 1 {
                let newPredicate = NSPredicate(format: "name BEGINSWITH[cd] %@", queryString)
                request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate, newPredicate])
            } else {
                let newPredicate = NSPredicate(format: "name CONTAINS[cd] %@", queryString)
                request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate, newPredicate])
            }
        } else {
            request.predicate = predicate
        }
        
        request.sortDescriptors = _sortDescriptors
        
        _fetchedResultsController = getFetchedResultsController(with: request)
        updateSections()
    }
    
    private func getFetchedResultsController(with fetchRequest: NSFetchRequest<CMCard>?) -> NSFetchedResultsController<CMCard> {
        let context = ManaKit.sharedInstance.dataStack!.viewContext
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
    
    private func updateSections() {
        guard let fetchedResultsController = _fetchedResultsController,
            let sets = fetchedResultsController.fetchedObjects,
            let sections = fetchedResultsController.sections else {
                return
        }
        
        _sectionIndexTitles = [String]()
        _sectionTitles = [String]()
        
        for set in sets {
            if let nameSection = set.myNameSection {
                if !_sectionIndexTitles.contains(nameSection) {
                    _sectionIndexTitles.append(nameSection)
                }
            }
        }
        
        let count = sections.count
        if count > 0 {
            for i in 0...count - 1 {
                if let sectionTitle = sections[i].indexTitle {
                    _sectionTitles.append(sectionTitle)
                }
            }
        }
        
        _sectionIndexTitles.sort()
        _sectionTitles.sort()
    }
}

// MARK: NSFetchedResultsControllerDelegate
extension SetViewModel : NSFetchedResultsControllerDelegate {
    
}

