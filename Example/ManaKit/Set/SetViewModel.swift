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
    
    private var set: CMSet?
    private var sectionIndexTitles = [String]()
    private var sectionTitles = [String]()
    private var fetchedResultsController: NSFetchedResultsController<CMCard>?
    
    // MARK: Settings
    private let sortDescriptors = [NSSortDescriptor(key: "name", ascending: true),
                                   NSSortDescriptor(key: "number", ascending: true)]
    private var sectionName = "nameSection"
    
    // MARK: Overrides
    init(withSet set: CMSet) {
        super.init()
        self.set = set
    }
    
    // MARK: UITableView methods
    func tableViewNumberOfRows(inSection section: Int) -> Int {
        guard let fetchedResultsController = fetchedResultsController,
            let sections = fetchedResultsController.sections else {
                return 0
        }
        
        return sections[section].numberOfObjects
    }
    
    func tableViewNumberOfSections() -> Int {
        guard let fetchedResultsController = fetchedResultsController,
            let sections = fetchedResultsController.sections else {
                return 0
        }
        
        return sections.count
    }
    
    func tableViewSectionIndexTitles() -> [String]? {
        return sectionIndexTitles
    }
    
    func tableViewSectionForSectionIndexTitle(title: String, at index: Int) -> Int {
        var sectionIndex = 0
        
        for i in 0...sectionTitles.count - 1 {
            if sectionTitles[i].hasPrefix(title) {
                sectionIndex = i
                break
            }
        }
        
        return sectionIndex
    }
    
    func tableViewTitleForHeaderInSection(section: Int) -> String? {
        guard let fetchedResultsController = fetchedResultsController,
            let sections = fetchedResultsController.sections else {
                return nil
        }
        
        return sections[section].name
    }
    
    // MARK: Custom methods
    func object(forRowAt indexPath: IndexPath) -> CMCard {
        guard let fetchedResultsController = fetchedResultsController else {
            fatalError("fetchedResultsController is nil")
        }
        return fetchedResultsController.object(at: indexPath)
    }
    
    func objectTitle() -> String? {
        guard let set = set else {
            return nil
        }
        return set.name
    }

    func performSearch() {
        guard let set = set else {
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
        
        request.sortDescriptors = sortDescriptors
        
        fetchedResultsController = getFetchedResultsController(with: request)
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
            request!.sortDescriptors = sortDescriptors
        }
        
        // Create Fetched Results Controller
        let frc = NSFetchedResultsController(fetchRequest: request!,
                                             managedObjectContext: context,
                                             sectionNameKeyPath: sectionName,
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
        guard let fetchedResultsController = fetchedResultsController,
            let sets = fetchedResultsController.fetchedObjects,
            let sections = fetchedResultsController.sections else {
                return
        }
        
        sectionIndexTitles = [String]()
        sectionTitles = [String]()
        
        for set in sets {
            if let nameSection = set.nameSection {
                if !sectionIndexTitles.contains(nameSection) {
                    sectionIndexTitles.append(nameSection)
                }
            }
        }
        
        let count = sections.count
        if count > 0 {
            for i in 0...count - 1 {
                if let sectionTitle = sections[i].indexTitle {
                    sectionTitles.append(sectionTitle)
                }
            }
        }
        
        sectionIndexTitles.sort()
        sectionTitles.sort()
    }
}

// MARK: NSFetchedResultsControllerDelegate
extension SetViewModel : NSFetchedResultsControllerDelegate {
    
}

