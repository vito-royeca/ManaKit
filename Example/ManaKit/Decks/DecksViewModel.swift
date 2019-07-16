//
//  DecksViewModel.swift
//  ManaKit_Example
//
//  Created by Jovito Royeca on 06.09.18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import ManaKit
import RealmSwift

class DecksViewModel: NSObject {
    // MARK: Variables
    var queryString = ""
    
    private var _sectionIndexTitles = [String]()
    private var _sectionTitles = [String]()
    private var _results: Results<CMDeck>? = nil
    
    // MARK: Settings
    private let _sortDescriptors = [SortDescriptor(keyPath: "name", ascending: true)]
    private var _sectionName = "nameSection"
    
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
        guard let _ = _results else {
            return nil
        }
        
        return _sectionTitles[section]
    }
    
    // MARK: Custom methods
    func object(forRowAt indexPath: IndexPath) -> CMDeck {
        guard let results = _results else {
            fatalError("results is nil")
        }
        return results.filter("\(_sectionName) == %@", _sectionTitles[indexPath.section])[indexPath.row]
    }
    
    func fetchData() {
        var predicate: NSPredicate?
        let count = queryString.count
        
        if count > 0 {
            if count == 1 {
                predicate = NSPredicate(format: "name BEGINSWITH[cd] %@", queryString)
            } else {
                predicate = NSPredicate(format: "name CONTAINS[cd] %@", queryString)
            }
        }
        
        _results = ManaKit.sharedInstance.realm.objects(CMDeck.self).filter(predicate!).sorted(by: _sortDescriptors)
        updateSections()
    }
    
    private func updateSections() {
        guard let _ = _results else {
            return
        }
        
        _sectionIndexTitles = [String]()
        _sectionTitles = [String]()
        
//        for set in sets {
//            if let nameSection = set.nameSection {
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
