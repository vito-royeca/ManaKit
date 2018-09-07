//
//  DecksViewController.swift
//  ManaKit_Example
//
//  Created by Jovito Royeca on 23.08.18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import ManaKit

class DecksViewController: UIViewController {

    // MARK: Variables
    let searchController = UISearchController(searchResultsController: nil)
    var viewModel: DecksViewModel!
    
    // MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Overrides
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        definesPresentationContext = true
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        
        tableView.tableHeaderView = searchController.searchBar
        tableView.register(ManaKit.sharedInstance.nibFromBundle("DeckTableViewCell"),
                           forCellReuseIdentifier: DeckTableViewCell.reuseIdentifier)
        
        viewModel.performSearch()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDeck" {
            guard let dest = segue.destination as? DeckViewController,
                let deck = sender as? CMDeck else {
                return
            }
    
            let mainboardViewModel = DeckMainboardViewModel(withDeck: deck)
            let sideboardViewModel = DeckSideboardViewModel(withDeck: deck)
            dest.mainboardViewModel = mainboardViewModel
            dest.sideboardViewModel = sideboardViewModel
        }
    }
    
    // MARK: Custom methods
    
}

// MARK: UITableViewDataSource
extension DecksViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.tableViewNumberOfRows(inSection: section)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.tableViewNumberOfSections()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DeckTableViewCell.reuseIdentifier,
                                                       for: indexPath) as? DeckTableViewCell else {
            fatalError("Unexpected indexPath: \(indexPath)")
        }
        
        cell.deck = viewModel.object(forRowAt: indexPath)
        return cell
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return viewModel.tableViewSectionIndexTitles()
    }
    
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return viewModel.tableViewSectionForSectionIndexTitle(title: title, at: index)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.tableViewTitleForHeaderInSection(section: section)
    }
}

// MARK: UITableViewDelegate
extension DecksViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let deck = viewModel.object(forRowAt: indexPath)
        performSegue(withIdentifier: "showDeck", sender: deck)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(88)
    }
}

// MARK: UISearchResultsUpdating
extension DecksViewController : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else {
            return
        }
        
        viewModel.queryString = text
        viewModel.performSearch()
        tableView.reloadData()
    }
}
