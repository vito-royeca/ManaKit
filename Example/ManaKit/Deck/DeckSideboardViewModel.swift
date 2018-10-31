//
//  DeckSideboardViewModel.swift
//  ManaKit_Example
//
//  Created by Jovito Royeca on 07.09.18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import CoreData
import ManaKit

class DeckSideboardViewModel: NSObject {
    // MARK: Variables
    private var _deck: CMDeck?
    private var _fetchedResultsController: NSFetchedResultsController<CMInventory>?
    
    // MARK: Settings
    private let _sortDescriptors = [NSSortDescriptor(key: "card.name", ascending: true)]
    private var _sectionName: String?
    
    // MARK: Overrides
    init(withDeck deck: CMDeck) {
        super.init()
        _deck = deck
    }
    
    // MARK: UITableView methods
    func numberOfRows(inSection section: Int) -> Int {
        guard let fetchedResultsController = _fetchedResultsController,
            let sections = fetchedResultsController.sections else {
            return 0
        }
        
        if section == 0 {
            return 1
        } else {
            return sections[section - 1].numberOfObjects
        }
    }
    
    func numberOfSections() -> Int {
        guard let fetchedResultsController = _fetchedResultsController,
            let sections = fetchedResultsController.sections else {
                return 0
        }
        
        return sections.count + 1
    }
    
    func sectionIndexTitles() -> [String]? {
        return nil
    }
    
    func sectionForSectionIndexTitle(title: String, at index: Int) -> Int {
        return 0
    }
    
    func titleForHeaderInSection(section: Int) -> String? {
        return nil
    }
    
    // MARK: Custom methods
    func object(forRowAt indexPath: IndexPath) -> CMInventory {
        guard let fetchedResultsController = _fetchedResultsController else {
            fatalError("fetchedResultsController is nil")
        }
        return fetchedResultsController.object(at: IndexPath(row: indexPath.row, section: indexPath.section - 1))
    }
    
    func objectTitle() -> String? {
        guard let deck = _deck else {
            return nil
        }
        return deck.name
    }
    
    func fetchData() {
        guard let deck = _deck else {
            return
        }
        
        let request: NSFetchRequest<CMInventory> = CMInventory.fetchRequest()
        let predicate = NSPredicate(format: "deck = %@ AND sideboard = YES", deck)
        
        request.predicate = predicate
        request.sortDescriptors = _sortDescriptors
        
        _fetchedResultsController = getFetchedResultsController(with: request)
    }
    
    private func getFetchedResultsController(with fetchRequest: NSFetchRequest<CMInventory>?) -> NSFetchedResultsController<CMInventory> {
        let context = ManaKit.sharedInstance.dataStack!.viewContext
        var request: NSFetchRequest<CMInventory>?
        
        if let fetchRequest = fetchRequest {
            request = fetchRequest
        } else {
            // Create a default fetchRequest
            request = CMInventory.fetchRequest()
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
}

// MARK: NSFetchedResultsControllerDelegate
extension DeckSideboardViewModel : NSFetchedResultsControllerDelegate {
    
}


