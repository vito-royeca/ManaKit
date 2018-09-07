//
//  DeckMainboardViewModel.swift
//  ManaKit_Example
//
//  Created by Jovito Royeca on 07.09.18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import CoreData
import ManaKit

class DeckMainboardViewModel: NSObject {
    // MARK: Variables
    private var deck: CMDeck?
    private var sectionIndexTitles = [String]()
    private var sectionTitles = [String]()
    private var fetchedResultsController: NSFetchedResultsController<CMCardInventory>?
    
    // MARK: Settings
    private let sortDescriptors = [NSSortDescriptor(key: "card.typeSection", ascending: true),
                                   NSSortDescriptor(key: "card.name", ascending: true)]
    private var sectionName = "card.typeSection"
    
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
        return sectionIndexTitles.map({ String($0.prefix(1)) })
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
        
        var count = 0
        if let objects = sections[section].objects as? [CMCardInventory] {
            for cardInventory in objects {
                count += Int(cardInventory.quantity)
            }
        }
        
        return "\(sections[section].name): \(count)"
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
        let predicate = NSPredicate(format: "deck = %@ AND mainboard = YES", deck)
        
        request.predicate = predicate
        request.sortDescriptors = sortDescriptors
        
        fetchedResultsController = getFetchedResultsController(with: request)
        updateSections()
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
    
    private func updateSections() {
        guard let fetchedResultsController = fetchedResultsController,
            let cardInventories = fetchedResultsController.fetchedObjects,
            let sections = fetchedResultsController.sections else {
                return
        }
        
        sectionIndexTitles = [String]()
        sectionTitles = [String]()
        
        for cardInventory in cardInventories {
            if let card = cardInventory.card,
                let typeSection = card.typeSection {
                if !sectionIndexTitles.contains(typeSection) {
                    sectionIndexTitles.append(typeSection)
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
extension DeckMainboardViewModel : NSFetchedResultsControllerDelegate {
    
}


