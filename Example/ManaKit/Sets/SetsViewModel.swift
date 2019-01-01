//
//  SetsViewModel.swift
//  ManaKit_Example
//
//  Created by Jovito Royeca on 31.08.18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import ManaKit
import RealmSwift

class SetsViewModel: NSObject {
    // MARK: Variables
    var queryString = ""
    var searchCancelled = false

    private var _sectionIndexTitles = [String]()
    private var _sectionTitles = [String]()
    private var _results: Results<CMSet>? = nil
    
    // MARK: Settings
    private let _sortDescriptors = [SortDescriptor(keyPath: "releaseDate", ascending: false)]
    private var _sectionName = "myYearSection"
    
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
    func object(forRowAt indexPath: IndexPath) -> CMSet {
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
                predicate = NSPredicate(format: "name BEGINSWITH[cd] %@ OR code BEGINSWITH[cd] %@", queryString, queryString)
            } else {
                predicate = NSPredicate(format: "name CONTAINS[cd] %@ OR code CONTAINS[cd] %@", queryString, queryString)
            }
            _results = ManaKit.sharedInstance.realm.objects(CMSet.self).filter(predicate!).sorted(by: _sortDescriptors)
        } else {
            _results = ManaKit.sharedInstance.realm.objects(CMSet.self).sorted(by: _sortDescriptors)
        }
        
        updateSections()
    }
    
    private func updateSections() {
        guard let results = _results else {
            return
        }
        
        _sectionIndexTitles = [String]()
        _sectionTitles = [String]()
        
        for set in results {
            if let nameSection = set.myNameSection {
                if !_sectionTitles.contains(nameSection) {
                    _sectionTitles.append(nameSection)
                }
            }
        }
        
//        let count = sections.count
//        if count > 0 {
//            for i in 0...count - 1 {
//                if let sectionTitle = sections[i].indexTitle {
//                    _sectionTitles.append(sectionTitle)
//                }
//                _sectionTitles.append(sections[i].name)
//            }
//        }
        
        _sectionIndexTitles.sort()
        _sectionTitles.sort()
    }
}
