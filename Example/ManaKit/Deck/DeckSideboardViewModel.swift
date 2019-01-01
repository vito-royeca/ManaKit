//
//  DeckSideboardViewModel.swift
//  ManaKit_Example
//
//  Created by Jovito Royeca on 07.09.18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import ManaKit
import RealmSwift

class DeckSideboardViewModel: NSObject {
    // MARK: Variables
    private var _deck: CMDeck?
    private var _results: Results<CMInventory>? = nil
    
    // MARK: Settings
    private let _sortDescriptors = [SortDescriptor(keyPath: "card.name", ascending: true)]
    private var _sectionName: String?
    
    // MARK: Overrides
    init(withDeck deck: CMDeck) {
        super.init()
        _deck = deck
    }
    
    // MARK: UITableView methods
    func numberOfRows(inSection section: Int) -> Int {
        guard let _ = _results else {
            return 0
        }
        
        if section == 0 {
            return 1
        } else {
            //return sections[section - 1].numberOfObjects
            return 0
        }
    }
    
    func numberOfSections() -> Int {
        guard let _ = _results else {
            return 0
        }
        
//        return sections.count + 1
        return 0
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
        guard let results = _results else {
            fatalError("results is nil")
        }
//        return results.filter("\(_sectionName) == %@", _sectionTitles[indexPath.section])[indexPath.row]
        return results[indexPath.row - 1]
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
        
        let predicate = NSPredicate(format: "deck = %@ AND sideboard = YES", deck)
        
        _results = ManaKit.sharedInstance.realm.objects(CMInventory.self).filter(predicate).sorted(by: _sortDescriptors)
    }
}

