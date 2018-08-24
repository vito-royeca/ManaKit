//
//  SetsViewController.swift
//  ManaKit
//
//  Created by Jovito Royeca on 15/04/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import CoreData
import ManaKit

class SetsViewController: UIViewController {

    // MARK: Constants
    let searchController = UISearchController(searchResultsController: nil)
    
    // MARK: Variables
    var fetchedResultsController: NSFetchedResultsController<CMSet>?
    
    // MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Overrides
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        fetchedResultsController = getFetchedResultsController(with: nil)
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showSet" {
            guard let dest = segue.destination as? SetViewController,
                let set = sender as? CMSet else {
                return
            }
            
            dest.set = set
            dest.title = set.name
        }
    }
    
    // MARK: Custom methods
    func getFetchedResultsController(with fetchRequest: NSFetchRequest<CMSet>?) -> NSFetchedResultsController<CMSet> {
        let context = ManaKit.sharedInstance.dataStack!.viewContext
        var request: NSFetchRequest<CMSet>?
        
        if let fetchRequest = fetchRequest {
            request = fetchRequest
        } else {
            // Create a default fetchRequest
            request = CMSet.fetchRequest()
            request!.sortDescriptors = [NSSortDescriptor(key: "releaseDate", ascending: false)]
        }

        // Create Fetched Results Controller
        let frc = NSFetchedResultsController(fetchRequest: request!,
                                             managedObjectContext: context,
                                             sectionNameKeyPath: nil,
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
    
    func doSearch() {
        guard let text = searchController.searchBar.text else {
            return
        }
        
        let request: NSFetchRequest<CMSet> = CMSet.fetchRequest()
        let count = text.count
        
        if count > 0 {
            if count == 1 {
                request.predicate = NSPredicate(format: "name BEGINSWITH[cd] %@ OR code BEGINSWITH[cd] %@", text, text)
            } else {
                request.predicate = NSPredicate(format: "name CONTAINS[cd] %@ OR code CONTAINS[cd] %@", text, text)
            }
        }
        request.sortDescriptors = [NSSortDescriptor(key: "releaseDate", ascending: false)]
        
        fetchedResultsController = getFetchedResultsController(with: request)
        tableView.reloadData()
    }
}

// MARK: UITableViewDataSource
extension SetsViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let fetchedResultsController = fetchedResultsController,
            let sets = fetchedResultsController.fetchedObjects else {
            return 0
        }
        
        return sets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let fetchedResultsController = fetchedResultsController,
            let cell = tableView.dequeueReusableCell(withIdentifier: SetTableViewCell.reuseIdentifier,
                                                       for: indexPath) as? SetTableViewCell else {
            fatalError("Unexpected indexPath: \(indexPath)")
        }
        
        let set = fetchedResultsController.object(at: indexPath)
        
        // Configure Cell
        cell.setLogo.text = ManaKit.sharedInstance.keyruneUnicode(forSet: set)
        cell.setLogo.textColor = UIColor.black
        cell.setName.text = set.name
        cell.setCode.text = set.code
        
        return cell
    }
}

// MARK: UITableViewDelegate
extension SetsViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let fetchedResultsController = fetchedResultsController else {
            return
        }
        
        let set = fetchedResultsController.object(at: indexPath)
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

// MARK: NSFetchedResultsControllerDelegate
extension SetsViewController : NSFetchedResultsControllerDelegate {
    
}


