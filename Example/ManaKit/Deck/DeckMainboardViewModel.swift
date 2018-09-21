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
    var deck: CMDeck?
    
    private var _sectionIndexTitles = [String]()
    private var _sectionTitles = [String]()
    private var _fetchedResultsController: NSFetchedResultsController<CMCardInventory>?
    
    // MARK: Settings
    private let _sortDescriptors = [NSSortDescriptor(key: "card.typeSection", ascending: true),
                                   NSSortDescriptor(key: "card.name", ascending: true)]
    private var _sectionName = "card.typeSection"
    
    // MARK: Overrides
    init(withDeck deck: CMDeck) {
        super.init()
        self.deck = deck
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
        return _sectionIndexTitles.map({ String($0.prefix(1)) })
    }
    
    func sectionForSectionIndexTitle(title: String, at index: Int) -> Int {
        var sectionIndex = 0
        
        for i in 0..._sectionTitles.count - 1 {
            if _sectionTitles[i].hasPrefix(title) {
                sectionIndex = i
                break
            }
        }
        
        return sectionIndex + 1
    }
    
    func titleForHeaderInSection(section: Int) -> String? {
        if section == 0 {
            return nil
        } else {
            guard let fetchedResultsController = _fetchedResultsController,
                let sections = fetchedResultsController.sections else {
                    return nil
            }
            
            var count = 0
            if let objects = sections[section - 1].objects as? [CMCardInventory] {
                for cardInventory in objects {
                    count += Int(cardInventory.quantity)
                }
            }
            
            return "\(sections[section - 1].name): \(count)"
        }
    }
    
    // MARK: Custom methods
    func object(forRowAt indexPath: IndexPath) -> CMCardInventory {
        guard let fetchedResultsController = _fetchedResultsController else {
            fatalError("fetchedResultsController is nil")
        }
        return fetchedResultsController.object(at: IndexPath(row: indexPath.row, section: indexPath.section - 1))
    }
    
    func objectTitle() -> String? {
        guard let deck = deck else {
            return nil
        }
        return deck.name
    }
    
    func fetchData() {
        guard let deck = deck else {
            return
        }
        
        let request: NSFetchRequest<CMCardInventory> = CMCardInventory.fetchRequest()
        let predicate = NSPredicate(format: "deck = %@ AND mainboard = YES", deck)
        
        request.predicate = predicate
        request.sortDescriptors = _sortDescriptors
        
        _fetchedResultsController = getFetchedResultsController(with: request)
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
            let cardInventories = fetchedResultsController.fetchedObjects,
            let sections = fetchedResultsController.sections else {
                return
        }
        
        _sectionIndexTitles = [String]()
        _sectionTitles = [String]()
        
        for cardInventory in cardInventories {
            if let card = cardInventory.card,
                let typeSection = card.typeSection {
                if !_sectionIndexTitles.contains(typeSection) {
                    _sectionIndexTitles.append(typeSection)
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
extension DeckMainboardViewModel : NSFetchedResultsControllerDelegate {
    
}


