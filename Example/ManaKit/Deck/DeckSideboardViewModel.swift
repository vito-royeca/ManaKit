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
    private var deck: CMDeck?
    private var fetchedResultsController: NSFetchedResultsController<CMCardInventory>?
    
    // MARK: Settings
    private let sortDescriptors = [NSSortDescriptor(key: "card.name", ascending: true)]
    private var sectionName: String?
    
    // MARK: Overrides
    init(withDeck deck: CMDeck) {
        super.init()
        self.deck = deck
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
        return nil
    }
    
    func tableViewSectionForSectionIndexTitle(title: String, at index: Int) -> Int {
        return 0
    }
    
    func tableViewTitleForHeaderInSection(section: Int) -> String? {
        guard let fetchedResultsController = fetchedResultsController,
            let sections = fetchedResultsController.sections else {
                return nil
        }
        
        return sections[section].name
    }
    
    // MARK: Custom methods
    func object(forRowAt indexPath: IndexPath) -> CMCardInventory {
        guard let fetchedResultsController = fetchedResultsController else {
            fatalError("fetchedResultsController is nil")
        }
        return fetchedResultsController.object(at: indexPath)
    }
    
    func objectTitle() -> String? {
        guard let deck = deck else {
            return nil
        }
        return deck.name
    }
    
    func performSearch() {
        guard let deck = deck else {
            return
        }
        
        let request: NSFetchRequest<CMCardInventory> = CMCardInventory.fetchRequest()
        let predicate = NSPredicate(format: "deck = %@ AND sideboard = YES", deck)
        
        request.predicate = predicate
        request.sortDescriptors = sortDescriptors
        
        fetchedResultsController = getFetchedResultsController(with: request)
    }
    
    private func getFetchedResultsController(with fetchRequest: NSFetchRequest<CMCardInventory>?) -> NSFetchedResultsController<CMCardInventory> {
        let context = ManaKit.sharedInstance.dataStack!.viewContext
        var request: NSFetchRequest<CMCardInventory>?
        
        if let fetchRequest = fetchRequest {
            request = fetchRequest
        } else {
            // Create a default fetchRequest
            request = CMCardInventory.fetchRequest()
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
}

// MARK: NSFetchedResultsControllerDelegate
extension DeckSideboardViewModel : NSFetchedResultsControllerDelegate {
    
}


