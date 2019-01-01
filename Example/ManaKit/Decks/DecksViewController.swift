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
    let viewModel = DecksViewModel()
    
    // MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Overrides
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        definesPresentationContext = true
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Filter"
        searchController.dimsBackgroundDuringPresentation = false
        
        if #available(iOS 11.0, *) {
            navigationItem.searchController = searchController
            navigationItem.hidesSearchBarWhenScrolling = false
        } else {
            tableView.tableHeaderView = searchController.searchBar
        }
        tableView.keyboardDismissMode = .onDrag
        tableView.register(ManaKit.sharedInstance.nibFromBundle("DeckTableViewCell"),
                           forCellReuseIdentifier: DeckTableViewCell.reuseIdentifier)
        
//        viewModel.fetchData()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if #available(iOS 11.0, *) {
            navigationItem.hidesSearchBarWhenScrolling = true
        }
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
        return viewModel.numberOfRows(inSection: section)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections()
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
        return viewModel.sectionIndexTitles()
    }
    
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return viewModel.sectionForSectionIndexTitle(title: title, at: index)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.titleForHeaderInSection(section: section)
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
        viewModel.fetchData()
        tableView.reloadData()
    }
}
