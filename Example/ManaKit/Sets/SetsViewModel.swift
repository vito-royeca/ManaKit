//
//  SetsViewModel.swift
//  ManaKit_Example
//
//  Created by Jovito Royeca on 31.08.18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import CoreData
import ManaKit

class SetsViewModel: NSObject {
    // MARK: Variables
    var queryString = ""
    
    private var _sectionIndexTitles = [String]()
    private var _sectionTitles = [String]()
    private var _fetchedResultsController: NSFetchedResultsController<CMSet>?
    
    // MARK: Settings
    private let _sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
    private var _sectionName = "nameSection"
    
    // MARK: Overrides
    override init() {
        super.init()
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
    func object(forRowAt indexPath: IndexPath) -> CMSet {
        guard let fetchedResultsController = _fetchedResultsController else {
            fatalError("fetchedResultsController is nil")
        }
        return fetchedResultsController.object(at: indexPath)
    }
    
    func fetchData() {
        let request: NSFetchRequest<CMSet> = CMSet.fetchRequest()
        let count = queryString.count
        
        if count > 0 {
            if count == 1 {
                request.predicate = NSPredicate(format: "name BEGINSWITH[cd] %@ OR code BEGINSWITH[cd] %@", queryString, queryString)
            } else {
                request.predicate = NSPredicate(format: "name CONTAINS[cd] %@ OR code CONTAINS[cd] %@", queryString, queryString)
            }
        }
        request.sortDescriptors = _sortDescriptors
        
        _fetchedResultsController = getFetchedResultsController(with: request)
        updateSections()
    }
    
    private func getFetchedResultsController(with fetchRequest: NSFetchRequest<CMSet>?) -> NSFetchedResultsController<CMSet> {
        let context = ManaKit.sharedInstance.dataStack!.viewContext
        var request: NSFetchRequest<CMSet>?
        
        if let fetchRequest = fetchRequest {
            request = fetchRequest
        } else {
            // Create a default fetchRequest
            request = CMSet.fetchRequest()
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
            if let nameSection = set.nameSection {
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
extension SetsViewModel : NSFetchedResultsControllerDelegate {
    
}
