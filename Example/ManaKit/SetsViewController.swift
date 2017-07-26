//
//  SetsViewController.swift
//  ManaKit
//
//  Created by Jovito Royeca on 15/04/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import ManaKit
import DATASource

class SetsViewController: UIViewController {

    // MARK: Variables
    var dataSource: DATASource?
    let searchController = UISearchController(searchResultsController: nil)
    
    // MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Overrides
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        dataSource = getDataSource(nil)
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showSet" {
            if let dest = segue.destination as? SetViewController,
                let set = sender as? CMSet {
                
                dest.set = set
                dest.title = set.name
            }
        }
    }
    
    // MARK: Custom methods
    func getDataSource(_ fetchRequest: NSFetchRequest<NSFetchRequestResult>?) -> DATASource? {
        var request:NSFetchRequest<NSFetchRequestResult>?
        
        if let fetchRequest = fetchRequest {
            request = fetchRequest
        } else {
            request = NSFetchRequest(entityName: "CMSet")
            request!.sortDescriptors = [NSSortDescriptor(key: "releaseDate", ascending: false)]
        }
        
        let dataSource = DATASource(tableView: tableView, cellIdentifier: "SetCell", fetchRequest: request!, mainContext: ManaKit.sharedInstance.dataStack!.mainContext, configuration: { cell, item, indexPath in
            if let set = item as? CMSet {

                if let setIconView = cell.contentView.viewWithTag(100) as? UIImageView {
                    setIconView.image = ManaKit.sharedInstance.setImage(set: set, rarity: nil)
                }
                if let label = cell.contentView.viewWithTag(200) as? UILabel {
                    label.text = set.name
                }
                if let label = cell.contentView.viewWithTag(300) as? UILabel {
                    label.text = set.code
                }
                if let label = cell.contentView.viewWithTag(400) as? UILabel {
                    label.text = set.releaseDate
                }
                if let label = cell.contentView.viewWithTag(500) as? UILabel {
                    label.text = "\(set.cards!.allObjects.count) cards"
                }
            }
        })
        
        return dataSource
    }
    
    func doSearch() {
        var filteredSets:[CMSet]?
        var request:NSFetchRequest<NSFetchRequestResult>?
        
        dataSource = getDataSource(nil)
        
        if let text = searchController.searchBar.text {
            let count = text.characters.count
            let sets = dataSource!.all() as! [CMSet]
            
            if count > 0 {
                filteredSets = sets.filter({
                    let nameLower = $0.name!.lowercased()
                    let codeLower = $0.code!.lowercased()
                    let textLower = text.lowercased()
                    
                    if count == 1 {
                        return nameLower.hasPrefix(textLower)
                    } else {
                        return nameLower.range(of: textLower) != nil ||
                            codeLower.hasPrefix(textLower)
                    }
                })
            } else {
                filteredSets = nil
            }
            
        } else {
            filteredSets = nil
        }
        
        if let filteredSets = filteredSets {
            request = NSFetchRequest(entityName: "CMSet")
            request!.predicate = NSPredicate(format: "code in %@", filteredSets.map { $0.code })
            request!.sortDescriptors = [NSSortDescriptor(key: "releaseDate", ascending: false)]
        }
        
        dataSource = getDataSource(request)
        tableView.reloadData()
    }
}

// MARK: UITableViewDelegate
extension SetsViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sets = dataSource!.all()
        let set = sets[indexPath.row]
        performSegue(withIdentifier: "showSet", sender: set)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(66)
    }
}

// MARK: UISearchResultsUpdating
extension SetsViewController : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        doSearch()
    }
}
