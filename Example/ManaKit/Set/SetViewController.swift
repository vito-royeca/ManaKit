//
//  SetViewController.swift
//  ManaKit
//
//  Created by Jovito Royeca on 15/04/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import ManaKit
import MBProgressHUD
import PromiseKit

class SetViewController: UIViewController {

    // MARK: Variables
    let searchController = UISearchController(searchResultsController: nil)
    var viewModel: SetViewModel!
    
    // MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Overrides
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Filter"
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        
        if #available(iOS 11.0, *) {
            navigationItem.searchController = searchController
            navigationItem.hidesSearchBarWhenScrolling = false
        } else {
            tableView.tableHeaderView = searchController.searchBar
        }
        tableView.keyboardDismissMode = .onDrag
        tableView.register(ManaKit.sharedInstance.nibFromBundle("CardTableViewCell"),
                           forCellReuseIdentifier: CardTableViewCell.reuseIdentifier)
        
        title = viewModel.objectTitle()
        fetchData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if #available(iOS 11.0, *) {
            navigationItem.hidesSearchBarWhenScrolling = true
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showCard" {
//            guard let dest = segue.destination as? CardViewController,
//                let card = sender as? CMCard else {
//                return
//            }
//
//            dest.card = card
        }
    }
    
    // MARK: Custom methods
    func fetchData() {
        if viewModel.willFetchRemoteData() {
            MBProgressHUD.showAdded(to: view, animated: true)
            
            firstly {
                viewModel.fetchRemoteData()
            }.compactMap { (data, result) in
                try JSONSerialization.jsonObject(with: data) as? [[String: Any]]
            }.then { data in
                self.viewModel.saveLocalData(data: data)
            }.then {
                self.viewModel.fetchLocalData()
            }.done {
                MBProgressHUD.hide(for: self.view, animated: true)
                self.tableView.reloadData()
            }.catch { error in
                self.viewModel.deleteDataInformation()
                MBProgressHUD.hide(for: self.view, animated: true)
                self.tableView.reloadData()
            }
        } else {
            firstly {
                self.viewModel.fetchLocalData()
            }.done {
                MBProgressHUD.hide(for: self.view, animated: true)
                self.tableView.reloadData()
            }.catch { error in
                self.viewModel.deleteDataInformation()
                MBProgressHUD.hide(for: self.view, animated: true)
                self.tableView.reloadData()
            }
        }
    }
}

// MARK: UITableViewDataSource
extension SetViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(inSection: section)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CardTableViewCell.reuseIdentifier,
                                                       for: indexPath) as? CardTableViewCell else {
            fatalError("Unexpected indexPath: \(indexPath)")
        }
        
        cell.card = viewModel.object(forRowAt: indexPath)
        cell.updateDataDisplay()
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
extension SetViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let card = viewModel.object(forRowAt: indexPath)
        performSegue(withIdentifier: "showCard", sender: card)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CardTableViewCell.cellHeight
    }
}

// MARK: UISearchResultsUpdating
extension SetViewController : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else {
            return
        }
        
        viewModel.queryString = text
        fetchData()
    }
}

// MARK: UISearchBarDelegate
extension SetViewController : UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        viewModel.searchCancelled = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.searchCancelled = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if viewModel.searchCancelled {
            searchBar.text = viewModel.queryString
        } else {
            viewModel.queryString = searchBar.text ?? ""
        }
    }
}
