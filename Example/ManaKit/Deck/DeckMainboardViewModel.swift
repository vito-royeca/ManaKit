//
//  DeckMainboardViewModel.swift
//  ManaKit_Example
//
//  Created by Jovito Royeca on 07.09.18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import ManaKit
import RealmSwift

class DeckMainboardViewModel: NSObject {
    // MARK: Variables
    var deck: CMDeck?
    
    private var _sectionIndexTitles = [String]()
    private var _sectionTitles = [String]()
    private var _results: Results<CMInventory>? = nil
    
    // MARK: Settings
    private let _sortDescriptors = [SortDescriptor(keyPath: "card.typeSection", ascending: true),
                                    SortDescriptor(keyPath: "card.name", ascending: true)]
    private var _sectionName = "card.typeSection"
    
    // MARK: Overrides
    init(withDeck deck: CMDeck) {
        super.init()
        self.deck = deck
    }
    
    // MARK: UITableView methods
    func numberOfRows(inSection section: Int) -> Int {
        guard let results = _results else {
            return 0
        }
        
        return results.filter("\(_sectionName) == %@", _sectionTitles[section]).count
    }
    
    func numberOfSections() -> Int {
        guard let _ = _results else {
            return 0
        }
        
        return _sectionTitles.count
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
            guard let _ = _results else {
                return nil
            }
            
//            var count = 0
//            if let objects = sections[section - 1].objects as? [CMInventory] {
//                for cardInventory in objects {
//                    count += Int(cardInventory.quantity)
//                }
//            }
//
//            return "\(sections[section - 1].name): \(count)"
            return _sectionTitles[section]
        }
    }
    
    // MARK: Custom methods
    func object(forRowAt indexPath: IndexPath) -> CMInventory {
//        guard let fetchedResultsController = _fetchedResultsController else {
//            fatalError("fetchedResultsController is nil")
//        }
//        return fetchedResultsController.object(at: IndexPath(row: indexPath.row, section: indexPath.section - 1))
        guard let results = _results else {
            fatalError("results is nil")
        }
        return results.filter("\(_sectionName) == %@", _sectionTitles[indexPath.section])[indexPath.row]
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
        
        let predicate = NSPredicate(format: "deck = %@ AND mainboard = YES", deck)
        
        _results = ManaKit.sharedInstance.realm.objects(CMInventory.self).filter(predicate).sorted(by: _sortDescriptors)
        updateSections()
    }
    
    private func updateSections() {
        guard let _ = _results else {
            return
        }
        
        _sectionIndexTitles = [String]()
        _sectionTitles = [String]()
        
//        for cardInventory in cardInventories {
//            if let card = cardInventory.card,
//                let type = card.typeLine,
//                let nameSection = type.nameSection {
//                if !_sectionIndexTitles.contains(nameSection) {
//                    _sectionIndexTitles.append(nameSection)
//                }
//            }
//        }
//
//        let count = sections.count
//        if count > 0 {
//            for i in 0...count - 1 {
//                if let sectionTitle = sections[i].indexTitle {
//                    _sectionTitles.append(sectionTitle)
//                }
//            }
//        }
        
        _sectionIndexTitles.sort()
        _sectionTitles.sort()
    }
}
